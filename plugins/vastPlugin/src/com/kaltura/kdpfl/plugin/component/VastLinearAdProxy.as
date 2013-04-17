package com.kaltura.kdpfl.plugin.component {

	
	import com.kaltura.kdpfl.ApplicationFacade;
	import com.kaltura.kdpfl.model.MediaProxy;
	import com.kaltura.kdpfl.model.SequenceProxy;
	import com.kaltura.kdpfl.model.type.SequenceContextType;
	import com.kaltura.osmf.proxy.KSwitchingProxyElement;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.utils.Timer;
	
	import org.osmf.elements.ProxyElement;
	import org.osmf.elements.beaconClasses.Beacon;
	import org.osmf.events.LoaderEvent;
	import org.osmf.events.MediaErrorEvent;
	import org.osmf.events.MediaPlayerCapabilityChangeEvent;
	import org.osmf.events.MetadataEvent;
	import org.osmf.events.TimeEvent;
	import org.osmf.media.MediaElement;
	import org.osmf.media.MediaFactory;
	import org.osmf.media.MediaPlayer;
	import org.osmf.media.URLResource;
	import org.osmf.traits.LoadState;
	import org.osmf.utils.HTTPLoader;
	import org.osmf.vast.loader.VASTLoadTrait;
	import org.osmf.vast.loader.VASTLoader;
	import org.osmf.vast.media.VAST2TrackingProxyElement;
	import org.osmf.vast.media.VASTMediaGenerator;
	import org.osmf.vast.media.VASTTrackingProxyElement;
	import org.osmf.vast.model.VAST2Translator;
	import org.osmf.vast.model.VAST3Translator;
	import org.osmf.vast.model.VASTDataObject;
	import org.osmf.vast.model.VASTUrl;
	import org.osmf.vpaid.elements.VPAIDElement;
	import org.osmf.vpaid.metadata.VPAIDMetadata;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class VastLinearAdProxy extends Proxy implements IEventDispatcher
	{
		
		/**
		 * Hide the timestamp 
		 **/
		public var omitTimestamp:Boolean;
		
		public static const SIGNAL_END:String = "signal_end";
		
		private static const MAX_NUM_REDIRECTS:Number = 5;
		
		private var _dispatcher:EventDispatcher;
		private var _mediaFactory : MediaFactory;
		private var _prerollUrl : String;
		private var _postrollUrl : String;
		private var _playingAd : MediaElement;
		private var _initVPAIDSize:Boolean = false;
		
		/**
		 * Uniform click-thru url for VAST linear ad
		 * */
		private var _playingAdClickThru : String; 
		
		/**
		 * Uniform tracking event urls for ad click-thru
		 * */
		private var _playingAdClickTrackings : Array; 
		private var _vastElements : Vector.<MediaElement>; 
		private var _vastMediaGenerator:VASTMediaGenerator;
		private var companionAds : VastCompanionAdProxy;
		
		private var _loadTimeout : Number;
		private var _loadTimer : Timer;
		
		private var _vastDocument : VASTDataObject;
		
		private var _vastLoader : VASTLoader = new VASTLoader(MAX_NUM_REDIRECTS);
		
		private var _currentSequenceContext : String;
		/**
		 * for vast3 ad pods: the current translator index to create elements from 
		 */		
		private var _curTranslatorIndex:int;
		/**
		 * indicates we are playing sequenced ads, not a standalone ad 
		 */		
		public var sequencedAds:Boolean;
		
		private var _initialVpaidDuration:int;

		/**
		 * Constructor.
		 * @param prerollUrl
		 * @param postrollUrl
		 * @param flashCompanions
		 * @param htmlCompanions
		 * @param timeout
		 *
		 */
		public function VastLinearAdProxy(prerollUrl:String, postrollUrl:String, flashCompanions:String, htmlCompanions:String, timeout:Number=0) {
			super();
			_dispatcher = new EventDispatcher();
			_prerollUrl = prerollUrl;
			_postrollUrl = postrollUrl;
			if(timeout && timeout >= 4)
			{
				_loadTimeout = timeout;
			}else{
				_loadTimeout = 4;
			}
			companionAds = new VastCompanionAdProxy(flashCompanions, htmlCompanions);
		}


		/**
		 *Initiate the load process of the ad - determine whether loading pre-roll or post-roll ad.
		 * @param context - signifies the context of the ad: "pre" for pre-roll and "post" for post-roll
		 *
		 */
		public function loadAd(loadUrl:String , sequenceContext : String):void {
			_playingAd = null;
			_currentSequenceContext = sequenceContext;
			
			if(loadUrl)	
			{
				if(!omitTimestamp)
				{
					if(loadUrl.indexOf("?")>-1)
						loadUrl += "&timestamp=" + new Date().time;
					else
						loadUrl += "?timestamp=" + new Date().time;
				}
				this.addEventListener( "linearAdReady" , onLinearAdReady);
				createLinearAd(loadUrl);
			}
			else
			{
				sendNotification( "VASTAdFailed", "load URL is empty")
			}
		}
		
		public function resizeAd(width:Number,height:Number,mode:String):void
		{
			var vpaidMetadata:VPAIDMetadata = getVPAIDMetadata();
			if (vpaidMetadata)
			{
				var dataObj:Object = new Object();
				dataObj.width = width;
				dataObj.height = height;
				dataObj.viewMode = mode ? mode: "normal";
				vpaidMetadata.addValue("resizeAd",dataObj);
				
			}
		}


		/**
		 * Function initiates the load of ads
		 *
		 */
		public function createLinearAd( url : String):void {
			var prerollVastResource:URLResource = new URLResource(url);
			
			var vastLoadTrait:VASTLoadTrait = new VASTLoadTrait(_vastLoader, prerollVastResource);
			_vastLoader.addEventListener(LoaderEvent.LOAD_STATE_CHANGE, onVastAdStateChange);
			companionAds.cleanMaps();
			
			_loadTimer = new Timer(_loadTimeout*1000, 1);
			_loadTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onLoadTimeout);
			//_loadTimer.start();
			_vastLoader.load(vastLoadTrait);
		}


		/**
		 * Function handles the situation where a VAST ad has failed to load within the desired time frame 
		 * @param e
		 * 
		 */		
		private function onLoadTimeout (e: TimerEvent) : void
		{
			if (_vastLoader.hasEventListener(LoaderEvent.LOAD_STATE_CHANGE) )
			{
				_vastLoader.removeEventListener(LoaderEvent.LOAD_STATE_CHANGE, onVastAdStateChange );
			}
			_loadTimer.stop();
			_loadTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,onLoadTimeout);
			signalEnd();
		}
		/**
		 * Listener function for chnage in the vast load state
		 * @param e
		 *
		 */
		private function onVastAdStateChange(e:LoaderEvent):void {
			if (e.newState == LoadState.READY) {
				//Stop the timeout timer, as the ad has already loaded.
				_loadTimer.stop();
				_loadTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onLoadTimeout );
				_vastDocument = (e.loadTrait as VASTLoadTrait).vastDocument;
				_vastMediaGenerator = new VASTMediaGenerator(null, _mediaFactory);
				_curTranslatorIndex = 0;
				sequencedAds = false;
				if (_vastDocument.vastVersion == VASTDataObject.VERSION_3_0)
					setStartingTranslatorIndex();
				
				createMediaElements();
			//In case there was an error parsing or loading the VAST xml
			} else if (e.newState == LoadState.LOAD_ERROR) {
				//Stop the timeout timer
				_loadTimer.stop();
				_loadTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onLoadTimeout );
				
				
				trace("error loading ad");
				signalEnd();
			}
		}
		
		/**
		 * generate media elements and sets the _playingAd 
		 * 
		 */		
		private function createMediaElements():void
		{
			var playerSize:Rectangle= new Rectangle(0,0,(facade as ApplicationFacade).app.width,(facade as ApplicationFacade).app.height);
			var vastObj:VASTDataObject = getCurrentVastObject();
			if (vastObj)
			{
				companionAds.createFlashCompanionsMap(vastObj);
				companionAds.createHtmlCompanionMap(vastObj);
				_vastElements = _vastMediaGenerator.createMediaElements(_vastDocument,"",playerSize, _curTranslatorIndex);
				
				for each(var mediaElement : MediaElement in _vastElements)
				{
					if (mediaElement is ProxyElement)
					{
						_playingAd = mediaElement;
					}
					
				}
				
				if (_playingAd) {
					dispatchEvent( new Event("linearAdReady",true,false) )
				}
				else
				{
					//In case the ad has no playable media element.
					trace ("unable to play ad");
					signalEnd();
				}
			}
			else
				signalEnd();
		
		}
		
		/**
		 * 
		 * 
		 */
		private function onLinearAdReady (e : Event) : void
		{
			parseVideoClicks (_vastDocument);
			playAd();
			companionAds.displayFlashCompanions(facade);
			companionAds.displayHtmlCompanions(facade);
		}
		/**
		 * Function which determines how to play the linear ad that was loaded
		 * 
		 */		
		private function playAd () : void
		{
			var playerMediator:Object = facade.retrieveMediator("kMediaPlayerMediator");
			if (_currentSequenceContext == SequenceContextType.MID)
			{
				playAdAsMidroll(playerMediator) ;
			}
			else
			{
				playAdAsPrePostRoll(playerMediator);
			}
			
		}
		
		/**
		 * Change the media playing in the media player to the vast media and start playing. 
		 * @param playerMediator - mediator of the MediaPlayer instance
		 * 
		 */		
		private function playAdAsPrePostRoll( playerMediator : Object ):void 
		{
			playerMediator["player"].addEventListener(MediaErrorEvent.MEDIA_ERROR, onVastAdError);
			playerMediator["cleanMedia"]();
			
			
				
			//_playingAd.addEventListener("traitAdd", onAdPlayable);
			
			if (_playingAdClickThru) {
				playerMediator["kMediaPlayer"].addEventListener(MouseEvent.CLICK, onAdClick);
			}
			//playerMediator.player.addEventListener(TimeEvent.COMPLETE, onAdComplete);
			//playerMediator["playContent"]();
			//TODO track stats
			sendNotification("adStart",	 {timeSlot: getContextString(_currentSequenceContext)});
			(playerMediator["player"] as MediaPlayer).addEventListener( MediaPlayerCapabilityChangeEvent.CAN_PLAY_CHANGE , onAdPlayable );
			(playerMediator["player"] as MediaPlayer).addEventListener(TimeEvent.DURATION_CHANGE, onAdDurationReceived,false, int.MIN_VALUE);
			playerMediator["player"]["media"] = _playingAd;
			

			var _this:Object = this;
			var vpaidMetadata:VPAIDMetadata = getVPAIDMetadata();
			if (vpaidMetadata)
			{
				vpaidMetadata.addEventListener(MetadataEvent.VALUE_ADD, function(event:MetadataEvent):void
				{
					trace (event.key)
					if (event.key == "adUserClose" ||event.key == "adStopped" || event.key == "adPaused" )
					{
						(playerMediator["player"] as MediaPlayer).removeEventListener(TimeEvent.DURATION_CHANGE, onAdDurationReceived );
						removeClickThrough();
						sendNotification("enableGui", {guiEnabled : true, enableType : "full"});
					
						sendNotification("sequenceItemPlayEnd");
					}
					if (!_initVPAIDSize &&(event.key.indexOf("AdLoaded") == 0 ||
						event.key.indexOf("adCreativeView") == 0 || 
						event.key.indexOf("AdPlaying")== 0 || 
						event.key.indexOf("AdVideoStart") == 0))
					{
						_initVPAIDSize = true;
						
						//_this.resizeAd(-1,-1,"normal");
					}
				});
			}	
			
		}
		
		/**
		 * Switch to the secondary media element.
		 * @param playerMediator - mediator of the MediaPlayer instance
		 * 
		 */		
		private function playAdAsMidroll (playerMediator : Object) : void
		{
			var mediaProxy : MediaProxy = facade.retrieveProxy( MediaProxy.NAME ) as MediaProxy;
			(mediaProxy.vo.media as KSwitchingProxyElement).secondaryMediaElement = _playingAd;
			(playerMediator["player"] as MediaPlayer).addEventListener(TimeEvent.DURATION_CHANGE, onAdDurationReceived,false, int.MIN_VALUE);

			if (_playingAdClickThru) {
				playerMediator["kMediaPlayer"].addEventListener(MouseEvent.CLICK, onAdClick);
			}
			sendNotification("adStart",
				{timeSlot: getContextString(_currentSequenceContext)});
			
			(playerMediator["player"] as MediaPlayer).addEventListener( MediaPlayerCapabilityChangeEvent.CAN_PLAY_CHANGE , onAdPlayable );
			
			//if we're playing ad pods, don't switch elements again
			if (sequencedAds)
			{
				(mediaProxy.vo.media as KSwitchingProxyElement).proxiedElement = _playingAd;
			}
			else
			{
				(mediaProxy.vo.media as KSwitchingProxyElement).switchElements();
			}
		}
		
		//Once the ad mediaElement has a time trait, it is safe to show the notice message.
		private function onAdPlayable (e:MediaPlayerCapabilityChangeEvent) : void
		{
			var playerMediator : Object = facade.retrieveMediator("kMediaPlayerMediator");
			
			if (e.enabled)
			{
				playerMediator["playContent"]();
				sendNotification("vastStartedPlaying");
				(playerMediator["player"] as MediaPlayer).removeEventListener( MediaPlayerCapabilityChangeEvent.CAN_PLAY_CHANGE , onAdPlayable );
			}
		}
		
		private function onAdDurationReceived (e : TimeEvent) : void
		{
			if (!isNaN(e.time) && e.time > 0)
			{
				var sequenceProxy : SequenceProxy = facade.retrieveProxy(SequenceProxy.NAME) as SequenceProxy;
				sequenceProxy.vo.timeRemaining = Math.round(e.time);
				sequenceProxy.vo.isAdLoaded = true;
				//check for skipoffset
				var curVast:VASTDataObject = getCurrentVastObject();
				if (curVast && curVast.vastVersion == VASTDataObject.VERSION_2_0) 
				{
					var skipOffsetInSecs:int;
					var skipOffset:String = curVast["skipOffset"];
					if (skipOffset)
					{
						//parse HH:MM:SS skipoffset format
						if (skipOffset.indexOf(":")!=-1)
						{
							var timesArr:Array = skipOffset.split(":");
							if (timesArr.length!=3)
								trace ("VastLinearAdProxy:: ignore skipoffset - invalid format");
							else {
								var multi:int = 1;
								for (var i:int = timesArr.length - 1; i>=0; i--)
								{
									skipOffsetInSecs += parseInt(timesArr[i]) * multi;
									multi *= 60;
								}
							}
							
						}	
						else if (skipOffset.indexOf("%")!=-1) //parse n% skipoffset format
						{
							var percent:Number = parseInt(skipOffset.substring(0, skipOffset.indexOf("%"))) / 100;
							skipOffsetInSecs = sequenceProxy.vo.timeRemaining * percent;
						}
						else
							trace ("VastLinearAdProxy:: ignore skipoffset - unknown format");							
					}	
					sequenceProxy.vo.skipOffsetRemaining = sequenceProxy.vo.skipOffset = skipOffsetInSecs;
					
					
				}
				
				(e.target as MediaPlayer).removeEventListener(TimeEvent.DURATION_CHANGE, onAdDurationReceived );
				//vpaid
				if ((((_playingAd as VASTTrackingProxyElement).proxiedElement as ProxyElement).proxiedElement is VPAIDElement))
				{
					_initialVpaidDuration = e.time;
					(e.target as MediaPlayer).addEventListener(TimeEvent.DURATION_CHANGE, onVpaidDurationReceived );
				}
				
			}
		}
		
		private function onVpaidDurationReceived(e: TimeEvent) : void
		{
			
			if (!isNaN(e.time) && e.time > 0)
			{
				var sequenceProxy : SequenceProxy = facade.retrieveProxy(SequenceProxy.NAME) as SequenceProxy;
				sequenceProxy.vo.timeRemaining = Math.round(e.time);
				//calculate remaining skip offset by substracting elapsed ad time from the skip offset
				if (sequenceProxy.vo.skipOffset)
				{
					sequenceProxy.vo.skipOffsetRemaining = sequenceProxy.vo.skipOffset - (_initialVpaidDuration - sequenceProxy.vo.timeRemaining);
					if (sequenceProxy.vo.skipOffsetRemaining<=0)
						sequenceProxy.vo.skipOffsetRemaining = sequenceProxy.vo.skipOffset = 0;
				}
				
				if (e.time <= 1)
					(e.target as MediaPlayer).removeEventListener(TimeEvent.DURATION_CHANGE, onVpaidDurationReceived );
			}
			
		}
		

		/**
		 * selects the context name to be dispatched for statistics plugin.
		 * @param str	context const (SequenceContextType)
		 * @return 		context string
		 */
		private function getContextString(str:String):String {
			var res:String;
			switch (str) {
				case "pre":
					res = "preroll";
					break;
				case "mid":
					res = "midroll";
					break;
				case "post":
					res = "postroll";
					break;
			}
			return res;
		}


		private function onAdClick(e:MouseEvent):void {
			var urlReq:URLRequest = new URLRequest(_playingAdClickThru);
			navigateToURL(urlReq);
			for (var i:int=0; i<_playingAdClickTrackings.length; i++)
			{
				var beacon : Beacon = new Beacon(_playingAdClickTrackings[i], new HTTPLoader() );
				beacon.ping();
			}
			//var clickTrackingUrl : String = ((e.target as KMediaPlayer).player.media as VASTTrackingProxyElement).
			//TODO track stats
			var sequenceProxy:Proxy = facade.retrieveProxy("sequenceProxy") as Proxy;
			sendNotification("adClick",
							 {timeSlot: getContextString(sequenceProxy["sequenceContext"])});
		}



		/**
		 * Listener for and error in the playing process of the ad.
		 * @param e
		 *
		 */
		private function onVastAdError(e:MediaErrorEvent):void {
			trace("A problem occured when playing this ad : " + e.error);
			var sequenceProxy : SequenceProxy = facade.retrieveProxy( SequenceProxy.NAME ) as SequenceProxy;
			if (sequenceProxy.vo.isInSequence)
				signalEnd();
		}


		/**
		 * Function parses the link of the video clickthru from the Vast document
		 * @param vastDoc
		 *
		 */
		private function parseVideoClicks(vastDoc:VASTDataObject):void {
			_playingAdClickThru = null;
			_playingAdClickTrackings = null;
			if (vastDoc.vastVersion == 3)
			{
				var vastObj:VASTDataObject = getCurrentVastObject();
				if (vastObj)
					parseVideoClicks(vastObj);
					
			}
			else if (vastDoc.vastVersion == 2) 
			{
				if (vastDoc["clickThruUrl"]) {
					_playingAdClickThru = vastDoc["clickThruUrl"];
					_playingAdClickTrackings = new Array();
					var ln:int = vastDoc["trkClickThruEvent"].length;
					for (var j:int = 0; j<ln; j++) {
						if (vastDoc["trkClickThruEvent"][j])
						{
							for (var i:int=0; i<(vastDoc["trkClickThruEvent"][j]["url"] as XMLList).length(); i++)
							{
								_playingAdClickTrackings.push(vastDoc["trkClickThruEvent"][j]["url"][i].toString());
							}
						}
					}
				}
			}
			else if (vastDoc.vastVersion == 1)
			{
				if (vastDoc["ads"].length > 0) {
					if (vastDoc["ads"][0].inlineAd) {
						if (vastDoc["ads"][0].inlineAd.video) {
							if (vastDoc["ads"][0].inlineAd.video.videoClick) {
								_playingAdClickThru = vastDoc["ads"][0].inlineAd.video.videoClick.clickThrough ? vastDoc["ads"][0].inlineAd.video.videoClick.clickThrough.url : null;
								_playingAdClickTrackings = vastDoc["ads"][0].inlineAd.video.videoClick.clickTrackings ? constructClickTrackings (vastDoc["ads"][0].inlineAd.video.videoClick.clickTrackings) : null;
							}
						}
					}
				}
			}
		}
		
		private function getVPAIDMetadata():VPAIDMetadata
		{
			try
			{
				if (_playingAd as VAST2TrackingProxyElement && 
					ProxyElement(_playingAd as VAST2TrackingProxyElement).proxiedElement)
				{
					var vpaidElement:VPAIDElement =ProxyElement((_playingAd as VAST2TrackingProxyElement).proxiedElement).proxiedElement as VPAIDElement;
					var vpaidMetadata:VPAIDMetadata = vpaidElement.getMetadata(vpaidElement.metadataNamespaceURLs[0]) as VPAIDMetadata;
					return vpaidMetadata;
				}
			}
			catch(ex:Error)
			{
				trace (ex);
			}
			return null;
		}
		
		private function constructClickTrackings ( vast1ClickTrackings : Vector.<VASTUrl> ) : Array
		{
			var clickTrackings : Array = new Array();
			for (var i:int = 0; i<vast1ClickTrackings.length; i++)
			{
				clickTrackings.push(vast1ClickTrackings[i]["url"]);
			}
			return clickTrackings;
		}

		//Public functions
		//todo: check if skip ad also does this function

		public function removeClickThrough():void {
			var playerMediator:Object = facade.retrieveMediator("kMediaPlayerMediator");
			if (playerMediator["kMediaPlayer"].hasEventListener(MouseEvent.CLICK)) {
				playerMediator["kMediaPlayer"].removeEventListener(MouseEvent.CLICK, onAdClick);
				_playingAdClickThru = null;
			}
		}


		/**
		 * This function dispatches a notification signifying that the vast component has finished playing. 
		 * Used when the vast load trait has encountered a problem and the VAST was never loaded
		 */		
		public function signalEnd () : void
		{
			if (hasPendingAds())
				playNextPendingAd();
			else
			{
				this.removeEventListener( "linearAdReady" , onLinearAdReady);
				removeClickThrough();
				sendNotification("enableGui", {guiEnabled : true, enableType : "full"});
				dispatchEvent(new Event(VastLinearAdProxy.SIGNAL_END));
				sendNotification("sequenceItemPlayEnd");
			}
		}


		/**
		 * Function removes the vast clickthrough, hides the companion ads and enables the GUI.
		 * Used when the VAST video ads (linear ads) have finished playing.
		 */		
		public function resetVast () : void
		{
			removeClickThrough();
			companionAds.hideFlashCompanionAds(facade);
			
		}
		
		public function hasPendingAds() : Boolean
		{
			//if we are vast3 and didn't generate all mediaElements yet we might have pending ads
			return (_vastDocument && 
				(_vastDocument.vastVersion == VASTDataObject.VERSION_3_0) &&
				(_vastDocument is VAST3Translator) && 
				(_vastDocument as VAST3Translator).vastObjects && 
				((_vastDocument as VAST3Translator).vastObjects.length - 1)>_curTranslatorIndex &&
				sequencedAds);
		}
		
		/**
		 * Added as part of vast3 support: in case we have a few ads in sequence will play the next ad from the same vast schema 
		 * 
		 */		
		public function playNextPendingAd() : void
		{
			if (_vastDocument.vastVersion == VASTDataObject.VERSION_3_0)
			{
				_curTranslatorIndex++;
				createMediaElements();
			}
			
		}
		
		/**
		 * vast3 object holds a few vastobjects. returns the current one. 
		 * if vastDocument is not vast3, return it.
		 * 
		 */		
		private function getCurrentVastObject():VASTDataObject
		{
			if ((_vastDocument.vastVersion == VASTDataObject.VERSION_3_0) && (_vastDocument is VAST3Translator))
			{
				var vastObjs:Array = (_vastDocument as VAST3Translator).vastObjects;
				if (vastObjs && _curTranslatorIndex >= 0 && _curTranslatorIndex < vastObjs.length)
					return vastObjs[_curTranslatorIndex];
				else
					return null;
				
			}
			return _vastDocument;
		}
		
		/**
		 * for vast3 ad pods: go over all translator, if there are sequenced ads, return their starting index,
		 * otherwise select random ad 
		 * 
		 */		
		private function setStartingTranslatorIndex():void
		{
			if (_vastDocument is VAST3Translator)
			{
				var vastObjs:Array = (_vastDocument as VAST3Translator).vastObjects;
				sequencedAds = false;
				
				if (vastObjs.length == 1)
					return;
				
				for (var i:int = 0; i<vastObjs.length; i++)
				{
					//ads are sorted by sequence property. If we encountered an ad with "sequence" value, start playing all ads in sequence
					if ((vastObjs[i] as VAST2Translator).sequence)
					{
						sequencedAds = true;
						_curTranslatorIndex = i;
						return;
					}
				}
				
				//if we got here we don't have sequenced ads, select random ad to play
				_curTranslatorIndex = Math.random() * (vastObjs.length);
			}
			
		}
		
		// ==============================================
		// IEventDispatcher methods
		// ==============================================
		public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
			_dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void
		{
			_dispatcher.removeEventListener(type, listener, useCapture);
		}
		
		public function dispatchEvent(event:Event):Boolean
		{
			return _dispatcher.dispatchEvent(event);
		}
		
		public function hasEventListener(type:String):Boolean
		{
			return _dispatcher.hasEventListener(type);
		}
		
		public function willTrigger(type:String):Boolean
		{
			return _dispatcher.willTrigger(type);
		}
		// ==============================================


		/**
		 *Getter for the ad playing in the player
		 * @return
		 *
		 */
		public function get playingAd():MediaElement {
			return _playingAd;
		}
		
		//When setting both the pre-roll and the post-roll url, it is important to add the time stamp parameter to avoid caching of the url.
		
		public function set prerollUrl(value:String):void
		{
			var timestamp : Number = new Date().time;
			_prerollUrl = value;
			
		}

		public function set postrollUrl(value:String):void
		{
			var timestamp : Number = new Date().time;
			_postrollUrl = value;
			
		}


		
	}
}