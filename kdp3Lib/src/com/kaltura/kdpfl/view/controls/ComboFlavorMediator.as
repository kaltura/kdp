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
					comboBox.enabled = false;
					if (note_body.newIndex == -1)
					{
						comboBox.selectedMessage = comboBox.autoMessage;
					}
					else
					{
						comboBox.selectedMessage = comboBox.switchingMessage;
					}
					break;
				case NotificationType.SWITCHING_CHANGE_COMPLETE:
					comboBox.enabled = true;
					var roundedBitrate:int =  Math.round(Number(note_body.newBitrate)/100) * 100;
					var matchedItem:Object = comboBox.getItemByBitrate(roundedBitrate);
					if (matchedItem)
						comboBox.selectedMessage = matchedItem.label;
					break;
				case NotificationType.MEDIA_READY:
					comboBox.determineEnabled();
					break;
				case NotificationType.PLAYER_PLAY_END:
					comboBox.enabled = true;
					comboBox.selectedMessage = comboBox.selectedItem.label;
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
			var preferedFlavorHeight : int;
			var saveToCookie:Boolean = true;
			//if we selected auto on / auto off
			if(comboBox.selectedItem.value == -2)
			{
				//if we switch from auto to off
				if (comboBox.selectedItem.label == comboBox.adaptiveAuto)
				{
					//set the selection on the last playing bitrate
					comboBox.selectedIndex = comboBox.lastSelectedIndex;
					preferedFlavorBitrate = comboBox.dataProvider.getItemAt(comboBox.selectedIndex).bitrate;
					//this flavor was selected automatically, so don't save to cookie
					saveToCookie = false;
					comboBox.selectedMessage = comboBox.selectedItem.label;
					
				}
				else
				{
					//we switch from off to auto
					preferedFlavorBitrate = preferedFlavorHeight = -1;
					comboBox.selectedMessage = comboBox.autoString;
				}
					
			}
			else 
			{
				preferedFlavorBitrate = parseInt(comboBox.selectedItem.bitrate);
				preferedFlavorHeight = parseInt(comboBox.selectedItem.value);
				comboBox.selectedMessage = comboBox.selectedItem.label;
			}

			var flavorCookie : SharedObject;
			try
			{
				flavorCookie = SharedObject.getLocal("Kaltura");
			}
			catch (e : Error)
			{
				KTrace.getInstance().log("No access to user's file system");
			}
			if (saveToCookie && flavorCookie && flavorCookie.data)
			{
				if (comboBox.usePixels)
					flavorCookie.data.preferedFlavorHeight = preferedFlavorHeight;
				else
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