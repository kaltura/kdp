package com.kaltura.kdpfl.view
{
	import com.kaltura.kdpfl.model.ConfigProxy;
	import com.kaltura.kdpfl.model.MediaProxy;
	import com.kaltura.kdpfl.model.SequenceProxy;
	import com.kaltura.kdpfl.model.type.AdsNotificationTypes;
	import com.kaltura.kdpfl.model.type.NotificationType;
	import com.kaltura.kdpfl.model.type.SequenceContextType;
	import com.kaltura.types.KalturaAdType;
	import com.kaltura.vo.KalturaAdCuePoint;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class ComscoreMediator extends Mediator
	{
		public static const NAME : String = "comscoreMediator";
		
		public static const VIDEO_TYPE : String = "1";
		public static const PREROLL_AD_CONTENT_TYPE : String = "090000";
		public static const POSTROLL_AD_CONTENT_TYPE : String = "100000";
		public static const MIDROLL_AD_CONTENT_TYPE : String = "110000";
		public static const IN_BANNER_VIDEO_AD : String = "120000";
		
		protected var _playerPlayedFired : Boolean = false;
		protected var cParams : Object = new Object();
		protected var _flashvars : Object;
		protected var view:ComscorePluginCode;
		
		//total number of segments, determined by number of ad cue points
		private var _numOfSegments:int = 1;
		//current playing segment
		private var _currentSegment:int = 1;
		//array containing all ad cue points start time, to calculate current segment
		private var _startTimeArray:Array = new Array();
		
		private var _shoudSendBeacon:Boolean = false;
		private var _sendOnSequnceEnd:Boolean = false;
		
		public function ComscoreMediator(mediatorName:String=null, viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			view = viewComponent as ComscorePluginCode;
		}
		
		override public function listNotificationInterests():Array
		{
			var arr : Array = [
				NotificationType.PLAYER_PLAYED, 
				AdsNotificationTypes.AD_START,
				NotificationType.ENTRY_READY, 
				NotificationType.LAYOUT_READY,
				NotificationType.CUE_POINTS_RECEIVED,
				NotificationType.AD_OPPORTUNITY,
				NotificationType.PLAYER_UPDATE_PLAYHEAD,
				NotificationType.MID_SEQUENCE_COMPLETE]
			return arr;
		}
		
		override public function handleNotification(notification:INotification):void
		{
			var sequenceProxy : SequenceProxy = (facade.retrieveProxy(SequenceProxy.NAME) as SequenceProxy);
			switch (notification.getName() )
			{
				case NotificationType.LAYOUT_READY:
					_flashvars = (facade.retrieveProxy(ConfigProxy.NAME) as ConfigProxy).vo.flashvars;
					break;
				
				case NotificationType.ENTRY_READY:
					createCParams();
					_playerPlayedFired = false;
					break;
				
				case NotificationType.PLAYER_PLAYED:
					if (!_playerPlayedFired)
					{		
						if (!sequenceProxy.vo.isInSequence) 
						{
							cParams["c5"] = view.c5;
							comscoreBeacon();
							_playerPlayedFired = true;
						}
					}
					break;
				
				case AdsNotificationTypes.AD_START:
					switch (sequenceProxy.sequenceContext)
					{
						case SequenceContextType.PRE:
							cParams["c5"] = PREROLL_AD_CONTENT_TYPE;
							break;
						case SequenceContextType.POST:
							cParams["c5"] = POSTROLL_AD_CONTENT_TYPE;
							break;
						case SequenceContextType.MID:
							cParams["c5"] = MIDROLL_AD_CONTENT_TYPE ;
							_sendOnSequnceEnd = true;
							break;
					}
					comscoreBeacon();
					_shoudSendBeacon = false;
					break;
				
				case NotificationType.CUE_POINTS_RECEIVED:
					var cuePointsMap:Object = notification.getBody();
					_startTimeArray = new Array();
					var entryMSDuration:int = (facade.retrieveProxy(MediaProxy.NAME) as MediaProxy).vo.entry.msDuration;
					for (var inTime:String in cuePointsMap) {
						if (parseInt(inTime)!=0 && parseInt(inTime)!=entryMSDuration) {
							var cpArray:Array = cuePointsMap[inTime];
							//whether this start time was already saved to _startTimeArray
							var startTimeSaved:Boolean = false;
							for (var i:int = 0; i<cpArray.length; i++) {
								if (cpArray[i] is KalturaAdCuePoint) {
									var curCp:KalturaAdCuePoint = cpArray[i] as KalturaAdCuePoint;
									if (curCp.adType == KalturaAdType.VIDEO && !startTimeSaved) {
										_startTimeArray.push(inTime);
										startTimeSaved = true;
										_numOfSegments++;	
									}
								}
							}
							
						}
					}
					_startTimeArray.sort(Array.NUMERIC);
					break;
				
				case NotificationType.AD_OPPORTUNITY:
					var msDuration:int = (facade.retrieveProxy(MediaProxy.NAME) as MediaProxy).vo.entry.msDuration;
					var cp:KalturaAdCuePoint = notification.getBody().cuePoint as KalturaAdCuePoint;
					if (cp.startTime!=0 && cp.startTime!=msDuration && cp.adType == KalturaAdType.VIDEO) {
						for (var j:int =0 ; j<_startTimeArray.length; j++) {
							if (_startTimeArray[j]==cp.startTime) {
								//add 1 since array is zero based and segment is 1 based, 
								//add another one because we passed the cue point
								_currentSegment = j + 2; 
								break;
							}
						}
						
						_shoudSendBeacon = true;
					}				
					break;
				
				case NotificationType.PLAYER_UPDATE_PLAYHEAD:
					if (_shoudSendBeacon) {
						cParams["c5"] = view.c5;
						comscoreBeacon();
						_shoudSendBeacon = false;
					}
					break;
				
				case NotificationType.MID_SEQUENCE_COMPLETE:
					if (_sendOnSequnceEnd) {
						cParams["c5"] = view.c5;
						comscoreBeacon();
						_sendOnSequnceEnd = false;
					}
					break;
			}
		}
		
		protected function comscoreBeacon () : void
		{
			var loadUrl : String;
			var referrer : String = "";
			var page : String = "";
			var title : String = "";
			
			try {
				if(_flashvars.referer)
				{
					referrer = ExternalInterface.call( "function() { return document.referrer; }").toString();
				}
			} catch (e : Error) 
			{
				referrer = _flashvars.referer;
			}
			try {
				if(_flashvars.referer)
				{
					page = ExternalInterface.call( "function () { return document.location.href; } ").toString();
				}
			} catch (e : Error) 
			{
				page = _flashvars.referer;
			}
			try {
				if(_flashvars.referer)
				{
					title = ExternalInterface.call( "function () { return document.title; } ").toString();
				}
			} catch (e : Error) 
			{
				title = _flashvars.referer;
			}
			
			
			if (page.indexOf("https") != -1 ) {
				loadUrl = "https://sb.";	
			}  else {
				loadUrl = "http://b."
			}
			loadUrl += "scorecardresearch.com/p?";
			
			createCParams();
			for (var cParam : String  in cParams) {
				loadUrl += cParam+"="+cParams[cParam]+"&";
			}
			
			if (page && page != "") {
				loadUrl += "c7=" + page +"&";
			}
			
			if (title && title != "") {
				loadUrl += "c8=" + title +"&";
			}
			
			if (referrer && referrer != "") {
				loadUrl += "c9=" + referrer +"&";
			}
			
			loadUrl += "c10=" + _currentSegment + "-" + _numOfSegments + "&";
			loadUrl += "rn=" + Math.random().toString() + "&";
			loadUrl +="cv=" + view.comscoreVersion;
			var loader : URLLoader = new URLLoader();
			var urlRequest : URLRequest = new URLRequest(loadUrl);
			loader.addEventListener(Event.COMPLETE, onComscoreBeaconSuccess);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onComscoreBeaconFailed);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onComscoreBeaconFailed);
			loader.load(urlRequest);
		}
		
		protected function onComscoreBeaconSuccess (e : Event) : void
		{
		}
		
		protected function onComscoreBeaconFailed (e : Event) : void
		{
		}
		
		protected function createCParams() : void
		{
			cParams["c1"] = view.c1 ? view.c1 : VIDEO_TYPE;
			cParams["c2"] = view.c2;
			cParams["c3"] = view.c3;
			cParams["c4"] = view.c4;
			cParams["c6"] = view.c6;
		}
	}
}