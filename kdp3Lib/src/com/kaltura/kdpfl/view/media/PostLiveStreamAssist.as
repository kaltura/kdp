package com.kaltura.kdpfl.view.media
{
	import com.kaltura.kdpfl.model.MediaProxy;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.osmf.traits.MediaTraitType;
	import org.osmf.traits.TimeTrait;
	import org.puremvc.as3.interfaces.IFacade;
	
	/**
	 * Class PostLiveStreamAssist is designed to test whetherthe LiveStream being played in the KDP is active or disconnected.
	 * @author Hila
	 * 
	 */	
	public class PostLiveStreamAssist extends EventDispatcher
	{
		private var _timer : Timer = new Timer(20000, 1);
		private var _startTime : Number;
		private var _currMedia : MediaProxy ;
		private var _temporal : TimeTrait;
		private static var CONNECTION_END : String = "connectionEnd";
		public function PostLiveStreamAssist(facade : IFacade)
		{
			_currMedia = facade.retrieveProxy(MediaProxy.NAME) as MediaProxy;
			_temporal = _currMedia.vo.media.getTrait(MediaTraitType.TIME) as TimeTrait;
			_startTime = _temporal.currentTime;
			startTimer();
		}
		
		/**
		 * Function startTimer is responsible for setting and starting the timer to count the time-out duration of the stream. 
		 * The default value of the time-out is 20 seconds. 
		 * 
		 */		
		public function startTimer() : void
		{
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
			_timer.start();
		}
		/**
		 * Handler for the TimerComplete event of the time-out timer.  If the Live Stream time has not progressed the stream becomes disconnected.
		 * @param e TimerComplete event
		 * 
		 */		
		public function onTimerComplete ( e : TimerEvent ) : void
		{
			_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
			_timer.stop();
			
			//Checks whether the video has progressed since the timer was started
			if(_startTime != _temporal.currentTime)
			{
				//If the video progressed, restart the timer
				_startTime = _temporal.currentTime;
				startTimer();
			}
			else{
				//If the video has not progressed stop the timer and stop the connection to the stream
				_timer.stop();
				_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete );
				this.dispatchEvent(new Event(CONNECTION_END));	
			}
		}
		
		/**
		 * Function responsible for pausing the time-out timer. Used in case the user has paused the player himself. 
		 * 
		 */		
		public function pauseTimer () : void
		{
			_timer.stop();
			_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete );
		}

	}
}