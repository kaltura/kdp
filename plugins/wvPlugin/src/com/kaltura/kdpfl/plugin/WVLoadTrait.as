package com.kaltura.kdpfl.plugin
{
	import com.widevine.WvNetConnection;
	import com.widevine.WvNetStream;
	
	import flash.events.NetStatusEvent;
	import flash.events.TimerEvent;
	import flash.net.NetConnection;
	import flash.utils.Timer;
	
	import org.osmf.media.MediaResourceBase;
	import org.osmf.traits.LoadState;
	import org.osmf.traits.LoadTrait;
	import org.osmf.traits.LoaderBase;

	public class WVLoadTrait extends LoadTrait
	{
		
		public function WVLoadTrait(loader:LoaderBase, resource:MediaResourceBase)
		{
			super(loader, resource);
			_drmNetConnection = new WvNetConnection();
			setLoadState(LoadState.UNINITIALIZED);
		}
		
		override public function load():void
		{
			setLoadState(LoadState.LOADING);
			_drmNetConnection.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			//TODO - check with Hila
			var url:String;
			if (resource.hasOwnProperty('url'))
				url = resource["url"];// + "/name/a.wvm";
			if (resource.hasOwnProperty('baseUrl'))
				url = resource["baseUrl"];

			_drmNetConnection.connect(url);

			
			
		}
		
		private function netStatusHandler (e: NetStatusEvent): void
		{
			if (e.info.code == "NetConnection.Connect.Success")
			{	
				_drmNetStream = new WvNetStream(_drmNetConnection);
				_drmNetStream.checkPolicyFile = true;
				setBytesTotal(_drmNetStream.bytesTotal);
				_bytesLoadedTimer = new Timer(1000, 0);
				_bytesLoadedTimer.addEventListener(TimerEvent.TIMER, onBytesLoadedTimer);
				_bytesLoadedTimer.start();
				setLoadState(LoadState.READY);
				_drmNetConnection.removeEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			}
		
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