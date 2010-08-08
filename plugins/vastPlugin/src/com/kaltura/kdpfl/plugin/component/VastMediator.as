package com.kaltura.kdpfl.plugin.component
{
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.puremvc.as3.patterns.mediator.SequenceMultiMediator;
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.puremvc.as3.interfaces.INotification;

	public class VastMediator extends SequenceMultiMediator
	{
		public static var NAME : String = "vastMediator";
		
		private var _shouldPlayPreroll : Boolean = false;
		private var _shouldPlayPostroll : Boolean = false;
		
		private var _reached25:Boolean = false;
		private var _reached50:Boolean = false;
		private var _reached75:Boolean = false;
		private var _pluginCode : IPlugin;
		
		/**
		 * @copy adContext
		 * */
		private var _adContext:String;
		
		/**
		 * @copy #isListening  
		 */
		private var _isListening : Boolean = false;
		
		/**
		 * Constructor. 
		 * @param viewComponent
		 */		
		public function VastMediator(pluginCode : IPlugin, viewComponent:Object=null)
		{
			super(viewComponent);
			_pluginCode = pluginCode;
		}
		
		
		override public function listNotificationInterests():Array
		{
			var interests : Array = [
									"playerUpdatePlayhead", 
									"sequenceItemPlayEnd",
									"openFullScreen",
									"closeFullScreen",
									"entryReady"
									];
			return interests;
		}
		
		
		/**
		 * only use notification for stats, where the actual timing doesn't matter.<br/>
		 * <code>adStart</code> and <code>adClick</code> are sent from <code>VastLinearAdProxy</code>.
		 * @param notification
		 */		
		override public function handleNotification(notification:INotification):void
		{
			var sequenceProxy : Object = facade.retrieveProxy("sequenceProxy");
			
			switch (notification.getName()) {

				case "playerUpdatePlayhead":
					if (_isListening) {
						// only listen to notification while active.
						handlePlayhead(notification.getBody());
					}
					break;
				case "sequenceItemPlayEnd":
					if (isListening) {
						sendNotification("adEnd", {timeSlot:getTimeSlot()});
						_pluginCode["playedPrerollsSingleEntry"] = 0;
						_pluginCode["playedPostrollsSingleEntry"] = 0;
						enableGUI(true)
					}
					// stop listening to notifications
					isListening = false;
					break;
				case "openFullScreen":
					break;
				case "closeFullScreen":
					break;
				case "entryReady" :
					_pluginCode["initVASTAds"]();
					if (_pluginCode["overlayInterval"])
					{
						var overlayTimer : Timer = new Timer(_pluginCode["overlayInterval"]*1000 ,1);
						overlayTimer.addEventListener(TimerEvent.TIMER_COMPLETE, loadOverlay );
						overlayTimer.start();
					}
					break;
			}	
			
		}
		
		private function loadOverlay ( e: TimerEvent) : void
		{
			_pluginCode["initVASTAds"]();
			(e.target as Timer).start();
		}
		/**
		 * @return	statistics string for current ad context 
		 */		
		private function getTimeSlot():String {
			var res:String;
			switch (adContext) {
				case "pre":
					res = "preroll";
					break;
				case "mid":
					res = "midroll";
					break;
				case "post":
					res = "postroll";
					break;
			}
			return res;
		}
		
		
		/**
		 * dispatch progress event if needed. 
		 * @param o progress notification body
		 */		
		private function handlePlayhead(o:Object):void {
			var duration:Number = (facade.retrieveMediator("kMediaPlayerMediator"))["player"]["duration"];
			var fraction:Number = (o as Number) / duration;
			if (!_reached25 && fraction > 0.25) {
				sendNotification("firstQuartileOfAd", {timeSlot:getTimeSlot()});
				_reached25 = true;
			}
			else if (!_reached50 && fraction > 0.5){
				sendNotification("midOfAd", {timeSlot:getTimeSlot()});
				_reached50 = true;
			}
			else if (!_reached75 && fraction > 0.75){
				sendNotification("ThirdQueartileOfAd", {timeSlot:getTimeSlot()});
				_reached75 = true;	
			}
		}
		
		
		/**
		 * resets the "reached" variables. 
		 * used when we have more than 1 ad.
		 */		
		public function reset():void {
			_reached25 = false;
			_reached50 = false;
			_reached75 = false;
		}
		
		
		public function get shouldPlayPreroll () : Boolean
		{
			return _shouldPlayPreroll;
		}
		
		public function get shouldPlayPostroll () : Boolean
		{
			return _shouldPlayPreroll;
		}
		
		public function enableGUI (enabled : Boolean) : void
		{
			sendNotification("enableGui", {guiEnabled : enabled, enableType : "full"});
		}

		/**
		 * indicates the mediator is listening to notifications. 
		 */
		public function get isListening():Boolean {
			return _isListening;
		}

		/**
		 * @private
		 */
		public function set isListening(value:Boolean):void {
			if (_isListening != value) {
				_isListening = value;
				if (value) {
					reset();
				}
			}
		}

		/**
		 * current ad context. <br/>
		 * possible values enumerated in <code>SequenceContextType</code> 
		 */		
		public function get adContext():String
		{
			return _adContext;
		}

		/**
		 * @private 
		 */		
		public function set adContext(value:String):void
		{
			_adContext = value;
		}
	
	}
}