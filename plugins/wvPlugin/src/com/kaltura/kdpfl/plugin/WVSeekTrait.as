package com.kaltura.kdpfl.plugin
{
	import com.kaltura.kdpfl.plugin.widevine.WvNetStream;
	import com.yahoo.astra.fl.controls.AbstractButtonRow;
	
	import flash.events.NetStatusEvent;
	import flash.net.NetStream;
	import flash.net.sendToURL;
	
	import org.osmf.traits.SeekTrait;
	import org.osmf.traits.TimeTrait;
	
	public class WVSeekTrait extends SeekTrait
	{
		public function WVSeekTrait(timeTrait:WVTimeTrait, netStream: WvNetStream)
		{
			super(timeTrait);
			_wvNetStream = netStream;
		}
		
		override protected function seekingChangeStart(newSeeking:Boolean, time:Number):void
		{
			if(newSeeking)
			{
				_wvNetStream.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
				_wvNetStream.seek(time);
			}
			else
			{
				_wvNetStream.resume();
			}
		}
		
		
		private function onNetStatus (e : NetStatusEvent) : void
		{
			if(e.info.code == "NetStream.Seek.Notify")
			{
				//_wvNetStream.removeEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
				setSeeking(false, _wvNetStream.getCurrentMediaTime() );
				
			}
		}
		
		private var _wvNetStream : WvNetStream;
		private var _seekFromPlay : Boolean = false;
	}
}