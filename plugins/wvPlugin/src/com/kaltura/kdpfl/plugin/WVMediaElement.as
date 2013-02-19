package com.kaltura.kdpfl.plugin
{
	import com.widevine.WvNetStream;
	
	import flash.events.NetStatusEvent;
	import flash.media.Video;
	
	import org.osmf.events.TimeEvent;
	import org.osmf.media.LoadableElementBase;
	import org.osmf.media.MediaResourceBase;
	import org.osmf.net.NetClient;
	import org.osmf.net.NetStreamBufferTrait;
	import org.osmf.net.NetStreamCodes;
	import org.osmf.net.NetStreamDisplayObjectTrait;
	import org.osmf.traits.LoadTrait;
	import org.osmf.traits.LoaderBase;
	import org.osmf.traits.MediaTraitType;
	
	public class WVMediaElement extends LoadableElementBase
	{
		/**
		 * Width of media
		 */		
		protected var _w:Number;
		/**
		 * Height of media.   
		 */		
		protected var _h:Number;
		
		public function WVMediaElement(w:Number,h:Number)
		{
			super();
			_w = w;
			_h = h;
			loader = new WVLoader();
		}
		
		public function get netStream():WvNetStream
		{
			return _netStream;
		}

		override protected function createLoadTrait(resource:MediaResourceBase, loader:LoaderBase):LoadTrait
		{
			return new WVLoadTrait(loader, resource);
		}
		
		override protected function processReadyState():void
		{
			createVideo();
			_video.smoothing = true;
			_netStream = (getTrait(MediaTraitType.LOAD) as WVLoadTrait).drmNetStream;
			_netStream.client = new NetClient();
			(_netStream.client as NetClient).addHandler(NetStreamCodes.ON_META_DATA, onMetaData);
			_netStream.addEventListener( NetStatusEvent.NET_STATUS, onNetStatus);
			_video.attachNetStream(_netStream);
			//_netStream.play((resource as WVMediaResource).movieName);
			
			//TODO - check with Hila
			var url:String;
			if (resource.hasOwnProperty('url'))
				url = resource["url"];
			if (resource.hasOwnProperty('baseUrl'))
				url = resource["baseUrl"];
			
			var arr:Array = url.split("/");
			_movieName = arr[arr.length-1];

			finishLoad();
		}
		
		private function finishLoad() : void
		{
			var playTrait : WVPlayTrait = new WVPlayTrait(_netStream, _movieName);
			addTrait(MediaTraitType.PLAY, playTrait);
			var doTrait : NetStreamDisplayObjectTrait = new NetStreamDisplayObjectTrait(_netStream, _video, _w , _h);
			addTrait(MediaTraitType.DISPLAY_OBJECT, doTrait);
			var timeTrait:WVTimeTrait = new WVTimeTrait(_netStream);
			addTrait(MediaTraitType.TIME, timeTrait);
			var audioTrait : WVAudioTrait = new WVAudioTrait(_netStream);
			addTrait(MediaTraitType.AUDIO, audioTrait);
			var seekTrait : WVSeekTrait = new WVSeekTrait(timeTrait, _netStream);
			addTrait(MediaTraitType.SEEK, seekTrait);  
			var bufferTrait : NetStreamBufferTrait = new NetStreamBufferTrait(_netStream);
			addTrait(MediaTraitType.BUFFER, bufferTrait); 
		}
		
		private function createVideo() : void
		{
			_video = new Video();
		}

		public function get video():Video
		{
			return _video;
		}

		public function set video(value:Video):void
		{
			_video = value;
		}
		
		private function onMetaData (e : Object) : void
		{
			(getTrait(MediaTraitType.TIME) as WVTimeTrait).dispatchEvent(new TimeEvent(TimeEvent.DURATION_CHANGE,false, false, e.duration as Number));
		}
		private function onNetStatus (e : NetStatusEvent) : void
		{
			/*switch (e.info.code)
			{
				case "NetStream.Wv.EmmSuccess":
				case "NetStream.Wv.EmmFailed":
				case "NetStream.Wv.EmmError":
				case "NetStream.Wv.EmmExpired":
				case "NetStream.Wv.SwitchUp":
				case "NetStream.Wv.SwitchDown":
				case "NetStream.Wv.LogError":*/
					trace ("NetStatusEvent type=netStatus" + e.info.code)
					/*break;
			}*/
		}
		
		
		private var _video:Video;
		private var _netStream : WvNetStream;
		private var _movieName : String;
		
	}
}