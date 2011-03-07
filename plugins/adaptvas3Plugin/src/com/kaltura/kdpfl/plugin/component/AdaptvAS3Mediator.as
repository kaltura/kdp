package com.kaltura.kdpfl.plugin.component {
	import com.kaltura.KalturaClient;
	import com.kaltura.kdpfl.model.ConfigProxy;
	import com.kaltura.kdpfl.model.MediaProxy;
	import com.kaltura.kdpfl.model.SequenceProxy;
	import com.kaltura.kdpfl.model.ServicesProxy;
	import com.kaltura.kdpfl.model.type.NotificationType;
	import com.kaltura.kdpfl.model.type.SequenceContextType;
	import com.kaltura.puremvc.as3.patterns.mediator.SequenceMultiMediator;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.system.Security;
	import flash.utils.Timer;
	
	import org.puremvc.as3.interfaces.INotification;

	public class AdaptvAS3Mediator extends SequenceMultiMediator {
		public static const NAME:String = "adaptvAS3Mediator";
		
		private static var PRE:String = "pre";
		private static var POST:String = "post";

		// entry data:
		private var _entryTitle:String = "";
		private var _entryId:String = "";
		private var _entryUrl:String = "";
		private var _entryDuration:int = 0;
		private var _entryDescription:String = "";
		private var _isEntryComplete:Boolean = false;
		
		// entry progress timer
		private var _timer:Timer = null;
		
		// entry progress
		private var _playheadTime:Number = 0;
		
		// preroll or postroll
		private var _adContext:String;
		
		// video dimentions
		private var _width:Number;
		private var _height:Number;
		
		// adaptv player
		private var _adaptvPlayer:AdaptvAS3Player;
		
		// indicates the ad (and video) should play
		private var _shouldPlay:Boolean = false;

		/**
		 * The id attribute of the div to contain the companion ad
		 * */
		public var companionId:String = "";

		/**
		 * Parameter to pass metadata for specific ad networks, or
		 * for insertion into dynamic ad tags. </br>
		 * Contents of the context parameter must be url encoded
		 * */
		public var k_adaptv_context:String = "";

		/**
		 * publisher key provided by Adap.tv.
		 */		
		public var key:String = "";
		
		/**
		 * Name of the zone for this videoview. Optional.
		 * @default "default"
		 */		
		public var zone:String = "default"; //hj438 is a zone with pre & baner works always !
		
		/**
		 * url of something 
		 */		
		public var url:String = "";
		
		/**
		 * A comma-delimited list of top level categories 
		 */		
		public var categories:String = "";
		
		/**
		 * A comma-delimited list of tags/keywords 
		 */		
		public var keywords:String = "";
		
		
		public var debug:String = "false";


		public function AdaptvAS3Mediator(viewComponent:Object = null) {
			Security.allowDomain("*");


			super(viewComponent);
		}


		/**
		 * for prerolls and postrolls, we need to trigger ads manually.
		 */
		public function forceStart():void {
			var sequenceManager:Object = facade.retrieveProxy("sequenceProxy");
			if (sequenceManager["sequenceContext"] == SequenceContextType.PRE) {
				sendNotification(preSequenceNotificationStartName);
			}
			else if (sequenceManager["sequenceContext"] == SequenceContextType.POST) {
				sendNotification(postSequenceNotificationStartName);
			}
		}



		override public function onRegister():void {
			Security.allowDomain("*");
			var config:Object = {};
			_adaptvPlayer = new AdaptvAS3Player(config);
			_adaptvPlayer.addEventListener("playVideo", doPlay);
			_adaptvPlayer.addEventListener("pauseVideo", doPause);

			(viewComponent as AdptvAS3).adaptv = _adaptvPlayer;
		}


		override public function listNotificationInterests():Array {
			var notify:Array = new Array(NotificationType.ENTRY_READY, NotificationType.PLAYER_UPDATE_PLAYHEAD, NotificationType.MEDIA_READY, "durationChange", "playerPlayEnd", "playerPlayed", preSequenceNotificationStartName, postSequenceNotificationStartName);
			return notify;
		}


		override public function handleNotification(note:INotification):void {
			var kc:KalturaClient = (facade.retrieveProxy(ServicesProxy.NAME) as ServicesProxy).kalturaClient;
			
			var sequenceProxy:SequenceProxy = facade.retrieveProxy(SequenceProxy.NAME) as SequenceProxy;
			
			var config:ConfigProxy = facade.retrieveProxy(ConfigProxy.NAME) as ConfigProxy;
			
			var media:MediaProxy = facade.retrieveProxy(MediaProxy.NAME) as MediaProxy;
			
			var data:Object = note.getBody();
			switch (note.getName()) {
				case NotificationType.MEDIA_READY:
					if (!sequenceProxy.vo.isInSequence)
						setEntryData(media.vo.entry.id, media.vo.entry.name, media.vo.entry.dataUrl, media.vo.entry.duration, media.vo.entry.description, media.vo.entry);
					break;
				case "playerUpdatePlayhead":
					if (!sequenceProxy["vo"]["isInSequence"])
						_playheadTime = data as Number;
					break;
				case "playerPlayEnd":
					_isEntryComplete = true;
					break;
				case "playerPlayed":
					break;
				case preSequenceNotificationStartName:
					_shouldPlay = true;
					_adaptvPlayer.addEventListener("playVideo", doPlay);
					preAds();
					break;
				case postSequenceNotificationStartName:
					_adaptvPlayer.addEventListener("playVideo", doPlay);
					postAds(); //TODO: check if other function should be called here
					break;
			}

		}


		public function get view():DisplayObject {
			return viewComponent as DisplayObject;
		}


		private function preAds():void {
			_adContext = PRE;
			var config:Object = {

				// consult http://publishers.adap.tv/pubcon/app/support/integration/reference
				// for more detailed information.
				// parameters about the video view

					key: key, // Your publisher key provided by Adap.tv.
					zid: zone, // Name of the zone for this videoview. Optional, defaults to "default"
					adaptag: "partner1, tag1", // A comma-delimited list of adaptags
					companionId: companionId, // The id attribute of the div to contain the companion ad

					// Parameter to pass metadata for specific ad networks, or for insertion into dynamic ad tags.
					// Contents of the context parameter must be url encoded
					// Commas are not allowed in both keys and values
					// Equals signs (=) are allowed in values, but not in keys
					// In this case, we are passing 'key1=value1,key2=value2'
					context: k_adaptv_context,

					// parameters about the video

					id: _entryId, // The unique identifier of the video (limit 64 chars)
					title: _entryTitle, // The title of the video
					duration: _entryDuration, // The duration of video in _seconds_, if applicable
					url: _entryUrl, // A valid HTTP or RMTP URL for the video (usually .flv) file.
					description: _entryDescription, // description of video
					keywords: keywords, // A comma-delimited list of tags/keywords
					categories: categories, // A comma-delimited list of top level categories    

					// parameters about the video player

					width: _width, // width of video frame
					height: _height, // height of video frame

					// parameters to position the ad player

					htmlX: "0", // horizontal offset, in pixels. defaults to "0".
					htmlY: "0" // vertical offset, in pixels. defaults to "0".

				};
			_adaptvPlayer.initialize(config);
			_initAdapTvTimer();
			facade.sendNotification("enableGui", {guiEnabled: false, enableType: "full"});
			//doPause();
		}

		private function constructConfig () : Object 
		{
			var config:Object = {
				
				// consult http://help.adap.tv/index.php/Integration_API_Reference
				// for more detailed information.
				
				// -- Required parameters --
				// parameters about the player clip view
				key: key,     // Your publisher key provided by Adap.tv.
				
				// parameters about the player clip
				id: _entryId,     // The unique identifier of the clip (limit 64 chars)
				title: _entryTitle,    // The title of the clip
				duration: _entryDuration,    // The duration of clip in _seconds_, if applicable
				url: , // A valid HTTP or RMTP URL for the clip (often .flv) file.
				description: "Test Video",     // description of clip
				keywords: "test,video,adaptv",     // A comma-delimited list of tags/keywords
				categories: ,  // A comma-delimited list of top level categories    
				
				// -- Optional parameters --
				zid: zone,     // Name of the zone for this view. Optional.
				companionId: companionId,     // The id attribute of the div to contain the companion ad
				pageUrlOv: "http://www.toppage.com/"     // page URL override
				
			};
			// context is a parameter used for passing custom keys to the ad player.
			var oContext:Object = {
				key1: "value1",
				key2: "value2"
			};
		}
		
		/**
		 * for now there is no post ads - bypass and send the notification
		 * */
		private function postAds():void {
			_adContext = POST;
			facade.sendNotification("sequenceItemPlayEnd");
		}


		private function doPause(event:Event = null):void {
		}


		/**
		 * play the entry 
		 * @param event
		 */		
		private function doPlay(event:Event = null):void {
			// the mediator should know if it should realy start playing the video
			// or the fail was before it was asked to play
			if (_shouldPlay) {
				facade.sendNotification("enableGui", {guiEnabled: true, enableType: "full"});
				facade.sendNotification("sequenceItemPlayEnd");
				_adaptvPlayer.removeEventListener("playVideo", doPlay);
				_shouldPlay = false;
			}
		}


		/**
		 * intiialize the timer used to track video progress 
		 */		
		private function _initAdapTvTimer():void {
			if (_timer) {
				return;
			}

			_timer = new Timer(500, 0);
			_timer.addEventListener(TimerEvent.TIMER, onTimer);
			_timer.start();
		}

		
		/**
		 * Call when video player window changes size (example fullscreen)
		 * */
		public function setScreenSize(w:Number, h:Number):void {
			_width = w;
			_height = h;
			if (_adaptvPlayer)
				_adaptvPlayer.setSize(w, h);
		}


		/**
		 * track video progress 
		 * @param event
		 */		
		private function onTimer(event:TimerEvent):void {
			if (_adaptvPlayer)
				_adaptvPlayer.setStatus({time: _playheadTime, complete: _isEntryComplete});
		}


		public function setEntryData(id:String, title:String, url:String, duration:int, description:String, entry:Object = null):void {
			_entryTitle = title ? title : "";
			_entryId = id;
			_entryUrl = url;
			if (duration) {
				_entryDuration = duration;
			}
			else {
				_entryDuration = 20;
			}
			_entryDescription = description ? description : "";
			_isEntryComplete = false;

			if (entry) {
				if (entry["tags"])
					categories = entry["tags"];
				keywords = _entryTitle.toString().split(" ") + "," + _entryDescription.toString().split(" ");
			}
		}
	}
}