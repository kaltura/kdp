package com.kaltura.kdpfl.plugin
{
	import com.kaltura.kdpfl.plugin.widevine.WvNetConnection;
	import com.kaltura.kdpfl.plugin.widevine.WvNetStream;
	import com.kaltura.osmf.kaltura.WVMediaResource;
	
	import flash.events.NetStatusEvent;
	import flash.events.TimerEvent;
	import flash.net.NetStream;
	import flash.utils.Timer;
	
	import org.osmf.events.LoaderEvent;
	import org.osmf.net.StreamingURLResource;
	import org.osmf.traits.LoadState;
	import org.osmf.traits.LoadTrait;
	import org.osmf.traits.LoaderBase;

	public class WVLoadTrait extends LoadTrait
	{
		
		public function WVLoadTrait(loader:LoaderBase, resource:WVMediaResource)
		{
			super(loader, resource);
			_drmNetConnection = new WvNetConnection();
			setLoadState(LoadState.UNINITIALIZED);
		}
		
		override public function load():void
		{
			setLoadState(LoadState.LOADING);
			_drmNetConnection.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			_drmNetConnection.connect((resource as WVMediaResource).baseUrl);
		}
		
		private function netStatusHandler (e: NetStatusEvent): void
		{
			_drmNetStream = new WvNetStream(_drmNetConnection);
			_drmNetStream.checkPolicyFile = true;
			setBytesTotal(_drmNetStream.bytesTotal);
			_bytesLoadedTimer = new Timer(1000, 0);
			_bytesLoadedTimer.addEventListener(TimerEvent.TIMER, onBytesLoadedTimer);
			_bytesLoadedTimer.start();
			setLoadState(LoadState.READY);
		}
		
		public function get drmNetStream():WvNetStream
		{
			return _drmNetStream;
		}

		public function set drmNetStream(value:WvNetStream):void
		{
			_drmNetStream = value;
		}

		public function get drmNetConnection():WvNetConnection
		{
			return _drmNetConnection;
		}

		public function set drmNetConnection(value:WvNetConnection):void
		{
			_drmNetConnection = value;
		}
		
		private function onBytesLoadedTimer (e : TimerEvent) : void
		{
			if (bytesLoaded < bytesTotal)
			{
				setBytesLoaded(_drmNetStream.bytesLoaded);
			}
			else
			{
				_bytesLoadedTimer.stop();
				_bytesLoadedTimer.removeEventListener(TimerEvent.TIMER, onBytesLoadedTimer);
			}
			
		}

		private var _drmNetStream : WvNetStream;
		private var _drmNetConnection : WvNetConnection;
		private var _bytesLoadedTimer : Timer;
	}
}