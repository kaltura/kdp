package com.kaltura.kdpfl.controller
{
	import com.kaltura.kdpfl.model.MediaProxy;
	import com.kaltura.kdpfl.model.SequenceProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	/**
	 * Command responsible for the logic that should be activated when a sequence plugin (i.e Bumper, Adaptv, etc)
	 * has completed playback
	 */	
	public class SequenceItemPlayEndCommand extends SimpleCommand
	{
		private var _sequenceProxy : SequenceProxy;
		
		public function SequenceItemPlayEndCommand()
		{
			super();
			_sequenceProxy = facade.retrieveProxy(SequenceProxy.NAME) as SequenceProxy;
		}
		
		/**
		 * Restore original media and resolve the rest of the progree (finish the sequence or move on to the next item in the sequence). 
		 * @param notification
		 */		
		override public function execute(notification:INotification):void
		{
			var mediaProxy : MediaProxy = facade.retrieveProxy(MediaProxy.NAME) as MediaProxy;
			if (_sequenceProxy.vo.mainMediaVO && _sequenceProxy.vo.mainMediaVO != mediaProxy.vo)
			{
				_sequenceProxy.restoreMainMedia();	
				
			}
			var sequenceContext : String = _sequenceProxy.sequenceContext;
			
			_sequenceProxy.resolveProgress();
		
		}
	}
}