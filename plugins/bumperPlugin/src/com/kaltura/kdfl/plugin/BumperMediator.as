package com.kaltura.kdfl.plugin {

	import com.kaltura.kdfl.plugin.events.BumperEvent;
	import com.kaltura.kdpfl.model.type.AdsNotificationTypes;
	import com.kaltura.kdpfl.model.type.NotificationType;
	import com.kaltura.kdpfl.model.type.SequenceContextType;
	import com.kaltura.puremvc.as3.patterns.mediator.SequenceMultiMediator;
	
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import org.puremvc.as3.interfaces.INotification;

	/**
	 * PureMVC mediator for the bumper plugin 
	 */	
	public class BumperMediator extends SequenceMultiMediator {


		public var shouldSkip : Boolean = false;
		/**
		 * Constructor
		 * @param viewComponent	the view component for this mediator
		 */
		public function BumperMediator(viewComponent:Object = null) {
			super(viewComponent);
			bumper.addEventListener(Bumper.NAVIGATE, navigate, false, 0, true);
		}


		/**
		 * sets the size of the bumper, based on values in _rootCfg.
		 */
		public function resetSize():void {
			if (bumper != null) {
				bumper.redraw();
			}
		}


		/**
		 * Pure MVC way of listening to KDP3 notifications
		 * @return	a list of notifications we want to receive.
		 */
		override public function listNotificationInterests():Array {
			var notify:Array = new Array(NotificationType.PLAYER_PLAYED, 
										NotificationType.DO_PLAY, 
										NotificationType.SEQUENCE_ITEM_PLAY_END);
			return notify;
		}


		/**
		 * Pure MVC way to handle KDP 3 events
		 * @param note		a notification from the facade.
		 */
		override public function handleNotification(note:INotification):void {
			var config:Object = facade.retrieveProxy("configProxy");
			var media:Object = facade.retrieveProxy("mediaProxy");
			var sequenceProxy:Object = facade.retrieveProxy("sequenceProxy");
			
			var data:Object = note.getBody();
			switch (note.getName()) {
				case NotificationType.DO_PLAY:
					if (media.vo.entry.id == bumper.bumperEntryID) {
						bumper.enabled = true;
						enableGUI(false);
						bumper.trackClicks = true;
					}
					break;
				
				case NotificationType.SEQUENCE_ITEM_PLAY_END:
					bumperPlayEnd(note);
					break;
				
				case NotificationType.PLAYER_PLAYED:
					if (bumper.enabled) {
						
						if (sequenceProxy.sequenceContext == SequenceContextType.PRE) {
							sendNotification(AdsNotificationTypes.BUMPER_STARTED, {timeSlot:"preroll"});
						}
						else if (sequenceProxy.sequenceContext == SequenceContextType.POST) {
							sendNotification(AdsNotificationTypes.BUMPER_STARTED, {timeSlot:"postroll"});
						}
					}
					break;



			}
		}

		
		public function playContent () : void
		{
			if (shouldSkip)
			{
				var sequenceProxy:Object = facade.retrieveProxy("sequenceProxy");
				var sequenceContext : String = (sequenceProxy["vo"]["preCurrentIndex"] != -1) ? "pre" : "post";
				var currentIndex:Number = (sequenceProxy["vo"]["preCurrentIndex"] != -1) ? preSequence : postSequence;
				sendNotification("sequenceItemPlayEnd", {sequenceContext: sequenceContext,currentIndex: currentIndex} );
			}
			else
			{
				var playerMediator : Object = facade.retrieveMediator("kMediaPlayerMediator");
				playerMediator.playContent();
			}
		}
		/**
		 * checks if this is the bumper's showtime 
		 * @param note
		 * @return true if the bumper is "on", false otherwise. 
		 */
		private function shouldReact(note:INotification):Boolean {
			if (note.getBody()) {
				if ((note.getBody().sequenceContext == "pre" && note.getBody().currentIndex == (preSequence - 1)) ||
					(note.getBody().sequenceContext == "post" && note.getBody().currentIndex == (postSequence - 1))) {
					return true;
				}
			}
			return false;
		}


		private function bumperPlayEnd(note:INotification):void {
			if (shouldReact(note)) {
				bumper.trackClicks = false;
				enableGUI(true);
				bumper.enabled = false;
			}
		}


		private function enableGUI(enable:Boolean):void {
			sendNotification("enableGui", {guiEnabled: enable, enableType: "full"});
		/* if we want to disable the GUI we need to send the notification twice,
		 * this is a hack to bypass the KDP enabling the GUI on mediaReady.
		 */
//			if (!enable) {
//				sendNotification("enableGui", {guiEnabled: false, enableType:"full"});
//			}
		}


		/**
		 * tell the player to open a new page with the given url
		 * @param e		BumperEvent with url data
		 */
		private function navigate(be:BumperEvent):void {
			//FIXME see if we can use a central KDP method (funcs proxy is not a proxy and can't be used)
			sendNotification(AdsNotificationTypes.BUMPER_CLICKED);
			var request:URLRequest = new URLRequest(be.url);
			try {
				navigateToURL(request, "_blank");
			} catch (e:Error) {
				trace("failed navigating to " + be.url + "/n" + e.message);
			}
		}


		/**
		 * reference to the bumper view component that this Mediator wraps
		 * @return wrapped bumper
		 */
		public function get bumper():Bumper {
			return this.viewComponent as Bumper;
		}



	}
}