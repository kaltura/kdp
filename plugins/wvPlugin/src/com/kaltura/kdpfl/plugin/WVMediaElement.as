package com.kaltura.kdpfl.plugin
{
	import com.kaltura.kdpfl.plugin.widevine.WvNetStream;
	import com.kaltura.osmf.kaltura.WVMediaResource;
	
	import flash.media.Video;
	import flash.net.NetStream;
	
	import org.osmf.events.TimeEvent;
	import org.osmf.media.LoadableElementBase;
	import org.osmf.media.MediaElement;
	import org.osmf.media.MediaResourceBase;
	import org.osmf.metadata.Metadata;
	import org.osmf.net.NetClient;
	import org.osmf.net.NetStreamCodes;
	import org.osmf.net.NetStreamPlayTrait;
	import org.osmf.traits.LoadTrait;
	import org.osmf.traits.LoaderBase;
	import org.osmf.traits.MediaTraitType;
	import org.osmf.utils.OSMFStrings;
	
	public class WVMediaElement extends LoadableElementBase
	{
		public function WVMediaElement()
		{
			super();
			loader = new WVLoader();
			
		}
		
		override protected function createLoadTrait(resource:MediaResourceBase, loader:LoaderBase):LoadTrait
		{
			return new WVLoadTrait(loader, resource as WVMediaResource);
		}
		
		override protected function processReadyState():void
		{
			//trace("ready");
			createVideo();
			_video.smoothing = true;
			_netStream = (getTrait(MediaTraitType.LOAD) as WVLoadTrait).drmNetStream;
			_netStream.client = new NetClient();
			(_netStream.client as NetClient).addHandler(NetStreamCodes.ON_META_DATA, onMetaData);
			_video.attachNetStream(_netStream);
			//_netStream.play((resource as WVMediaResource).movieName);
			_movieName = (resource as WVMediaResource).movieName;
			finishLoad();
		}
		
		private function finishLoad() : void
		{
			var playTrait : WVPlayTrait = new WVPlayTrait(_netStream, _movieName);
			addTrait(MediaTraitType.PLAY, playTrait);
			var doTrait : WVDisplayObjectTrait = new WVDisplayObjectTrait(video, 400, 300);
			addTrait(MediaTraitType.DISPLAY_OBJECT, doTrait);
			var timeTrait:WVTimeTrait = new WVTimeTrait(_netStream);
			addTrait(MediaTraitType.TIME, timeTrait);
			var audioTrait : WVAudioTrait = new WVAudioTrait(_netStream);
			addTrait(MediaTraitType.AUDIO, audioTrait);
			var seekTrait : WVSeekTrait = new WVSeekTrait(timeTrait, _netStream);
			addTrait(MediaTraitType.SEEK, seekTrait);       
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
		
		
		private var _video:Video;
		private var _netStream : WvNetStream;
		private var _movieName : String;
		
	}
}