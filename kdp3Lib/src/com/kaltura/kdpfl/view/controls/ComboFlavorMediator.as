package com.kaltura.kdpfl.view.controls
{
	import com.kaltura.kdpfl.model.ConfigProxy;
	import com.kaltura.kdpfl.model.MediaProxy;
	import com.kaltura.kdpfl.model.type.NotificationType;
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
		 * indicates if currently there's a switch in progress 
		 */		
		private var _isSwitching:Boolean = false;
		/**
		 * previous tooltip message 
		 */		
		private var _prevMessage:String = "";
		
		/**
		 * kdp flashvars 
		 */		
		private var _flashvars:Object;
		
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
		
		override public function onRegister():void
		{
			_flashvars = (facade.retrieveProxy(ConfigProxy.NAME) as ConfigProxy).vo.flashvars;	
			super.onRegister();
		}
		
		
		override public function listNotificationInterests():Array
		{
			var re_arr : Array = [NotificationType.SWITCHING_CHANGE_STARTED,
								  NotificationType.SWITCHING_CHANGE_COMPLETE,
								  NotificationType.MEDIA_READY,
								  NotificationType.LAYOUT_READY,
								  NotificationType.DO_PAUSE,
								  NotificationType.DO_PLAY];
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
					else if (note_body.newIndex == -2)
					{
						comboBox.selectedMessage = comboBox.bitrateDetectionMessage;
					}
					else
					{
						comboBox.selectedMessage = comboBox.switchingMessage;
					}
					comboBox.close();
					_isSwitching = true;
					break;
				case NotificationType.SWITCHING_CHANGE_COMPLETE:
					comboBox.enabled = true;
					var roundedBitrate:int =  Math.round(Number(note_body.newBitrate)/100) * 100;
					var matchedItem:Object = comboBox.getItemByBitrate(roundedBitrate);
					if (matchedItem)
					{
						comboBox.selectedMessage = matchedItem.label;
						saveFlavorCookie(matchedItem.bitrate, matchedItem.value);
					}
					_isSwitching = false;
					break;
				case NotificationType.MEDIA_READY:
					comboBox.determineEnabled(_isSwitching);
					break;
				case NotificationType.PLAYER_PLAY_END:
					comboBox.enabled = true;
					comboBox.selectedMessage = comboBox.selectedItem.label;
					break;
				case NotificationType.DO_PAUSE:
					if (_isSwitching)
					{
						_prevMessage = comboBox.selectedMessage;
						comboBox.selectedMessage = comboBox.switchPausedMessage;			
					}
					break;
				case NotificationType.DO_PLAY:
					//set the previous message
					if (_isSwitching && _prevMessage!="")
					{
						comboBox.selectedMessage =_prevMessage;
						_prevMessage = "";		
					}
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

			//call do switch
			sendNotification( NotificationType.DO_SWITCH , preferedFlavorBitrate );
		}
		
		
		private function saveFlavorCookie( preferedFlavorBitrate:int, preferedFlavorHeight:int = 0): void
		{
			if (_flashvars.allowCookies!="true")
				return;
			
			var flavorCookie : SharedObject;
			try
			{
				flavorCookie = SharedObject.getLocal("Kaltura");
			}
			catch (e : Error)
			{
				KTrace.getInstance().log("No access to user's file system");
			}
			if (flavorCookie && flavorCookie.data)
			{
				if (comboBox.usePixels)
					flavorCookie.data.preferedFlavorHeight = preferedFlavorHeight;
				else
					flavorCookie.data.preferedFlavorBR = preferedFlavorBitrate;
				
				flavorCookie.data.timeStamp = (new Date()).time;
				flavorCookie.flush();
			}
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