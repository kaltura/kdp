package com.kaltura.osmf.image
{
	import flash.events.Event;
	import flash.events.TimerEvent;
	
	import org.osmf.traits.TimeTrait;

	public class TimedImageTimeTrait extends TimeTrait
	{
		private var _timedImageAdapter : TimedImageAdapter;
		private var _currentTime : Number
		public function TimedImageTimeTrait(timedImageAdapter : TimedImageAdapter)
		{
			super(timedImageAdapter.duration);
			_timedImageAdapter = timedImageAdapter;
			_timedImageAdapter.addEventListener(Event.COMPLETE, onPlaybackComplete, false, 0, true);
			_timedImageAdapter.addEventListener(TimerEvent.TIMER, changeCurrentTime, false, 0,true);
			
			
			durationChangeEnd(0);
		}
		
		private function onPlaybackComplete(event:Event):void
		{
			signalComplete();
		} 
		
		private function changeCurrentTime(evt : TimerEvent) : void
		{
			this._currentTime = _timedImageAdapter.currentTime; 
		}
		
		override public function get currentTime():Number
		{
			return _currentTime;
		}
		
	}
}