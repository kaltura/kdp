package com.kaltura.kdpfl.plugin.component {
	import com.kaltura.KalturaClient;
	import com.kaltura.kdpfl.model.ConfigProxy;
	import com.kaltura.kdpfl.model.MediaProxy;
	import com.kaltura.kdpfl.model.SequenceProxy;
	import com.kaltura.kdpfl.model.ServicesProxy;
	import com.kaltura.kdpfl.model.type.AdsNotificationTypes;
	import com.kaltura.kdpfl.model.type.NotificationType;
	import com.kaltura.kdpfl.model.type.SequenceContextType;
	import com.kaltura.puremvc.as3.patterns.mediator.SequenceMultiMediator;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.system.Security;
	import flash.utils.Timer;
	
	import org.puremvc.as3.interfaces.INotification;

	public class AdaptvAS3Mediator extends SequenceMultiMediator 
	{
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
		
		public var pageUrlOv:String ;
		
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
		

		/**
		 * The id attribute of the div to contain the companion ad
		 * */
		public var companionId:String = "";

		/**
		 * Parameter to pass metadata for specific ad networks, or
		 * for insertion into dynamic ad tags. </br>
		 * Contents of the context parameter must be url encoded
		 **/
		public var k_adaptv_context:String = "";

		/**
		 * publisher key provided by Adap.tv.
		 */		
		public var key:String = "";
		
		/**
		 * Name of the zone for this videoview. Optional.
		 * @default "default"
		 */		
		public var zone:String = "default"; 
		
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


		public function AdaptvAS3Mediator(viewComponent:Object = null)
		{
			Security.allowDomain("*");
			_adaptvPlayer = viewComponent as AdaptvAS3Player;
			_adaptvPlayer.addEventListener(AdaptvAS3Player.ADAPTV_ENABLE_CHANGED , onEnebledChanged);
			_adaptvPlayer.addEventListener(AdaptvAS3Player.ADAPTV_PAUSE , onPause);
			_adaptvPlayer.addEventListener(AdaptvAS3Player.ADAPTV_PLAY , onPlay);
			_adaptvPlayer.addEventListener(AdaptvAS3Player.ADAPTV_RESUME , onResume);
			_adaptvPlayer.addEventListener(AdaptvAS3Player.ADAPTV_STAT , sendStat);
			_adaptvPlayer.addEventListener(AdaptvAS3Player.ADAPTV_STAT_CLICK , sendStatClick);
			super(viewComponent);
		}


		/**
		 * for prerolls and postrolls, we need to trigger ads manually.
		 */
		public function forceStart():void 
		{
			var sequenceManager:Object = facade.retrieveProxy("sequenceProxy");
			if (sequenceManager["sequenceContext"] == SequenceContextType.PRE) {
				sendNotification(preSequenceNotificationStartName);
			}
			else if (sequenceManager["sequenceContext"] == SequenceContextType.POST) {
				sendNotification(postSequenceNotificationStartName);
			}
		}

		override public function onRegister():void 
		{
			Security.allowDomain("*");
			var config:Object = {};
		}

		override public function listNotificationInterests():Array 
		{
			var notify:Array = new Array(NotificationType.ENTRY_READY,NotificationType.CHANGE_VOLUME, NotificationType.PLAYER_UPDATE_PLAYHEAD, NotificationType.MEDIA_READY, "durationChange", "playerPlayEnd", "playerPlayed", preSequenceNotificationStartName, postSequenceNotificationStartName);
			return notify;
		}


		override public function handleNotification(note:INotification):void 
		{
			var kc:KalturaClient = (facade.retrieveProxy(ServicesProxy.NAME) as ServicesProxy).kalturaClient;
			var sequenceProxy:SequenceProxy = facade.retrieveProxy(SequenceProxy.NAME) as SequenceProxy;
			var config:ConfigProxy = facade.retrieveProxy(ConfigProxy.NAME) as ConfigProxy;
			var media:MediaProxy = facade.retrieveProxy(MediaProxy.NAME) as MediaProxy;
			
			var data:Object = note.getBody();
			switch (note.getName()) 
			{
				case NotificationType.CHANGE_VOLUME:
					_adaptvPlayer.setVolume(Number(note.getBody()));
				break;
				case NotificationType.MEDIA_READY:
					if (!sequenceProxy.vo.isInSequence)
						setEntryData(media.vo.entry.id, media.vo.entry.name, media.vo.entry.dataUrl, media.vo.entry.duration, media.vo.entry.description, media.vo.entry);
					break;
				case "playerUpdatePlayhead":
					if (!sequenceProxy["vo"]["isInSequence"])
						_playheadTime = data as Number;
						_adaptvPlayer.playheadPosition = _playheadTime;
					break;
				case "playerPlayed":
					break;
				case preSequenceNotificationStartName:
					preAds();
				break;
				case postSequenceNotificationStartName:
					postAds(); //TODO: check if other function should be called here
				break;
			}

		}


		public function get view():DisplayObject 
		{
			return viewComponent as DisplayObject;
		}


		private function preAds():void 
		{
			_adContext = PRE;
			_adaptvPlayer.fetchScript();
		}


		
		/**
		 * for now there is no post ads - bypass and send the notification
		 * */
		private function postAds():void
		{
			_adContext = POST;
			_adaptvPlayer.endOfClip();
		}


		private function onPause(event:Event = null):void 
		{
			// TODO implement
			facade.sendNotification("doPause");
		}


		/**
		 * Send stats of a click
		 * @param event
		 */		
		private function sendStatClick(event:Event = null):void
		{
			var sequenceProxy:SequenceProxy = facade.retrieveProxy(SequenceProxy.NAME) as SequenceProxy;
			if(sequenceProxy.sequenceContext == SequenceContextType.PRE)
				facade.sendNotification(AdsNotificationTypes.AD_CLICK,{timeSlot:'preroll'});
			if(sequenceProxy.sequenceContext == SequenceContextType.POST)
				facade.sendNotification(AdsNotificationTypes.AD_CLICK,{timeSlot:'postroll'});
			if(sequenceProxy.sequenceContext == SequenceContextType.MAIN)
				facade.sendNotification(AdsNotificationTypes.AD_CLICK,{timeSlot:'overlay'}); // no mid roll so the default should be overlay
		}
		/**
		 * Send stats
		 * @param event
		 */		
		private function sendStat(event:Event = null):void
		{
			var sequenceProxy:SequenceProxy = facade.retrieveProxy(SequenceProxy.NAME) as SequenceProxy;
			if(sequenceProxy.sequenceContext == SequenceContextType.PRE)
				facade.sendNotification(AdsNotificationTypes.AD_START,{timeSlot:'preroll'});
			if(sequenceProxy.sequenceContext == SequenceContextType.POST)
				facade.sendNotification(AdsNotificationTypes.AD_START,{timeSlot:'postroll'});
			if(sequenceProxy.sequenceContext == SequenceContextType.MAIN)
				facade.sendNotification(AdsNotificationTypes.AD_START,{timeSlot:'overlay'});
			
		}
		/**
		 * play the entry 
		 * @param event
		 */		
		private function onResume(event:Event = null):void
		{
			facade.sendNotification("doPlay");
		}
		/**
		 * play the entry 
		 * @param event
		 */		
		private function onPlay(event:Event = null):void
		{
			facade.sendNotification("sequenceItemPlayEnd");
		}

		private function onEnebledChanged(event:Event = null):void
		{
			var shouldEnable:Boolean = _adaptvPlayer.shouldEneble;
			facade.sendNotification("enableGui", {guiEnabled: shouldEnable, enableType: "full"}); 
		}

		public function setEntryData(id:String, title:String, url:String, duration:int, description:String, entry:Object = null):void 
		{
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
				if (entry["categories"])
					categories = entry["categories"];
				keywords = _entryTitle.toString().split(" ") + "," + _entryDescription.toString().split(" ");
			}
			
			
			var o:Object = {
				// consult http://help.adap.tv/index.php/Integration_API_Reference
				// for more detailed information.
				// -- Required parameters --
				// parameters about the player clip view
				key: key,     // Your publisher key provided by Adap.tv.
				// parameters about the player clip
				id: _entryId,     // The unique identifier of the clip (limit 64 chars)
				title: _entryTitle,    // The title of the clip
				duration: _entryDuration,    // The duration of clip in _seconds_, if applicable
				url: _entryUrl , // A valid HTTP or RMTP URL for the clip (often .flv) file.
				description: _entryDescription,     // description of clip
				keywords: keywords,     // A comma-delimited list of tags/keywords
				categories: categories,  // A comma-delimited list of top level categories    
				// -- Optional parameters --
				zid: zone,     // Name of the zone for this view. Optional.
				companionId: companionId,     // The id attribute of the div to contain the companion ad
				pageUrlOv: pageUrlOv     // page URL override
			};
			
			_adaptvPlayer.buildConfig(o);
		}
	}
}