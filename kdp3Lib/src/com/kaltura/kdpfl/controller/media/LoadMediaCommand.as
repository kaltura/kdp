package com.kaltura.kdpfl.controller.media
{
	import com.kaltura.kdpfl.model.ConfigProxy;
	import com.kaltura.kdpfl.model.LayoutProxy;
	import com.kaltura.kdpfl.model.MediaProxy;
	import com.kaltura.kdpfl.model.PlayerStatusProxy;
	import com.kaltura.kdpfl.model.SequenceProxy;
	import com.kaltura.kdpfl.model.ServicesProxy;
	import com.kaltura.kdpfl.model.strings.MessageStrings;
	import com.kaltura.kdpfl.model.type.EnableType;
	import com.kaltura.kdpfl.model.type.NotificationType;
	import com.kaltura.kdpfl.model.type.SourceType;
	import com.kaltura.kdpfl.model.type.StreamerType;
	import com.kaltura.kdpfl.plugin.Plugin;
	import com.kaltura.vo.KalturaLiveStreamEntry;
	import com.kaltura.vo.KalturaMixEntry;
	
	import flash.events.Event;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.AsyncCommand;
	
	/**
	 * LoadMediaCommand is responsible for loading a media entry. 
	 */
	public class LoadMediaCommand extends AsyncCommand
	{	
		
		private var _flashvars : Object;
		private var _mediaProxy : MediaProxy;
		
		/**
		 * In case the sourceType of the media is not an entryId, the command constructs the url from which to load the media.
		 * In case the sourceType is entryId, the command checks for the desired flavorId (a specific quality of the desired video) and initiates the
		 * load of the video.
		 * @param notification
		 * 
		 */		
		override public function execute(notification:INotification):void
		{	
			_flashvars = (facade.retrieveProxy( ConfigProxy.NAME ) as ConfigProxy).vo.flashvars;
			_mediaProxy = (facade.retrieveProxy( MediaProxy.NAME ) as MediaProxy);
			var serviceProxy : ServicesProxy = (facade.retrieveProxy( ServicesProxy.NAME ) as ServicesProxy);
			var layoutProxy : LayoutProxy = (facade.retrieveProxy( LayoutProxy.NAME ) as LayoutProxy);
			
			var url : String;
			var singleVideoClipperFlavor : String = '1'; //Video (not a Mix)
			
			switch(_flashvars.sourceType)
			{
				case SourceType.F4M: // If the entry is a manifest url
					url = _mediaProxy.vo.entry.id;
					break;
				case SourceType.URL ://if the entry is URL
					if(_mediaProxy.vo.deliveryType !=  StreamerType.LIVE)
						url = _mediaProxy.vo.entry.id;
					else
						url = _flashvars.streamerUrl + "/" + _mediaProxy.vo.entry.id;
					break;
				case SourceType.ENTRY_ID ://if the entry is an entryId
					url = _mediaProxy.vo.entry.dataUrl;
					var cdnHost : String = _flashvars.cdnHost ? _flashvars.cdnHost : _flashvars.host;
					var flavorIndex:int;
					var preferedFlavorBR:int = _mediaProxy.vo.preferedFlavorBR;
					var selectedFlavorId:String = _mediaProxy.vo.selectedFlavorId;
					var foundFlavorBR:int = 0;
					var foundFlavorId : String = (selectedFlavorId && selectedFlavorId != "" && selectedFlavorId!= "-1") ? selectedFlavorId : null;
					
					if(_mediaProxy.vo && _mediaProxy.vo.kalturaMediaFlavorArray)
					{
						var dif : Number = preferedFlavorBR;

						for(var i:int=0;i<_mediaProxy.vo.kalturaMediaFlavorArray.length;i++)//this checks the flavorId at the kalturaMediaFlavorArray
						{
							// if a selected flavor was set (e.g. kmc preview via flashvars) search for it
							if (selectedFlavorId)
							{
								if (selectedFlavorId == _mediaProxy.vo.kalturaMediaFlavorArray[i].id)
								{
									foundFlavorBR = _mediaProxy.vo.kalturaMediaFlavorArray[i].bitrate;
									break;
								}
							}
								// if a prefered bitrate is specified search for the most closest bitrate (lower or equal)
							else if (preferedFlavorBR != 0) 
							{
								var b:Number = _mediaProxy.vo.kalturaMediaFlavorArray[i].bitrate;
								
								b = Math.round(b/100) * 100;
								if (Math.abs(b - preferedFlavorBR) <= dif )
								{
									dif = Math.abs(b - preferedFlavorBR);
									if (b <= 1.2*preferedFlavorBR )
									{
										
										foundFlavorBR = b;
										foundFlavorId = _mediaProxy.vo.kalturaMediaFlavorArray[i].id;
										flavorIndex = i;
										//										_mediaProxy.vo.switchDue = true;
									}
									
								}
							}
							
						}
						
						
						_mediaProxy.vo.selectedFlavorId = foundFlavorId;//_mediaProxy.vo.kalturaMediaFlavorArray[flavorIndex].id;
						//if a stream was found set it as the new prefered height	
						if (foundFlavorBR)
							_mediaProxy.vo.preferedFlavorBR = int(foundFlavorBR);
						if (preferedFlavorBR <= 0)
						{
							_mediaProxy.vo.selectedFlavorId = null;
						}
						if (_mediaProxy.vo.entry is KalturaLiveStreamEntry)
						{
							_mediaProxy.vo.selectedFlavorId = null;
							_mediaProxy.vo.preferedFlavorBR = 0;
						}
						
					}
					
					break;		
			}
			
			
			if(_mediaProxy.vo.entry && _mediaProxy.vo.entry.id != "-1")
			{
				//_mediaProxy.vo.entry.dataUrl = "http://cdnkaldev.kaltura.com/p/1/sp/100/flvclipper/entry_id/00_r4ei4ohges/version/100000"//url;
				_mediaProxy.vo.entry.dataUrl = url;
				
				//In case the entry to view is a KalturaMixEntry, the KalturaMixPlugin must be loaded. The plugin is heavy and should not be loaded 
				//unless needed for an entry. This is the reason that its loading policy is set to "on demand".
				if (_mediaProxy.vo.entry is KalturaMixEntry)
				{
					var plugin:Plugin = Plugin(facade['bindObject']['Plugin_kalturaMix']);
					
					//if we didn't find the Mix plugin we alert the user
					if(!plugin)
					{
						sendNotification(NotificationType.ALERT , {message: MessageStrings.getString('NO_MIX_PLUGIN'), title: MessageStrings.getString('NO_MIX_PLUGIN_TITLE')} );
						return;//return without continue to load media (the user will have to use change media now)
					}	
					else if(plugin && !plugin.content)
					{
						//load the media only after the Mix plugin is ready
						plugin.load();
						plugin.addEventListener( Event.COMPLETE , onPluginReady, false );
						return;
					}
				}
			}
			dispatchMediaReady ();
			commandComplete(); 
		}
		
		private function onPluginReady(e:Event):void
		{
			dispatchMediaReady();
			commandComplete(); 
		}
		/**
		 * This function resolves the subsequent mode of the player. If the entry object was empty or restricted, the player
		 * is considered in status EMPTY and the controls are disabled. If the entry is playable and was successfully loaded, the KDP is in status 
		 * READY.
		 */		
		private function dispatchMediaReady () : void
		{
			if (!_mediaProxy.vo.isMediaDisabled)
			{
				_mediaProxy.shouldWaitForElement = true;
				(facade.retrieveProxy( PlayerStatusProxy.NAME ) as PlayerStatusProxy).dispatchKDPReady();
				sendNotification( NotificationType.MEDIA_READY);
				sendNotification(NotificationType.READY_TO_PLAY);
				sendNotification(NotificationType.ENABLE_GUI, {guiEnabled : true , enableType : EnableType.CONTROLS});
				
				_mediaProxy.configurePlayback();
				
			}
			else
			{
				sendNotification(NotificationType.ENABLE_GUI,{guiEnabled : false , enableType : EnableType.CONTROLS});
				(facade.retrieveProxy( PlayerStatusProxy.NAME ) as PlayerStatusProxy).dispatchKDPEmpty();
				sendNotification(NotificationType.READY_TO_LOAD);
			}
		}
		
	}
}