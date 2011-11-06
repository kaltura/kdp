/**
 * PlaylistAPIMediator
 *
 * @langversion 3.0
 * @playerversion Flash 9.0.28.0
 * @author Dan Bacon / www.baconoppenheim.com
 */
package com.kaltura.kdpfl.plugin.component {

	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;

	
	/**
	 * Mediator for Playlist API Plugin
	 */
	public class PlaylistAPIMediator extends Mediator {
		/**
		 * mediator name
		 */
		public static const NAME:String = "PlaylistAPIMediator";

		

		/**
		 * Constructor
		 * @param viewComponent	view component
		 */
		public function PlaylistAPIMediator(viewComponent:Object = null) {
			super(NAME, viewComponent);
		}

		
		/**
		 * sets the mediaProxy's singleAutoPlay
		 * @param value
		 */		
		public function setMediaProxySingleAutoPlay(value:Boolean):void {
			(facade.retrieveProxy("mediaProxy"))["vo"]["singleAutoPlay"] = value;
		}
		
	

		/**
		 * Mediator's registration function. 
		 * Sets KDP autoPlay value and the default image duration.
		 */
		override public function onRegister():void {
			var mediaProxy:Object = facade.retrieveProxy("mediaProxy");
			mediaProxy.vo.supportImageDuration = true;
			if (playlistAPI.autoPlay == true) {
				var flashvars:Object = facade.retrieveProxy("configProxy")["vo"]["flashvars"];
				flashvars.autoPlay = "true";
			}
		}



		/**
		 * @inheritDoc
		 */
		override public function handleNotification(note:INotification):void {
			switch (note.getName()) {
				case "playerPlayEnd":
					if (playlistAPI.autoContinue) {
						playlistAPI.playNext();
					}
					break;
				case "playlistPlayPrevious":	// prev button in uiconf
					playlistAPI.playPrevious();
					break;
				case "playlistPlayNext":		// next button in uiconf
					playlistAPI.playNext();
					break;
				case "kdpEmpty":
				case "kdpReady":
					playlistAPI.loadFirstPlaylist();
					break;
			}
		}


		/**
		 * @inheritDoc
		 */
		override public function listNotificationInterests():Array {
			return ["playerPlayEnd", "playlistPlayPrevious", "playlistPlayNext", "kdpEmpty", "kdpReady"];
		}


		/**
		 * Return mediator name
		 */
		public function toString():String {
			return (NAME);
		}

		
		/**
		 * currently used ks 
		 */		
		public function get ks():String {
			var kc:Object = facade.retrieveProxy("servicesProxy")["kalturaClient"];
			return kc.ks;
		}

		
		/**
		 * Playlist's view component
		 */
		private function get playlistAPI():playlistAPIPluginCode {
			return (viewComponent as playlistAPIPluginCode);
		}

	}
}