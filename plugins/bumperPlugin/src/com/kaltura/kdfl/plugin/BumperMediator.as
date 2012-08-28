package com.kaltura.kdfl.plugin {

	import com.kaltura.kdfl.plugin.events.BumperEvent;
	import com.kaltura.kdpfl.model.MediaProxy;
	import com.kaltura.kdpfl.model.SequenceProxy;
	import com.kaltura.kdpfl.model.type.AdsNotificationTypes;
	import com.kaltura.kdpfl.model.type.NotificationType;
	import com.kaltura.kdpfl.model.type.SequenceContextType;
	import com.kaltura.puremvc.as3.patterns.mediator.SequenceMultiMediator;
	
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import org.osmf.media.MediaPlayerState;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.observer.Notification;

	/**
	 * PureMVC mediator for the bumper plugin 
	 */	
	public class BumperMediator extends SequenceMultiMediator {


		public var shouldSkip : Boolean = false;
		private var _playedOnce : Boolean = false;
		private var _returnOnce : Boolean = false;
		public var wrapPlaylist : Boolean;
		private var postBumper:BumperPluginCode;
		private var postBumperIndex:uint;
		private var _sequenceProxy:SequenceProxy;
		private var _mediaProxy:MediaProxy;
		
		/**
		 * Constructor
		 * @param viewComponent	the view component for this mediator
		 */
		public function BumperMediator(viewComponent:Object = null) {
			super(viewComponent);
			bumper.addEventListener(Bumper.NAVIGATE, navigate, false, 0, true);
			_sequenceProxy = facade.retrieveProxy(SequenceProxy.NAME) as SequenceProxy;
			_mediaProxy = facade.retrieveProxy(MediaProxy.NAME) as MediaProxy;
		}
		

		/**
		 * Mediator's registration function. 
		 * Sets the default image duration.
		 */
		override public function onRegister():void {
			_mediaProxy.vo.supportImageDuration = true;
			super.onRegister();
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
										NotificationType.SEQUENCE_ITEM_PLAY_END,
										NotificationType.MEDIA_LOADED,
										NotificationType.MEDIA_READY,
										"playlistFirstEntry",
										"playlistMiddleEntry",
										"playlistLastEntry",
										NotificationType.CHANGE_MEDIA_PROCESS_STARTED,
										NotificationType.DO_PLAY);
			return notify;
		}


		/**
		 * Pure MVC way to handle KDP 3 events
		 * @param note		a notification from the facade.
		 */
		override public function handleNotification(note:INotification):void {
			var config:Object = facade.retrieveProxy("configProxy");
			
			var data:Object = note.getBody();
			switch (note.getName()) {			
				case "playlistFirstEntry":
					if(wrapPlaylist)
						removePostrollFromPostSequence();
					break;
				case "playlistMiddleEntry":
					if(wrapPlaylist)
						removePostrollFromPostSequence();
					break;
				case "playlistLastEntry":
					if(wrapPlaylist)
						returnPostrollToPostSequence();
					break;
				
				
				
				case NotificationType.MEDIA_READY:
					if (_mediaProxy.vo.entry.id == bumper.bumperEntryID && _sequenceProxy.vo.isInSequence) {
						sendNotification(NotificationType.DO_PLAY);
					}
					break;
				case NotificationType.MEDIA_LOADED:
					if (_mediaProxy.vo.entry.id == bumper.bumperEntryID && _sequenceProxy.vo.isInSequence && !_playedOnce) {
						_playedOnce = true;
						_sequenceProxy.vo.isAdLoaded = true;
						var playerMediator : Object = facade.retrieveMediator("kMediaPlayerMediator");
						playerMediator.playContent();
					}
					break;
				
				case NotificationType.CHANGE_MEDIA_PROCESS_STARTED:
					_playedOnce = false;
					break;
				
				case NotificationType.SEQUENCE_ITEM_PLAY_END:
					bumperPlayEnd(note);
					if(wrapPlaylist)
						removePrerollFromPreSequence();
					break;
				
				case NotificationType.PLAYER_PLAYED:
					if (bumper.enabled) {
						
						if (_sequenceProxy.sequenceContext == SequenceContextType.PRE) {
							sendNotification(AdsNotificationTypes.BUMPER_STARTED, {timeSlot:"preroll"});
						}
						else if (_sequenceProxy.sequenceContext == SequenceContextType.POST) {
							sendNotification(AdsNotificationTypes.BUMPER_STARTED, {timeSlot:"postroll"});
						}
					}
					break;

				case NotificationType.DO_PLAY:
					if (_mediaProxy.vo.entry.id == bumper.bumperEntryID && _sequenceProxy.vo.isInSequence && !_playedOnce) {
						bumper.enabled = true;
						enableGUI(false);
						bumper.trackClicks = true;	
					}
					break;


			}
		}

		
		public function removePrerollFromPreSequence():void
		{
			//take the bumper plugin out of the pre
			var arr:Array;
			if(_sequenceProxy.vo.preSequenceArr) 
				arr = _sequenceProxy.vo.preSequenceArr;
			for (var i:uint ; i<arr.length;i++ )
			{
				if(arr[i] is BumperPluginCode )
				{
					// found it - get it out 
					_sequenceProxy.vo.preSequenceArr.splice(i, 1);
				}
			}
		}
		public function removePostrollFromPostSequence():void
		{
			//take the bumper plugin out of the post array 
			var arr:Array;
			if(_sequenceProxy.vo.postSequenceArr) 
				arr = _sequenceProxy.vo.postSequenceArr;
			for (var i:uint ; i<arr.length;i++ )
			{
				if(arr[i] is BumperPluginCode )
				{
					// found it - get it out and remember it's location. 
					postBumperIndex = i;
					postBumper = arr[i];
					//TODO check with more than 1 item
					_sequenceProxy.vo.postSequenceArr.splice(i, 1);
				}
			}
		}
		
		public function returnPostrollToPostSequence():void
		{
			if(_returnOnce)
				return;
			_returnOnce = true;
			//if we got to this point - we need to get the bumper back to the post sequence. 
			//if the array is empty we can just push it back, if it is full we need to push it back to the correct index
			if(_sequenceProxy.vo.postSequenceArr.length == 0)
			{
				_sequenceProxy.vo.postSequenceArr.push(postBumper);
				return;
			}
			_sequenceProxy.vo.postSequenceArr.splice(postBumperIndex,0,postBumper);
			
		}
		
		public function playContent () : void
		{
			if (shouldSkip)
			{
				var sequenceContext : String = (_sequenceProxy["vo"]["preCurrentIndex"] != -1) ? "pre" : "post";
				var currentIndex:Number = (_sequenceProxy["vo"]["preCurrentIndex"] != -1) ? preSequence : postSequence;
				sendNotification("sequenceItemPlayEnd", {sequenceContext: sequenceContext,currentIndex: currentIndex} );
			}
			else
			{
				bumper.enabled = true;
				enableGUI(false);
				bumper.trackClicks = true;
				_mediaProxy.loadWithMediaReady();
				
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
				if (_mediaProxy.vo.entry.id == bumper.bumperEntryID)
				{
					sendNotification(NotificationType.DO_SEEK, 0);
				}
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