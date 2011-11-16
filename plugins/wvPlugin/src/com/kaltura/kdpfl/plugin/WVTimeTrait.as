package com.kaltura.kdpfl.plugin
{
	import com.kaltura.kdpfl.plugin.widevine.WvNetStream;
	
	import org.osmf.events.TimeEvent;
	import org.osmf.traits.TimeTrait;

	public class WVTimeTrait extends TimeTrait
	{
		public function WVTimeTrait(newNetStream : WvNetStream)
		{
			_wvNetStream = newNetStream;
			this.setDuration(_wvNetStream.getWvMediaTime());
			this.addEventListener(TimeEvent.DURATION_CHANGE, onDurationChange);
		}
		
		override public function get currentTime():Number
		{
			return _wvNetStream.getCurrentMediaTime();
		}
		
		private function onDurationChange (e : TimeEvent) : void
		{
			setDuration(e.time);
		}
		
		private var _wvNetStream : WvNetStream;
	}
}