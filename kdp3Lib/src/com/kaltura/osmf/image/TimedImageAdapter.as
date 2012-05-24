package com.kaltura.osmf.image
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.osmf.events.TimeEvent;
	
	public class TimedImageAdapter extends EventDispatcher
	{
		private var _timer : Timer;
		private var _duration : Number;
		private var _currentTime: Number = 0;
		public function TimedImageAdapter(target:IEventDispatcher=null, duration : Number =5)
		{
			super(target);
			_duration = duration;
			_timer = new Timer(500,duration*2);
			_timer.addEventListener(TimerEvent.TIMER,progressListener);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE,onDurationComplete);
		}
		
		public function progressListener(evt:TimerEvent) : void
		{
			_currentTime += 0.5;
			dispatchEvent(evt);
		}
		
		public function play() : void
		{
			_timer.start();
			/* if(_currentTime == 0){
				var evt:TimeEvent = new TimeEvent(TimeEvent.DURATION_CHANGE, false, false, 5);
				dispatchEvent(evt);
			}  */

		}
		
		public function pause() : void
		{
			_timer.stop();
		}
		
		public function stop() : void
		{
			_currentTime = 0;
			_timer.reset();
		}
		
		
		public function onDurationComplete( event : TimerEvent ) : void
		{
			stop();
			dispatchEvent( new Event(Event.COMPLETE) );
		}
		
		public function get currentTime () : Number
		{
			return _currentTime;
		}
		
		public function get duration () : Number
		{
			return _duration;
		}
		
	}
}