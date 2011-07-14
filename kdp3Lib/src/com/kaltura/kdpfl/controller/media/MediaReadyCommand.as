package com.kaltura.kdpfl.controller.media
{
	import com.kaltura.kdpfl.model.ConfigProxy;
	import com.kaltura.kdpfl.model.MediaProxy;
	import com.kaltura.kdpfl.model.SequenceProxy;
	import com.kaltura.kdpfl.model.type.EnableType;
	import com.kaltura.kdpfl.model.type.NotificationType;
	import com.kaltura.kdpfl.model.vo.SequenceVO;
	import com.kaltura.kdpfl.view.media.KMediaPlayerMediator;
	import com.kaltura.types.KalturaMediaType;
	import com.kaltura.vo.KalturaMediaEntry;
	
	import org.osmf.media.MediaPlayer;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	/**
	 * MediaReadyCommand is responsible for starting play or halting after media has loaded 
	 */
	public class MediaReadyCommand extends SimpleCommand
	{
		private var _player : MediaPlayer;
		private var _mediaProxy : MediaProxy;
		private var _flashvars : Object;
		private var _sequence : SequenceVO;
		
		/**
		 * Constructor 
		 * 
		 */		
		public function MediaReadyCommand()
		{
			_player = (facade.retrieveMediator(KMediaPlayerMediator.NAME) as KMediaPlayerMediator).player;
			_mediaProxy = facade.retrieveProxy(MediaProxy.NAME) as MediaProxy;
			_flashvars = (facade.retrieveProxy(ConfigProxy.NAME) as ConfigProxy).vo.flashvars;
			_sequence = (facade.retrieveProxy(SequenceProxy.NAME) as SequenceProxy).vo;
		}
		/**
		 * The command handles the MEDIA_READY notification, according to the type of entry (live or recorded),
		 * the value of the autoPlay flashvar (whether the entry should play immediately on being loaded or after the user presses play. 
		 * In the case of a live entry, the player cannot begin to play imemdiately but goes through a process which determines whether the live stream is
		 * currently on-air or offline.
		 * @param notification
		 * 
		 */				
		override public function execute(notification:INotification):void
		{
			var playerMediator : KMediaPlayerMediator = facade.retrieveMediator(KMediaPlayerMediator.NAME) as KMediaPlayerMediator;
			
			//live streaming entry.
			//In each of these cases the media within the player needs to start playing immediately.
			if (!playerMediator.isIntelliSeeking)
			{
				if (!_sequence.isInSequence)
					sendNotification( NotificationType.DO_PLAY );
			}
				
			else
			{
				if(_mediaProxy.vo.singleAutoPlay)
				{
					_mediaProxy.vo.singleAutoPlay = false;
					sendNotification( NotificationType.DO_PLAY );
				}
				else
				{
					sendNotification( NotificationType.DO_PLAY );
				}
				
			}		
			//In case of an image entry, there is no need to enable GUI
			if( _mediaProxy.vo.entry is KalturaMediaEntry && 
				(_mediaProxy.vo.entry as KalturaMediaEntry).mediaType == KalturaMediaType.IMAGE )
			{
				sendNotification(NotificationType.ENABLE_GUI, {guiEnabled : false , enableType : EnableType.CONTROLS});
			}
		}
		
	}
}