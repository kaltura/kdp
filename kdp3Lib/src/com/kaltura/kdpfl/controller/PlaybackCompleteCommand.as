package com.kaltura.kdpfl.controller
{
	import com.kaltura.kdpfl.model.SequenceProxy;
	import com.kaltura.kdpfl.model.type.NotificationType;
	import com.kaltura.kdpfl.model.type.SequenceContextType;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	/**
	 * This command is called when the media currently playing in the mediaPlayer has finished playback.
	 */	
	public class PlaybackCompleteCommand extends SimpleCommand
	{
		public var _sequenceProxy : SequenceProxy;
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
			
			if (_sequenceProxy.vo.isInSequence )
			{
				_sequenceProxy.vo.isAdLoaded = false;
				if(_sequenceProxy.hasSubSequence())
				{
					_sequenceProxy.activePlugin().start();
				}
				else
				{
					var sequenceContext : String = (_sequenceProxy.vo.preCurrentIndex != -1) ? SequenceContextType.PRE : SequenceContextType.POST;
					var currentIndex : int = (_sequenceProxy.vo.preCurrentIndex != -1) ? _sequenceProxy.vo.preCurrentIndex : _sequenceProxy.vo.postCurrentIndex;
					sendNotification(NotificationType.SEQUENCE_ITEM_PLAY_END, {sequenceContext : sequenceContext, currentIndex : currentIndex});
				}
			}
			else
			{
				if( !_sequenceProxy.vo.postSequenceComplete)
					_sequenceProxy.initPostIndex();
				if ( _sequenceProxy.hasSequenceToPlay() )
				{
					_sequenceProxy.vo.isInSequence = true;
					_sequenceProxy.playNextInSequence();
				}
				else
				{
					
					sendNotification(NotificationType.PLAYER_PLAY_END);
				}
			}
		}
	
	}
}