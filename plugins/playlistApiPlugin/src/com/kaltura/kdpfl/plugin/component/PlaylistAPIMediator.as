/**
 * PlaylistAPIMediator
 *
 * @langversion 3.0
 * @playerversion Flash 9.0.28.0
 * @author Dan Bacon / www.baconoppenheim.com
 */
package com.kaltura.kdpfl.plugin.component {

	import com.kaltura.kdpfl.model.SequenceProxy;
	import com.kaltura.kdpfl.model.type.NotificationType;
	import com.kaltura.kdpfl.plugin.type.PlaylistNotificationType;
	
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
				case NotificationType.PLAYER_PLAY_END:
					if (playlistAPI.autoContinue) {
						playlistAPI.playNext();
					}
					break;
				case PlaylistNotificationType.PLAYLIST_PLAY_PREVIOUS:	// prev button in uiconf
					playlistAPI.playPrevious();
					break;
				case PlaylistNotificationType.PLAYLIST_PLAY_NEXT:		// next button in uiconf
					playlistAPI.playNext();
					break;
				case NotificationType.KDP_EMPTY:
				case NotificationType.KDP_READY:
					playlistAPI.loadFirstPlaylist();
					break;
				case PlaylistNotificationType.LOAD_PLAYLIST:
					var name:String = note.getBody().kplName;
					var url:String = note.getBody().kplUrl;
					var id:String = note.getBody().kplId;
					if ((name && url) || id)
					{
						playlistAPI.resetNewPlaylist();
						playlistAPI.clearFilters();
						if (id)
							playlistAPI.loadV3Playlist(id);
						else
							playlistAPI.loadPlaylist(name, url);
					}
					else
					{
						trace ("could not load playlist, kplName ,kplUrl or kplId values are invalid");
					}
					break;
				case NotificationType.CHANGE_MEDIA: {
					if (!(facade.retrieveProxy(SequenceProxy.NAME) as SequenceProxy).vo.isInSequence)
						playlistAPI.changeMedia(note.getBody().entryId);
					break;
				}
			}
		}


		/**
		 * @inheritDoc
		 */
		override public function listNotificationInterests():Array {
			return [
					NotificationType.PLAYER_PLAY_END,
					PlaylistNotificationType.PLAYLIST_PLAY_PREVIOUS,
					PlaylistNotificationType.PLAYLIST_PLAY_NEXT,
					NotificationType.KDP_EMPTY,
					NotificationType.KDP_READY,
					PlaylistNotificationType.LOAD_PLAYLIST,
					NotificationType.CHANGE_MEDIA
			];
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