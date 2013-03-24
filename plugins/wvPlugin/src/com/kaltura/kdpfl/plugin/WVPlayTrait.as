package com.kaltura.kdpfl.plugin
{
	import com.widevine.WvNetStream;
	
	import flash.events.NetStatusEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.osmf.traits.PlayState;
	import org.osmf.traits.PlayTrait;
	
	public class WVPlayTrait extends PlayTrait
	{
		public function WVPlayTrait(netStream:WvNetStream, movieName : String)
		{
			super();
			_wvNetStream = netStream;
			_movieName = movieName;
		}
		
		override protected function playStateChangeStart(newPlayState:String):void
		{
			_actuallyPlays = false;
			if (newPlayState == PlayState.PLAYING)
			{
				if (!_hasPlayed)
				{
					_hasPlayed = true;
					_wvNetStream.play(_movieName);
				}
				else
				{
					_wvNetStream.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus, false, 0, true);
					_resumeBugTimer.addEventListener(TimerEvent.TIMER, onResumeBugTimer, false, 0, true);
					_wvNetStream.resume();
					_resumeBugTimer.start();
					
					
				}
			}
			else if (newPlayState == PlayState.PAUSED)
			{
				_wvNetStream.pause();
			}
		}
		
		private function onResumeBugTimer (e : TimerEvent) : void
		{
			if (!_actuallyPlays)
			{
				_wvNetStream.pause();
				_wvNetStream.resume();
			}
			else
			{
				_wvNetStream.removeEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
				_resumeBugTimer.removeEventListener(TimerEvent.TIMER, onResumeBugTimer);
			}
		}
		
		private function onNetStatus (e : NetStatusEvent) : void
		{
			if (e.info.code == "NetStream.Play.Start")
			{
				_actuallyPlays = true;
				_wvNetStream.removeEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
				_resumeBugTimer.removeEventListener(TimerEvent.TIMER, onResumeBugTimer);
			}
		}
		
		private var _wvNetStream : WvNetStream;
		private var _movieName : String;
		private var _hasPlayed : Boolean = false;
		private var _resumeBugTimer : Timer = new Timer(4000,0);
		private var _actuallyPlays : Boolean = false;
	}
}