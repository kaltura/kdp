package com.kaltura.kdpfl.view.controls
{
	import com.kaltura.kdpfl.model.MediaProxy;
	import com.kaltura.kdpfl.model.type.NotificationType;
	import com.kaltura.kdpfl.view.media.KMediaPlayerMediator;
	import com.kaltura.puremvc.as3.patterns.mediator.MultiMediator;
	
	import flash.events.Event;
	import flash.net.SharedObject;
	
	import org.puremvc.as3.interfaces.INotification;

	/**
	 * Mediator for the KDP flavor selction combo box of type KFlavorComboBox.
	 * @author Hila
	 * 
	 */
	public class ComboFlavorMediator extends MultiMediator
	{
		//public static const AUTO_MESSAGE : String = "Automatically switches between bitrates";
		//public static const HD_ON_MESSAGE : String = "HD on";
		//public static const HD_OFF_MESSAGE : String = "HD off";
		
		
		/**
		 * Constructor.
		 * @param viewComponent
		 * 
		 */		
		public function ComboFlavorMediator(viewComponent:Object=null)
		{
			super(viewComponent);
			comboBox.addEventListener( Event.CHANGE , onFlavorChange );
			comboBox.addEventListener( KFlavorComboBox.DATA_PROVIDER_CHANGE , onDataProviderChange );
			comboBox.addEventListener(Event.OPEN, onComboBoxOpen);
			comboBox.addEventListener(Event.CLOSE, onComboBoxClose);
		}
		
		
		override public function listNotificationInterests():Array
		{
			var re_arr : Array = [NotificationType.SWITCHING_CHANGE_STARTED,
								  NotificationType.SWITCHING_CHANGE_COMPLETE,
								  NotificationType.MEDIA_READY,
								  NotificationType.LAYOUT_READY];
			return re_arr;
		}
		
		override public function handleNotification(notification:INotification):void
		{
			var note_body : Object = notification.getBody();
			switch(notification.getName() )
			{
				case NotificationType.SWITCHING_CHANGE_STARTED:
					(viewComponent as KFlavorComboBox).enabled = false;
					if (note_body.newIndex == -1)
					{
						(viewComponent as KFlavorComboBox).selectedMessage = (viewComponent as KFlavorComboBox).autoMessage;
					}
					else
					{
						(viewComponent as KFlavorComboBox).selectedMessage = (viewComponent as KFlavorComboBox).switchingMessage;
					}
					break;
				case NotificationType.SWITCHING_CHANGE_COMPLETE:
					(viewComponent as KFlavorComboBox).enabled = true;
					(viewComponent as KFlavorComboBox).selectedMessage = "Bitrate: " + Math.round(Number(note_body.newBitrate)/100) * 100;
					break;
				case NotificationType.MEDIA_READY:
					(viewComponent as KFlavorComboBox).determineEnabled();
					break;
				case NotificationType.PLAYER_PLAY_END:
					var currBitrate : Number = (facade.retrieveMediator(KMediaPlayerMediator.NAME) as KMediaPlayerMediator).player.getBitrateForDynamicStreamIndex((facade.retrieveMediator(KMediaPlayerMediator.NAME) as KMediaPlayerMediator).player.currentDynamicStreamIndex);
					(viewComponent as KFlavorComboBox).enabled = true;
					(viewComponent as KFlavorComboBox).selectedMessage = "Bitrate: " + Math.round(currBitrate/100) * 100;
					break;
			}
		}
		
		/**
		 * Handler for event dispatched when user opens the flavor combo box.
		 * @param e
		 * 
		 */		
		private function onComboBoxOpen (e : Event) : void{
			comboBox.kisOpen = true;
		}
		/**
		 * Handler for event dispatched when user closes the combo box.
		 * @param e
		 * 
		 */		
		private function onComboBoxClose ( e:Event) : void{
			comboBox.kisOpen = false;
		}
		/**
		 * when the flavor combobox change an item, we should load the same entry with new flavor
		 * currently we load new media and use change media 
		 * @param event
		 * 
		 */		
		private function onFlavorChange( event : Event ) : void
		{
			var preferedFlavorBitrate : int;
			
			if(comboBox.selectedItem.label == comboBox.autoString)
			{
				comboBox.selectedMessage = comboBox.autoMessage;
				preferedFlavorBitrate = -1;
			}
			else //else cut the heightPostfix
			{
				var labelLength : int = comboBox.selectedItem.label.length-comboBox.bitratePostFix.length;
				preferedFlavorBitrate = parseInt(String(comboBox.selectedItem.label).substr(0,labelLength));
				comboBox.selectedMessage = "Bitrate : " + preferedFlavorBitrate;
			}
			var mediaProxy : MediaProxy = facade.retrieveProxy( MediaProxy.NAME ) as MediaProxy;
			mediaProxy.vo.preferedFlavorBR = preferedFlavorBitrate;
			var flavorCookie : SharedObject;
			try
			{
				flavorCookie = SharedObject.getLocal("Kaltura");
			}
			catch (e : Error)
			{
				trace ("No access to user's file system");
			}
			if (flavorCookie && flavorCookie.data)
			{
				flavorCookie.data.preferedFlavorBR = preferedFlavorBitrate;
				flavorCookie.flush();
			}
			//call do switch
			sendNotification( NotificationType.DO_SWITCH , preferedFlavorBitrate );
		}
		/**
		 * Handler for event thrown when the data provider for the flavor selection combo-box changes. 
		 * @param event
		 * 
		 */		
		private function onDataProviderChange( event : Event ) : void
		{	
			var mediaProxy : MediaProxy = facade.retrieveProxy( MediaProxy.NAME ) as MediaProxy;
			
			//refresh the preferedFlavorBR after set data provider to restore the combo index
			////////////////////////////////////////
			var currentPreferedFlavorBR : int = mediaProxy.vo.preferedFlavorBR;
			mediaProxy.vo.preferedFlavorBR = -1;
			mediaProxy.vo.preferedFlavorBR = currentPreferedFlavorBR;
			////////////////////////////////////////
			
		}
		
		/**
		 * return the combobox component that this mediator holds 
		 * @return 
		 * 
		 */		
		public function get comboBox() : KFlavorComboBox
		{
			return viewComponent as KFlavorComboBox;
		}
	}
}