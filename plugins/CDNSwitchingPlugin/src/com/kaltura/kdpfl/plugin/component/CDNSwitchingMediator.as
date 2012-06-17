package com.kaltura.kdpfl.plugin.component
{
	import com.kaltura.kdpfl.model.ConfigProxy;
	import com.kaltura.kdpfl.model.MediaProxy;
	import com.kaltura.kdpfl.model.type.NotificationType;
	import com.kaltura.kdpfl.model.type.StreamerType;
	import com.kaltura.kdpfl.model.vo.StorageProfileVO;
	import com.kaltura.kdpfl.plugin.component.strings.NotificationStrings;
	import com.kaltura.kdpfl.view.media.KMediaPlayerMediator;
	
	import fl.core.UIComponent;
	
	import org.osmf.elements.F4MLoader;
	import org.osmf.elements.ProxyElement;
	import org.osmf.elements.VideoElement;
	import org.osmf.elements.proxyClasses.LoadFromDocumentLoadTrait;
	import org.osmf.events.LoadEvent;
	import org.osmf.events.MediaElementEvent;
	import org.osmf.events.PlayEvent;
	import org.osmf.events.SeekEvent;
	import org.osmf.media.MediaElement;
	import org.osmf.media.MediaPlayer;
	import org.osmf.traits.LoadState;
	import org.osmf.traits.LoadTrait;
	import org.osmf.traits.MediaTraitType;
	import org.osmf.traits.PlayState;
	import org.osmf.traits.PlayTrait;
	import org.osmf.traits.SeekTrait;
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class CDNSwitchingMediator extends Mediator implements IMediator
	{
		public static var NAME : String = "cdnSwitchingMediator";
		
		public var flashvars : Object;
		
		public var mediaProxy : MediaProxy;
		
		public var mediaPlayer : MediaPlayer;
		
		public var prevEntryId : String;
		
		protected var failoverMediaElement : MediaElement;
		
		protected var switchPerformed : Boolean = false;
		
		protected var disableFunctionality : Boolean = false;
		
		public function CDNSwitchingMediator(mediatorName:String=null, viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function onRegister():void
		{
			flashvars = (facade.retrieveProxy(ConfigProxy.NAME) as ConfigProxy).vo.flashvars;
			
			mediaProxy = facade.retrieveProxy( MediaProxy.NAME ) as MediaProxy;
			
			
		}
		
		override public function listNotificationInterests():Array
		{
			var interestArray : Array = [NotificationType.LAYOUT_READY,NotificationType.MEDIA_ERROR, NotificationType.PLAYER_UPDATE_PLAYHEAD, NotificationType.ENTRY_READY, NotificationType.MEDIA_READY];
			
			return interestArray;
		}
		
		override public function handleNotification(notification:INotification):void
		{
			if ( !disableFunctionality )
			{
				switch (notification.getName())
				{
					case NotificationType.LAYOUT_READY:
						mediaPlayer = (facade.retrieveMediator( KMediaPlayerMediator.NAME ) as KMediaPlayerMediator).player;
					
						break;
					
					case NotificationType.ENTRY_READY:
						
						if (mediaProxy.vo.entry.id != prevEntryId)
						{
							switchPerformed = false;
						}
						break;
					
					case NotificationType.MEDIA_READY:
						
						if (!(viewComponent as cdnSwitchingPluginCode).secondaryStorageId || (viewComponent as cdnSwitchingPluginCode).secondaryStorageId == "")
						{
							
							if (mediaProxy.vo.availableStorageProfiles && mediaProxy.vo.availableStorageProfiles.length >= 2)
							{
								(viewComponent as cdnSwitchingPluginCode).secondaryStorageId = (mediaProxy.vo.availableStorageProfiles[1] as StorageProfileVO).storageProfileId;
							}
							
						}
						
						if ( mediaProxy.vo.deliveryType && mediaProxy.vo.deliveryType != StreamerType.RTMP)
						{
							disableFunctionality = true;
						}
						
						break;
					
					case NotificationType.MEDIA_ERROR:
						
						if (!switchPerformed && (viewComponent as cdnSwitchingPluginCode).secondaryStorageId && (viewComponent as cdnSwitchingPluginCode).secondaryStorageId != "")
						{
							prevEntryId = mediaProxy.vo.entry.id;
							
							switchPerformed = true;
							
							flashvars.storageId = (viewComponent as cdnSwitchingPluginCode).secondaryStorageId;
							
							sendNotification( NotificationType.CHANGE_MEDIA ,{entryId: mediaProxy.vo.entry.id} );
							
						}
							
						else
						{
							sendNotification( NotificationStrings.NO_SECONDARY_STORAGE_ID );
						}
						
						break;
					
					case NotificationType.PLAYER_UPDATE_PLAYHEAD:
						
						var currentTime : Number = Number(notification.getBody());
						
						
						if (!switchPerformed && currentTime > (viewComponent as cdnSwitchingPluginCode).minimalBRTimecap)
						{
							if ( mediaPlayer.getBitrateForDynamicStreamIndex( mediaPlayer.currentDynamicStreamIndex ) < (viewComponent as cdnSwitchingPluginCode).minimalAcceptableBR)
							{
								switchStorageID();
							}
						}
						
						break;
				}
			}
		}
		
		protected function switchStorageID () : void
		{
			prevEntryId = mediaProxy.vo.entry.id;
			
			switchPerformed = true;
			
			createAndLoadNewElement ();
		}
		
		protected function createAndLoadNewElement () : void
		{
			flashvars.storageId = (viewComponent as cdnSwitchingPluginCode).secondaryStorageId;
			mediaProxy.prepareMediaElement();
			var loadTrait : LoadTrait = mediaProxy.vo.media.getTrait(MediaTraitType.LOAD) as LoadTrait;
			//var loadTrait : LoadFromDocumentLoadTrait = new LoadFromDocumentLoadTrait(new F4MLoader() , mediaProxy.vo.resource );
			//loadTrait.addEventListener( LoadEvent.LOAD_STATE_CHANGE , onFailoverElementLoadStateChange );
			mediaProxy.vo.media.addEventListener(MediaElementEvent.TRAIT_ADD , failoverElementPlayable );
			loadTrait.load();
		}
		
	
		
		
		protected function failoverElementPlayable (e : MediaElementEvent ) : void
		{
			if (e.traitType == MediaTraitType.PLAY )
			{
				trace("playable!");
				
				var failoverElementPlayTrait : PlayTrait = ( mediaProxy.vo.media.getTrait( MediaTraitType.PLAY ) as PlayTrait );
				
				failoverElementPlayTrait.addEventListener( PlayEvent.PLAY_STATE_CHANGE , onFailoverPlayStarted );
				
				failoverElementPlayTrait.play();
			}
		}
		
		protected function onFailoverPlayStarted (e : PlayEvent) : void
		{
			if (e.playState == PlayState.PLAYING )
			{
				
				mediaProxy.vo.media.addEventListener( MediaElementEvent.TRAIT_ADD, onFailOvereekTraitReady );
				
			}
		}
		
		protected function onFailOvereekTraitReady (e : MediaElementEvent ) : void
		{
			if (e.traitType == MediaTraitType.SEEK)
			{
				var failoverElementSeekTrait : SeekTrait = mediaProxy.vo.media.getTrait(MediaTraitType.SEEK) as SeekTrait;
				
				failoverElementSeekTrait.addEventListener( SeekEvent.SEEKING_CHANGE , onFailoverSeekComplete );
				
				failoverElementSeekTrait.seek( mediaPlayer.currentTime );
			}
		}
		
		protected function onFailoverSeekComplete (e : SeekEvent) : void
		{
			if (!e.seeking)
			{
				
				mediaPlayer.media = mediaProxy.vo.media;
			}
		}
		
		
	}
}