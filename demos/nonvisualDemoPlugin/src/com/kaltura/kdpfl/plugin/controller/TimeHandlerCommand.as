package com.kaltura.kdpfl.plugin.controller {
	import com.kaltura.kdpfl.model.MediaProxy;
	import com.kaltura.kdpfl.model.type.NotificationType;
	import com.kaltura.kdpfl.plugin.model.SoundProxy;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	public class TimeHandlerCommand extends SimpleCommand implements ICommand {

		public function TimeHandlerCommand() {
			
		}


		override public function execute(notification:INotification):void {
			switch (notification.getName()) {
				case NotificationType.MEDIA_READY:
					var mediaPlayer:Object = facade.retrieveMediator("kMediaPlayerMediator");
					// we don't need the exact number, round it to make calculations simpler.
					(facade.retrieveProxy(SoundProxy.NAME) as SoundProxy).entryDuration = Math.floor(mediaPlayer["player"].duration);
					break;
				case NotificationType.PLAYER_UPDATE_PLAYHEAD:
					handlePlayhead(notification.getBody() as Number);
					break;
			}
		}
		
		
		/**
		 * only play a sound every tenth of the movie
		 * @param data	current playhead position
		 */
		private function handlePlayhead(data:Number):void {
			var duration:Number = (facade.retrieveProxy(SoundProxy.NAME) as SoundProxy).entryDuration;
			var position:int = Math.floor(data);
			// we receive PLAYER_UPDATE_PLAYHEAD several times every second so we'll get the sound a few times.
			var currentPercent:int = Math.floor(position / duration * 100);
			if (currentPercent % 10 == 0) {
				// play a random sound:
				sendNotification(SoundProxy.PLAY_RANDOM_SOUND);
			}
		}
	}
}