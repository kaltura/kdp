package com.kaltura.kdpfl.plugin
{
	import com.widevine.WvNetStream;
	
	import flash.events.NetStatusEvent;
	
	import org.osmf.traits.SeekTrait;
	
	public class WVSeekTrait extends SeekTrait
	{
		public function WVSeekTrait(timeTrait:WVTimeTrait, netStream: WvNetStream)
		{
			super(timeTrait);
			_wvNetStream = netStream;
		}

	
			
		override protected function seekingChangeStart(newSeeking:Boolean, time:Number):void
		{
			trace("newSeeking ",newSeeking , "time",time);
			if(newSeeking)
			{
				_wvNetStream.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus, false, 0, true );
				/*_wvNetStream.seek(time);
				_wvNetStream.playRewind();*/
				
				previousTime = _wvNetStream.getCurrentMediaTime();
				expectedTime = time;
				

				_wvNetStream.seek(expectedTime);

			}
			else
			{
				/*if (_wvNetStream.getPlayStatus() )
				{
					_wvNetStream.resume();
				}
				else
				{
					_wvNetStream.resume();
					_wvNetStream.pause();
				}*/

				
			}
			
		}
		
		
		private function onNetStatus (e : NetStatusEvent) : void
		{
			if(e.info.code == "NetStream.Seek.Notify")
			{
				//_wvNetStream.removeEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
				setSeeking(false, expectedTime );
				
			}
		}
		
		private var _wvNetStream : WvNetStream;
		private var expectedTime : Number;
		private var previousTime : Number;
		private var _seekFromPlay : Boolean = false;
	}
}