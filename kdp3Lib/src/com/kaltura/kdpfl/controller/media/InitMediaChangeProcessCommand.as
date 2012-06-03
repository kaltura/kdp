package com.kaltura.kdpfl.controller.media
{
	import com.kaltura.kdpfl.model.ConfigProxy;
	import com.kaltura.kdpfl.model.MediaProxy;
	import com.kaltura.kdpfl.model.SequenceProxy;
	import com.kaltura.kdpfl.model.type.EnableType;
	import com.kaltura.kdpfl.model.type.NotificationType;
	import com.kaltura.kdpfl.model.type.SequenceContextType;
	import com.kaltura.kdpfl.model.type.StreamerType;
	import com.kaltura.kdpfl.view.media.KMediaPlayerMediator;
	import com.kaltura.osmf.proxy.KSwitchingProxyElement;
	import com.kaltura.types.KalturaStatsFeatureType;
	import com.kaltura.vo.KalturaBaseEntry;
	
	import flash.net.SharedObject;
	
	import org.osmf.media.MediaPlayer;
	import org.osmf.media.MediaPlayerState;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import org.puremvc.as3.patterns.observer.Notification;
	
	/**
	 * This class is responsible for initiating media change process 
	 */	
	public class InitMediaChangeProcessCommand extends SimpleCommand
	{
		/**
		 * Set the model with new entry to load 
		 * @param notification - notification which triggered the command.
		 * 
		 */		
		override public function execute(notification:INotification):void
		{
			
			var note : Object = (notification as Notification).getBody();
			var player:MediaPlayer = (facade.retrieveMediator(KMediaPlayerMediator.NAME) as KMediaPlayerMediator).player;
			if (player && player.state == MediaPlayerState.PLAYING)
				sendNotification(NotificationType.DO_PAUSE);
			//if the controls where disabled relese the lock
			sendNotification(NotificationType.ENABLE_GUI,{guiEnabled : true , enableType : EnableType.CONTROLS});
			//then lock them again until the media is loaded
			sendNotification(NotificationType.ENABLE_GUI,{guiEnabled : false , enableType : EnableType.CONTROLS});  
			
			sendNotification(NotificationType.REMOVE_ALERTS);
			var flashvars : Object = (facade.retrieveProxy(ConfigProxy.NAME) as ConfigProxy).vo.flashvars;
			if (note.originFeature)
				flashvars.originFeature = note.originFeature;
			else
				flashvars.originFeature = KalturaStatsFeatureType.NONE;
			
			sendNotification(NotificationType.CHANGE_MEDIA_PROCESS_STARTED, {entryId: notification.getBody().entryId});
			
			var mediaProxy : MediaProxy = facade.retrieveProxy( MediaProxy.NAME ) as MediaProxy;
			
			//set the offline message to false
			mediaProxy.vo.isOffline = true;
			
			//set the MediaDisabled to false because we load new entry
			if(mediaProxy.vo.isMediaDisabled)
			{	
				sendNotification(NotificationType.ENABLE_GUI,{guiEnabled : true , enableType : EnableType.CONTROLS});
				mediaProxy.vo.isMediaDisabled = false;
			}
			
			if (mediaProxy.vo.entryLoadedBeforeChangeMedia)
			{
				setFlavorFromCookie(note);
				return; 
			}
			
			
			
			//If we did not change media as part of the sequence, we need to reset the pre and post sequence indexes.
			var sequenceProxy : SequenceProxy = facade.retrieveProxy( SequenceProxy.NAME ) as SequenceProxy;
			var newEntryId : String = note.entryId;
			if ( (!sequenceProxy.vo.isInSequence || sequenceProxy.sequenceContext == SequenceContextType.MID) && !mediaProxy.vo.isFlavorSwitching)
			{
				sequenceProxy.populatePrePostArr();
				sequenceProxy.initPreIndex() ;
				sequenceProxy.vo.postCurrentIndex = -1;
				sequenceProxy.vo.postSequenceComplete = false;
				sequenceProxy.vo.preSequenceComplete = false;
				sequenceProxy.vo.mainMediaVO = null;
				sequenceProxy.vo.isInSequence = false;
				if (mediaProxy.vo.media is KSwitchingProxyElement)
					(mediaProxy.vo.media as KSwitchingProxyElement).secondaryMediaElement = null;
			}
			
			// set the new entry to be loaded (the rest of the params will be override when loaded
			mediaProxy.vo.entry = new KalturaBaseEntry();
			mediaProxy.vo.entryExtraData = null;
			mediaProxy.vo.kalturaMediaFlavorArray = null;
			mediaProxy.vo.selectedFlavorId = null;
			mediaProxy.vo.keyframeValuesArray = null;
			if (newEntryId) {
				mediaProxy.vo.entry.id = newEntryId;
			}
			mediaProxy.vo.selectedFlavorId = ( note.flavorId && note.flavorId != "-1" ) ? note.flavorId : null;
			//Not sure I want this..
			//mediaProxy.vo.media = null;
			//if someone called change media without preferedFlavorHeight don't override it
			//only if the notification has preferedFlavorHeight 
			setFlavorFromCookie(note);
		}
		/**
		 * This function selects the preferred bitrate for the requested entry 
		 * @param note
		 * 
		 */		
		private function setFlavorFromCookie (note : Object) : void
		{
			var mediaProxy : MediaProxy = facade.retrieveProxy( MediaProxy.NAME ) as MediaProxy;
			var flashvars : Object = (facade.retrieveProxy(ConfigProxy.NAME) as ConfigProxy).vo.flashvars;
			if(note.preferedFlavorBR) 
			{
				if (note.preferedFlavorBR == -1)
					mediaProxy.vo.autoSwitchFlavors = true;
				else
					mediaProxy.vo.preferedFlavorBR = note.preferedFlavorBR;
			}
			else if (!flashvars.disableBitrateCookie)
			{
				var flavorCookie : SharedObject;
				try
				{
					flavorCookie = SharedObject.getLocal("kaltura");
				}
				catch (e : Error)
				{
					
				}
				if(flavorCookie && flavorCookie.data.preferedFlavorBR){
					/*if (flavorCookie.data.preferedFlavorBR != -1 || mediaProxy.vo.deliveryType != StreamerType.HTTP)
					{
						mediaProxy.vo.preferedFlavorBR = flavorCookie.data.preferedFlavorBR;
					}*/ 
					
					var propertyName:String = mediaProxy.vo.displayFlavorPixels ? "preferedFlavorHeight" : "preferedFlavorBR";
					
					if (flavorCookie.data[propertyName] == -1 && mediaProxy.vo.deliveryType != StreamerType.HTTP)
					{
						mediaProxy.vo.autoSwitchFlavors = true;
					}
					else
					{
						mediaProxy.vo.preferedFlavorBR = flavorCookie.data[propertyName];
					}
				}
			}
		}
	}
}