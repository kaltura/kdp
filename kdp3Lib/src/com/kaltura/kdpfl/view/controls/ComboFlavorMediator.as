package com.kaltura.kdpfl.view.controls
{
	import com.kaltura.kdpfl.model.MediaProxy;
	import com.kaltura.kdpfl.model.type.NotificationType;
	import com.kaltura.kdpfl.model.type.StreamerType;
	import com.kaltura.puremvc.as3.patterns.mediator.MultiMediator;
	
	import flash.events.Event;
	import flash.net.SharedObject;

	public class ComboFlavorMediator extends MultiMediator
	{
		//public static const AUTO_MESSAGE : String = "Automatically switches between bitrates";
		//public static const HD_ON_MESSAGE : String = "HD on";
		//public static const HD_OFF_MESSAGE : String = "HD off";
		
		
		/**
		 * 
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
		
		
		private function onComboBoxOpen (e : Event) : void{
			comboBox.kisOpen = true;
		}
		
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
			if (comboBox.streamerType == StreamerType.HTTP)
			{
				flavorCookie = SharedObject.getLocal("Kaltura");
				flavorCookie.data.preferedFlavorBR = preferedFlavorBitrate;
				flavorCookie.flush();
			}
			//call do switch
			sendNotification( NotificationType.DO_SWITCH , preferedFlavorBitrate );
		}
		
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