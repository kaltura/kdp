package com.kaltura.kdpfl.controller
{
	import com.kaltura.kdpfl.model.MediaProxy;
	import com.kaltura.kdpfl.model.SequenceProxy;
	import com.kaltura.kdpfl.model.type.NotificationType;
	import com.kaltura.kdpfl.model.type.SequenceContextType;
	import com.kaltura.kdpfl.model.type.StreamerType;
	import com.kaltura.vo.KalturaLiveStreamEntry;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	/**
	 * This command is called when the media currently playing in the mediaPlayer has finished playback.
	 */	
	public class PlaybackCompleteCommand extends SimpleCommand
	{
		public var _sequenceProxy : SequenceProxy;
		public var _mediaProxy : MediaProxy;
		public function PlaybackCompleteCommand()
		{
			super();
		}
		
		/**
		 * Resolve progress : if the completed media item was a sequence plugin, move on to the next item in 
		 * this sequence; If the complete item was the main entry start the post sequence or fire "PLAYER_PLAY_END".
		 * @param notification
		 */		
		override public function execute(notification:INotification):void
		{
			_sequenceProxy = facade.retrieveProxy( SequenceProxy.NAME ) as SequenceProxy;	
			_mediaProxy = facade.retrieveProxy( MediaProxy.NAME ) as MediaProxy;	
			if (_sequenceProxy.vo.isInSequence )
			{
				_sequenceProxy.vo.isAdLoaded = false;
				if(_sequenceProxy.hasSubSequence())
				{
					_sequenceProxy.activePlugin().start();
				}
				else
				{
					var sequenceContext : String = _sequenceProxy.sequenceContext;
					var currentIndex : int = (_sequenceProxy.vo.preCurrentIndex != -1) ? _sequenceProxy.vo.preCurrentIndex : _sequenceProxy.vo.postCurrentIndex;
					sendNotification(NotificationType.SEQUENCE_ITEM_PLAY_END, {sequenceContext : sequenceContext, currentIndex : currentIndex});
				}
			}
			else
			{
				if( !_sequenceProxy.vo.postSequenceComplete && _sequenceProxy.vo.postSequenceArr.length)
					_sequenceProxy.initPostIndex();
				if ( _sequenceProxy.hasSequenceToPlay() )
				{
					_sequenceProxy.vo.isInSequence = true;
					_sequenceProxy.playNextInSequence();
				}
				else
				{
					// This is-statement is here in case the entry being played is a Live Stream. In this case,
					// rather than finishing playback, the player should start looking for the source of the stream in case of reconnect.
					if (_mediaProxy.vo.entry is KalturaLiveStreamEntry || _mediaProxy.vo.deliveryType == StreamerType.LIVE)
					{
						_mediaProxy.vo.singleAutoPlay = true;
						sendNotification(NotificationType.CHANGE_MEDIA, {entryId: _mediaProxy.vo.entry.id } );
					}
					else
					{
						sendNotification(NotificationType.PLAYER_PLAY_END);
					}
				}
			}
		}
	
	}
}