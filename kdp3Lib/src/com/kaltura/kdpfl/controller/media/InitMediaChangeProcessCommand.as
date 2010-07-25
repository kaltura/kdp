package com.kaltura.kdpfl.controller.media
{
	import com.kaltura.kdpfl.model.MediaProxy;
	import com.kaltura.kdpfl.model.SequenceProxy;
	import com.kaltura.kdpfl.model.type.EnableType;
	import com.kaltura.kdpfl.model.type.NotificationType;
	import com.kaltura.kdpfl.model.type.StreamerType;
	import com.kaltura.vo.KalturaBaseEntry;
	
	import flash.net.NetStreamPlayOptions;
	import flash.net.SharedObject;
	
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
		 * @param notification
		 * 
		 */		
		override public function execute(notification:INotification):void
		{
			//if the controls where disabled relese the lock
 			 sendNotification(NotificationType.ENABLE_GUI,{guiEnabled : true , enableType : EnableType.CONTROLS});
			//then lock them again until the media is loaded
			sendNotification(NotificationType.ENABLE_GUI,{guiEnabled : false , enableType : EnableType.CONTROLS});  
			
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
				return; 
			
			sendNotification( NotificationType.DO_PAUSE );
			
			//If we did not change media as part of the sequence, we need to reset the pre and post sequence indexes.
			var sequenceProxy : SequenceProxy = facade.retrieveProxy( SequenceProxy.NAME ) as SequenceProxy;
			if ( !sequenceProxy.vo.isInSequence )
			{
				sequenceProxy.initPreIndex() ;
				sequenceProxy.vo.postCurrentIndex = -1;
				sequenceProxy.vo.postSequenceComplete = false;
				sequenceProxy.vo.preSequenceComplete = false;
				sequenceProxy.vo.mainMediaVO = null;
			}
			var note : Object = (notification as Notification).getBody();
			var newEntryId : String = note.entryId;
			
			// set the new entry to be loaded (the rest of the params will be override when loaded
			mediaProxy.vo.entry = new KalturaBaseEntry();
			mediaProxy.vo.entryExtraData = null;
			mediaProxy.vo.kalturaMediaFlavorArray = null;
			mediaProxy.vo.selectedFlavorId = null;
			mediaProxy.vo.keyframeValuesArray = null;
			mediaProxy.vo.entry.id = newEntryId;
			mediaProxy.vo.selectedFlavorId = ( note.flavorId && note.flavorId != "-1" ) ? note.flavorId : null;
			
			//if someone called change media without preferedFlavorHeight don't override it
			//only if the notification has preferedFlavorHeight 
			if(note.preferedFlavorBR || note.preferedFlavorBR == -1) 
				{
					mediaProxy.vo.preferedFlavorBR = note.preferedFlavorBR;
				}
			else
			{
				if(mediaProxy.vo.deliveryType == StreamerType.HTTP)
				{
					var flavorCookie : SharedObject = SharedObject.getLocal("kaltura");
					if(flavorCookie.data.preferedFlavorBR){
						mediaProxy.vo.preferedFlavorBR = flavorCookie.data.preferedFlavorBR;
					}
					else
					{
						mediaProxy.vo.preferedFlavorBR = 1000;
					}
				}
			}
		}
	}
}