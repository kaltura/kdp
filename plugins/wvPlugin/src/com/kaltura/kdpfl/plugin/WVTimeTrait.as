package com.kaltura.kdpfl.plugin
{
	import com.widevine.WvNetStream;
	
	import flash.events.NetStatusEvent;
	
	import org.osmf.events.TimeEvent;
	import org.osmf.net.NetStreamCodes;
	import org.osmf.traits.TimeTrait;

	public class WVTimeTrait extends TimeTrait
	{
		public function WVTimeTrait(newNetStream : WvNetStream)
		{
			_wvNetStream = newNetStream;
			this.setDuration(_wvNetStream.getWvMediaTime());
			this.addEventListener(TimeEvent.DURATION_CHANGE, onDurationChange, false, 0, true);
			_wvNetStream.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus, false, 0, true );
			
		}
		
		override public function get currentTime():Number
		{
			if (_wvNetStream.time > duration || Math.round(_wvNetStream.time) == Math.round(duration))  
			{
				return duration
			}
			else
			{
				return _wvNetStream.getCurrentMediaTime();
			}
		}
		
		private function onDurationChange (e : TimeEvent) : void
		{
			setDuration(e.time);
		}

		private function onNetStatus(e : Object) : void
		{
			if (e.info.code == NetStreamCodes.NETSTREAM_PLAY_COMPLETE)
				signalComplete();
		}
		private var _wvNetStream : WvNetStream;
	}
}