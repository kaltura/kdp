package com.kaltura.kdpfl.controller.media
{
	import com.kaltura.KalturaClient;
	import com.kaltura.commands.liveStream.LiveStreamIsLive;
	import com.kaltura.events.KalturaEvent;
	import com.kaltura.kdpfl.model.ConfigProxy;
	import com.kaltura.kdpfl.model.MediaProxy;
	import com.kaltura.kdpfl.model.ServicesProxy;
	import com.kaltura.kdpfl.model.type.EnableType;
	import com.kaltura.kdpfl.model.type.NotificationType;
	import com.kaltura.kdpfl.view.media.KMediaPlayerMediator;
	
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.events.TimerEvent;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	
	import org.osmf.media.MediaPlayer;
	import org.osmf.media.URLResource;
	import org.osmf.net.FMSURL;
	import org.osmf.net.MulticastResource;
	import org.osmf.net.NetClient;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	/**
	 * LiveStreamCommand is responsible for connecting a live stream. 
	 */	
	public class LiveStreamCommand extends SimpleCommand
	{
		
		/**
		 * defines the content of the liveStreamReady notification. 
		 */		
		public static const LIVE_STREAM_READY:String = "liveStreamReady";
		public static const DEFAULT_IS_LIVE_INTERVAL:int = 30;
		
		namespace xmlns = "http://ns.adobe.com/f4m/1.0";
		//timer for rtmp live sampling
		private var _liveStreamTimer : Timer;
		//timer for hds "isLive" sampling
		private var _liveHdsTimer : Timer;
		private var _netStream : NetStream;
		private var _streamUrl:String;
		private var _baseUrl : String;
		private var _entryUrl : String;
		private var _url : String;
		private var _resourceURL : FMSURL ;
		private var _nc : NetConnection;
		private var _resource : URLResource;
		private var _mediaProxy:MediaProxy;	
		private var _kc:KalturaClient;
		private var _player:MediaPlayer;
		private var _isRtmfp:Boolean
		private var _rtmfpObj:Object;
			
		/**
		 * indicates previous result from "isLive" API 
		 */		
		private var _wasLive:Boolean;	
			
		
		public function LiveStreamCommand()
		{
			_mediaProxy = facade.retrieveProxy(MediaProxy.NAME) as MediaProxy;
			_player = (facade.retrieveMediator(KMediaPlayerMediator.NAME) as KMediaPlayerMediator).player;
			_kc = ( facade.retrieveProxy( ServicesProxy.NAME ) as ServicesProxy ).kalturaClient;
			var flashvars:Object = (facade.retrieveProxy(ConfigProxy.NAME) as ConfigProxy).vo.flashvars;
			var interval:int = flashvars.liveStreamCheckInterval ? flashvars.liveStreamCheckInterval : DEFAULT_IS_LIVE_INTERVAL;
			if (_mediaProxy.vo.isHds)
				_liveHdsTimer = new Timer(1000 * interval);
			else	
				_liveStreamTimer = new Timer(1000, interval);
		}
		
		
		/**
		 * Begin connection to a live stream.
		 * @param notification
		 */		
		override public function execute(notification:INotification):void
		{
			if (_mediaProxy.vo.isHds)
			{
				checkIsLive();
			}
			else
			{
				_resource  = notification.getBody() as URLResource;	
				_url = _resource.url;
				_resourceURL = new FMSURL(_url);
				var loader : URLLoader = new URLLoader();
				if (_url.indexOf("rtmp") == 0)
				{
					_baseUrl = _resourceURL.protocol + "://" + _resourceURL.host + "/" + (_resourceURL.hasOwnProperty("appName") ? _resourceURL["appName"] : "");
					_entryUrl = (_resourceURL as FMSURL).streamName;
					//_entryUrl = (notification.getBody() as StreamingURLResource).
					createConnection();
					
				}
				else
				{
					loader.addEventListener(Event.COMPLETE, completeHandler);
					loader.load(new URLRequest(_url));
				}
			}
			
		}
		
		/**
		 * will call "isLive" API, to determine if HDS live stream is currently broadcasting. 
		 * @param e
		 * 
		 */		
		private function checkIsLive(e:TimerEvent = null):void {
			if (_mediaProxy.vo.isLive && _mediaProxy.vo.isHds && !_player.playing)
			{
				var isLive:LiveStreamIsLive = new LiveStreamIsLive(_mediaProxy.vo.entry.id, _mediaProxy.vo.deliveryType);
				isLive.addEventListener(KalturaEvent.COMPLETE, onIsLive);
				isLive.addEventListener(KalturaEvent.FAILED, onIsLiveError);
				_kc.post(isLive);
			}
			else
			{
				stopIsLiveCalls();
			}
		}
		
		/**
		 * handler for "isLive" response 
		 * @param event
		 * 
		 */		
		private function onIsLive(event:KalturaEvent):void {
			if (event.data=="1") //broadcasting now
			{
				if (!_wasLive)
				{
					_wasLive = true;
					sendNotification(NotificationType.ENABLE_GUI, {guiEnabled : true , enableType : EnableType.CONTROLS});
					sendNotification(LIVE_STREAM_READY);
				}						
			}
			else if (_wasLive)
			{
				_wasLive = false;
				_mediaProxy.vo.isOffline = true;
				sendNotification(NotificationType.ENABLE_GUI, {guiEnabled : false , enableType : EnableType.CONTROLS});
			}
			
			if (!_liveHdsTimer.running)
			{
				_liveHdsTimer.addEventListener(TimerEvent.TIMER, checkIsLive);
				_liveHdsTimer.start();
			}
		}
		
		/**
		 * handler for "isLive" error 
		 * @param event
		 * 
		 */		
		private function onIsLiveError(event:KalturaEvent):void{
			trace ("error calling isLive");
			stopIsLiveCalls();
		}
		
		/**
		 * stop hds live timer 
		 * 
		 */		
		private function stopIsLiveCalls():void
		{
			if (_liveHdsTimer.running)
			{
				_liveHdsTimer.removeEventListener(TimerEvent.TIMER, checkIsLive);
				_liveHdsTimer.stop();
			}
		}
		
		
		/**
		 * Handler for completion of the manifest load.
		 * @param e
		 * 
		 */		
		private function completeHandler ( e:Event ) : void
		{
			var manifest : XML = new XML((e.target as URLLoader).data);
			_baseUrl = manifest.xmlns::baseURL.text();

			var children : XMLList = manifest.xmlns::media;
			_entryUrl = children[0].@url;
			
			//support manifest that has no baseUrl and rtmfp
			if(!_baseUrl && _entryUrl == "rtmfp:"){
				_baseUrl = "rtmfp:"
				_isRtmfp = true;
				_rtmfpObj = new Object();
				_rtmfpObj.groupspec = String(children[0].@groupspec);
				_rtmfpObj.multicastStreamName = String(children[0].@multicastStreamName);
				
			}
			
			
			createConnection();
		}
		/**
		 * Function creates net connection to the stream base url
		 * 
		 */		
		private function createConnection () : void
		{	
			//creation of a net client and connecting it to the FMS
			_nc = new NetConnection();
			_nc.client = new NetClient();
			_nc.addEventListener(NetStatusEvent.NET_STATUS, connectionComplete);	
			_nc.connect(_baseUrl);
		}
		/**
		 * Handler for successful connection to the live stream base url 
		 * @param e
		 * 
		 */		
		private function connectionComplete (e : NetStatusEvent):void
		{
			var msg : String = e.info.code;
			
			//If the client has successfully connected to the FMS, create a new net stream connected to the specific stream
			if(msg == "NetConnection.Connect.Success"){
				var video : Video = new Video();
				if(_isRtmfp){
					var video : Video = new Video();
					//var resource:MulticastResource = new MulticastResource("rtmfp:","G:0101210513d249f2cb4127b40cfa757866850278793f814ded3c587fe5889e889a7a9f6c010d160e666d732e6d756c7469636173742e6578616d706c6500070aef0102037530");
					var resource:MulticastResource = new MulticastResource(_baseUrl,_rtmfpObj.groupspec);
					var _netStream:NetStream = new NetStream(_nc, resource.groupspec);
					_netStream.soundTransform = new SoundTransform (0);
					video.attachNetStream(_netStream);
					_netStream.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler );
					_netStream.play(_rtmfpObj.multicastStreamName);
				}else{
					_netStream = new NetStream(e.target as NetConnection);
					//_netStream.receiveAudio(false);
					_netStream.soundTransform = new SoundTransform (0);
					_netStream.client = new CustomClient();
					//_netStream.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
					video.attachNetStream(_netStream);
					_netStream.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler );
					_netStream.play(_entryUrl);
				}
			}
		}
		/**
		 * Handler for successful connection to the specific live stream within the base url 
		 * @param e
		 * 
		 */		
		private function netStatusHandler (e:NetStatusEvent) : void
		{
			
			if (!_netStream && _isRtmfp){
				_netStream = e.currentTarget as NetStream;
			}
			
			if(e.info.code == "NetStream.Play.Start")
			{
				_netStream.soundTransform.volume = 0;
				//Start a timer to test whether the stream is currently live or offline
				_liveStreamTimer.addEventListener(TimerEvent.TIMER, onTick);
				_liveStreamTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
				_liveStreamTimer.start(); 
			}
		}
		/**
		 * Hnadler for timer complete event, in case the net connection has not detected any video playing. 
		 * @param e
		 * 
		 */		
		private function onTimerComplete(e : TimerEvent) : void
		{
			//If we have reached the TimerComplete event and the stream is still offline , restart the procedure
			_liveStreamTimer.removeEventListener(TimerEvent.TIMER,onTick);
			_liveStreamTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
			_liveStreamTimer.stop();
			_netStream.close();
			_nc.close();
			if ((facade.retrieveProxy(MediaProxy.NAME) as MediaProxy).vo.isLive)
				sendNotification(NotificationType.LIVE_ENTRY,_resource); 
		}
		
	
		/**
		 * Function checks whether the NetStream connected to the target live-stream  has an FPS.
		 * If the FPS is greater than 0, then the stream is currently active and can be shown in the KDP.
		 * @param e
		 * 
		 */		
		private function onTick(e : TimerEvent) : void
		{
			
			//Check whether the stream's current FPS is greater than 0. If it is then the timer is stopped, and the live stream starts playing as an entry.
			if(_netStream.currentFPS > 0 || _netStream.info.audioByteCount)
			{
				_liveStreamTimer.removeEventListener(TimerEvent.TIMER,onTick);
				_liveStreamTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
				_liveStreamTimer.stop();
				_netStream.close();
				_nc.close();
				sendNotification(NotificationType.ENABLE_GUI, {guiEnabled : true , enableType : EnableType.CONTROLS});
				sendNotification(LIVE_STREAM_READY);
			}
		}
	}
}
class CustomClient {
	public function onMetaData(info:Object):void {
		//trace("metadata: duration=" + info.duration + " width=" + info.width + " height=" + info.height + " framerate=" + info.framerate);
	}
	public function onCuePoint(info:Object):void {
		//trace("cuepoint: time=" + info.time + " name=" + info.name + " type=" + info.type);
	}
}