package com.kaltura.kdpfl.controller
{
	import com.kaltura.kdpfl.model.SequenceProxy;
	import com.kaltura.kdpfl.model.type.NotificationType;
	import com.kaltura.kdpfl.model.type.SequenceContextType;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	/**
	 * Command responsible for skipping a sequence plugin (is the option exists)
	 */	
	public class SequenceSkipNextCommand extends SimpleCommand
	{
		public function SequenceSkipNextCommand()
		{
			super();
		}
		
		/**
		 * If the active plugin has items in its own subsequence, the player shows the next one; Otherwise it moves on to the next plugin
		 * @param notification
		 */		
		override public function execute(notification:INotification):void
		{
			var sequenceProxy : SequenceProxy = facade.retrieveProxy( SequenceProxy.NAME ) as SequenceProxy;
			
			sendNotification (NotificationType.DO_PAUSE);
			
			var sequenceContext : String = sequenceProxy.sequenceContext;
			var currentIndex : int = (sequenceProxy.vo.preCurrentIndex != -1) ? sequenceProxy.vo.preCurrentIndex : sequenceProxy.vo.postCurrentIndex;
			if (!sequenceProxy.activePlugin().hasSubSequence())
			{
				sendNotification (NotificationType.SEQUENCE_ITEM_PLAY_END, {sequenceContext : sequenceContext, currentIndex : currentIndex});
			}
			else
			{
				sequenceProxy.activePlugin().start();
			}
		}
	}
}