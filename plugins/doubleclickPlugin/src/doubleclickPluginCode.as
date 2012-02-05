package
{
	import com.google.ads.instream.api.Ad;
	import com.google.ads.instream.api.AdErrorEvent;
	import com.google.ads.instream.api.AdEvent;
	import com.google.ads.instream.api.AdLoadedEvent;
	import com.google.ads.instream.api.AdSizeChangedEvent;
	import com.google.ads.instream.api.AdTypes;
	import com.google.ads.instream.api.AdsLoadedEvent;
	import com.google.ads.instream.api.AdsLoader;
	import com.google.ads.instream.api.AdsManager;
	import com.google.ads.instream.api.AdsManagerTypes;
	import com.google.ads.instream.api.AdsRequest;
	import com.google.ads.instream.api.AdsRequestType;
	import com.google.ads.instream.api.CompanionAd;
	import com.google.ads.instream.api.CompanionAdEnvironments;
	import com.google.ads.instream.api.FlashAd;
	import com.google.ads.instream.api.FlashAdCustomEvent;
	import com.google.ads.instream.api.FlashAdsManager;
	import com.google.ads.instream.api.FlashAsset;
	import com.google.ads.instream.api.HtmlCompanionAd;
	import com.google.ads.instream.api.VastVideoAd;
	import com.google.ads.instream.api.VideoAd;
	import com.google.ads.instream.api.VideoAdsManager;
	import com.kaltura.kdpfl.model.type.AdsNotificationTypes;
	import com.kaltura.kdpfl.model.type.NotificationType;
	import com.kaltura.kdpfl.plugin.IMidrollSequencePlugin;
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.plugin.IPluginFactory;
	import com.kaltura.kdpfl.plugin.ISequencePlugin;
	import com.kaltura.kdpfl.plugin.component.DoubleclickMediator;
	import com.kaltura.kdpfl.view.media.KMediaPlayer;
	import com.yahoo.astra.fl.controls.AbstractButtonRow;
	
	import fl.core.UIComponent;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.geom.Point;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetStream;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.Timer;
	
	import org.puremvc.as3.interfaces.IFacade;
	
	public dynamic class doubleclickPluginCode extends UIComponent implements IPlugin, ISequencePlugin
	{
		
		private static const WRITE_INTO_COMPANION_DIV:String = "writeIntoCompanionDiv";
		public var adSlotWidth:Number;
		public var adSlotHeight:Number;
		public var adTagUrl : String;
		public var adType : String = AdsRequestType.VIDEO;
		public var container:DisplayObjectContainer;
		public var postSequence:int;
		public var preSequence:int;
		public var midSequence:int; 
		private var overlayAds:Array;
		private var _channels:Array;
		private var _useGUT:Boolean;
		private var _flashVars:Object;
		private var _adNetStream:NetStream;
		private var _adTimer:Timer	= new Timer(1000);
		//used to adjust netstream volumes
		private var _sndTransform:SoundTransform	= new SoundTransform();
		//list of active netstreams
		private var _netStreams:Array;
		public var trackCuePoints:String="true";
		public var cmsId:String;
		public function set channels(val:String):void{
			_channels			= val.split(","); 
		}
		public function get channels():String{
			return String(_channels);
		}
		public var contentId : String;
		public var publisherId : String;
		public var disableCompanionAds : String = "false";
		

		public function doubleclickPluginCode()
		{
			super();
		}
		
		private var _facade:IFacade;
		public var video:Video;
		
		
		private var _doubleclickMediator:DoubleclickMediator; 
		
		public function initializePlugin(facade:IFacade):void {
			_facade	= facade;	
			_doubleclickMediator	= new DoubleclickMediator(this);
			_doubleclickMediator.eventDispatcher.addEventListener(NotificationType.CHANGE_MEDIA, onInit);
			_doubleclickMediator.eventDispatcher.addEventListener(DoubleclickMediator.INIT_PREROLL, onPreRoll);
			_doubleclickMediator.eventDispatcher.addEventListener(DoubleclickMediator.INIT_POSTROLL, onPostRoll);
			_doubleclickMediator.eventDispatcher.addEventListener(DoubleclickMediator.INIT_MIDROLL, onMidRoll);
			_doubleclickMediator.eventDispatcher.addEventListener(NotificationType.VOLUME_CHANGED, onVolumeChange);
//			_doubleclickMediator.eventDispatcher.addEventListener(NotificationType.CHANGE_MEDIA, onChangeMedia);
			_doubleclickMediator.preSequence = preSequence;
			_doubleclickMediator.postSequence = postSequence;
			facade.registerMediator(_doubleclickMediator);
			
		}
		
		private function onVolumeChange(e:Event):void{
			_sndTransform.volume			= this._doubleclickMediator.getVolume();
			changeVolume();
		}

		private function changeVolume():void{
			for each (var ns:NetStream in _netStreams){
				ns.soundTransform		= _sndTransform;
			}
		}
		


		private function onAdLoaded(event:AdLoadedEvent):void {
			//retain reference to each netstream
			_adNetStream			= event.netStream;
			_adTimer.addEventListener(TimerEvent.TIMER,onAdTimer);
			_adTimer.start();

			if(event.netStream != null){
				_netStreams.push(event.netStream);
				changeVolume();
			}			
		}
		private function onAdTimer(e:TimerEvent):void{
			_facade.sendNotification(NotificationType.PLAYER_UPDATE_PLAYHEAD,_adNetStream.time);
		}
		
		
		

		private function onPreRoll(e:Event):void{
			onLoadAd();
		}
		private function onPostRoll(e:Event):void{
			//some ads dont' qualify as postroll
			if(adType !=  AdsRequestType.TEXT_OVERLAY &&
				adType != AdsRequestType.TEXT &&
				adType != AdsRequestType.TEXT_OR_GRAPHICAL &&
				adType != AdsRequestType.TEXT_FULL_SLOT)
				onLoadAd();
		}
		private function onMidRoll(e:Event):void{
			onLoadAd();
		}
		
		
		//sending preSequenceNotificationStartName notification generates 2 events for some reason.  
		//this flag is to prevent ads from stacking up. 
		private var _adIsLoaded:Boolean 	= false;
		private function onLoadAd(event:Event = null):void {
			if(!_adIsLoaded){
				if(video)
					video.visible	= true;
				_adIsLoaded	= true;
				unloadAd();
				clearVideo();
				loadAd();
			}
		}

		
		private var adsLoader:AdsLoader;
		private var adsRequest:AdsRequest;
		
		private function onInit(e:Event):void{
			_netStreams		= new Array();
			if(!video){
				this.overlayAds	= new Array();
				video 			= new Video();
				video.width		= this.width;
				video.height	= this.height;
				addChild(video);
				

			}
			
			for each(var spr:Sprite in overlayAds){
				if(this.contains(spr))
					removeChild(spr);
				spr	= null;
			}
			
			for each (var loader:AdsLoader in adsLoaders){
				loader 	= null;
			}
			
			for each (var manager:AdsManager in dbclickAdsManager){
				manager.unload();
				manager 	= null;
			}
			
			this.onChangeMedia();
		}
		
		private var _myWidth:Number;
		override public function set width(value:Number):void
		{
			_myWidth = value;
			super.width = value;
			updateSizes();
		}	
		
		/**
		 *  
		 * Override the height property, in order to knwo when to call callResize
		 * @param value the new height
		 * @return 
		 * 
		 */		
		private var _myHeight:Number;
		override public function set height(value:Number):void
		{
			_myHeight = value;
			super.height = value;
			updateSizes();
		}	
		
		private function updateSizes():void
		{
			callLater(callResize);
		}
		
		//clear overlays on end of video
		private function onChangeMedia():void{
			if(adsManager){
				adsManager.unload();
				adsManager = null;
			}
		}

		/**
		 *  
		 * Update the doubleclick player that the size of the stage changed (and it needs to fit)
		 * @param 
		 * @return 
		 * 
		 */		
		private function callResize():void
		{
			
			if(parent && video)
			{ 
				video.width  = _myWidth;
				video.height = _myHeight;
			}
			
			//resize adsManager if available
			if(dbclickAdsManager){
				for each(var adsMan:AdsManager in dbclickAdsManager){
					adsMan.adSlotHeight			= this.height;
					adsMan.adSlotWidth			= this.width;			
				}
			}
		}
				
		private var adsManager:AdsManager;
		private var _adAvailable:Boolean	= false;

		private function unloadAd():void {
			try {
				if (adsManager) {
					removeListeners();
					removeAdsManagerListeners();
				}
			} catch (e:Error) {
				trace("doubleclickError occured during unload : " + e.message + e.getStackTrace());
			}
		}
		
		private function clearVideo():void {
			if (video){video.clear();}
		}
		
		private function removeListeners():void {
			//adsManager.removeEventListener(AdLoadedEvent.LOADED, onAdLoaded);
			
			
			if (adsManager.type == AdsManagerTypes.VIDEO) {
				var videoAdsManager:VideoAdsManager = adsManager as VideoAdsManager;
				videoAdsManager.removeEventListener(AdEvent.STOPPED, onVideoAdStopped);
				//videoAdsManager.removeEventListener(AdEvent.STARTED, onAdStarted);
				videoAdsManager.removeEventListener(AdEvent.PAUSED, onVideoAdPaused);
				videoAdsManager.removeEventListener(AdEvent.COMPLETE, onVideoAdComplete);
				videoAdsManager.removeEventListener(AdEvent.MIDPOINT,onVideoAdMidpoint);
				videoAdsManager.removeEventListener(AdEvent.FIRST_QUARTILE, onVideoAdFirstQuartile);
				videoAdsManager.removeEventListener(AdEvent.THIRD_QUARTILE,onVideoAdThirdQuartile);
				videoAdsManager.removeEventListener(AdEvent.RESTARTED, onVideoAdRestarted);
				videoAdsManager.removeEventListener(AdEvent.VOLUME_MUTED, onVideoAdVolumeMuted);
			} else if (adsManager.type == AdsManagerTypes.FLASH) {
				var flashAdsManager:FlashAdsManager = adsManager as FlashAdsManager;
				flashAdsManager.removeEventListener(AdSizeChangedEvent.SIZE_CHANGED, onFlashAdSizeChanged);
				flashAdsManager.removeEventListener(FlashAdCustomEvent.CUSTOM_EVENT, onFlashAdCustomEvent);
			}
		}
		
		private function removeAdsManagerListeners():void {
			adsManager.removeEventListener(AdErrorEvent.AD_ERROR, onAdError);
			adsManager.removeEventListener(AdEvent.CONTENT_PAUSE_REQUESTED, onContentPauseRequested);
			adsManager.removeEventListener(AdEvent.CONTENT_RESUME_REQUESTED, onContentResumeRequested);
			adsManager.removeEventListener(AdEvent.CLICK, onAdClicked);
			adsManager.removeEventListener(AdEvent.STARTED, onAdStarted);
		}
		
		public function loadNonLinearAd():void{
			onLoadAd();
		}
		/*
		private function getAdSlotSizes(req:AdsRequest):AdsRequest{
			
		}
		*/
		/**
		 * This method is used to create the AdsRequest object which is used by the
		 * AdsLoader to request ads.
		 */
		private function createAdsRequest():AdsRequest {
			var request:AdsRequest	= new AdsRequest();

			request.adSlotHeight			= this.height;
			
			request.adSlotWidth				= this.width;
			
			if(hasValue(adTagUrl))
				request.adTagUrl			= adTagUrl;
			
			if(hasValue(adType))
				request.adType				= AdsRequestType[adType.toUpperCase()];
			
			if(_channels.length > 0)
				request.channels			= _channels;
			else
				request.channels			= [];
			
			if(hasValue(contentId))
				request.contentId = (contentId == "null")?null:contentId;
			
			if(hasValue(publisherId))
				request.publisherId =	(publisherId == "null")?null:publisherId;
			
			if(hasValue(disableCompanionAds))
				request.disableCompanionAds	= (disableCompanionAds.toUpperCase() == "TRUE")?true:false;

			if(hasValue(cmsId))
				request.cmsId	= 			cmsId;
			
			// Checks the companion type from flashVars to decides whether to use GUT
			// or getCompanionAds() to load companions.
			
			_flashVars = _facade.retrieveProxy("configProxy")["vo"]["flashvars"];
			_useGUT = _flashVars != null && _flashVars.useGUT == "false" ? false : true;
			if (!_useGUT) {
				request.disableCompanionAds = true;
			}
			
			trace("doubleclick sent REQUEST::::::: adSlotHeight: 			"+request.adSlotHeight);
			trace("doubleclick sent REQUEST::::::: adSlotWidth: 			"+request.adSlotWidth);
			trace("doubleclick sent REQUEST::::::: adTagUrl: 				"+request.adTagUrl);
			trace("doubleclick sent REQUEST::::::: adType:		 			"+request.adType);
			trace("doubleclick sent REQUEST::::::: channels:				"+request.channels);
			trace("doubleclick sent REQUEST::::::: contentId:				"+request.contentId);
			trace("doubleclick sent REQUEST::::::: publisherId:				"+request.publisherId);
			trace("doubleclick sent REQUEST::::::: disableCompanionAds:		"+request.disableCompanionAds);
			trace("doubleclick sent REQUEST::::::: cmsId:					"+request.cmsId);
			
			return request;
		}
		
		/**
		 * This method is invoked when the adsLoader has completed loading an ad
		 * using the adsRequest object provided.
		 */
		
		private function loadFlashAd(manager:AdsManager):void{
			var flashAdContainer:Sprite = new Sprite();
			addChild(flashAdContainer);
			var videoPlaceHolder:DisplayObject = this;
			var point:Point = videoPlaceHolder.localToGlobal(new Point(videoPlaceHolder.x,videoPlaceHolder.y));
			(manager as FlashAdsManager).decoratedAd	= true;
			(manager as FlashAdsManager).x = point.x;
			(manager as FlashAdsManager).y = point.y;
			(manager as FlashAdsManager).load();
			(manager as FlashAdsManager).play(flashAdContainer);	
			
			//continue sequence since flash ad
			this.overlayAds.push(flashAdContainer);
			
		}
		
		private function onAdsLoaded(adsLoadedEvent:AdsLoadedEvent):void {
			//multiple ads can be contained in request but not currently being handled.
			adsManager = adsLoadedEvent.adsManager;
			adsManager.addEventListener(AdErrorEvent.AD_ERROR, onAdError);
			adsManager.addEventListener(AdEvent.CONTENT_PAUSE_REQUESTED, onContentPauseRequested);
			adsManager.addEventListener(AdEvent.CONTENT_RESUME_REQUESTED, onContentResumeRequested);
			adsManager.addEventListener(AdLoadedEvent.LOADED, onAdLoaded);
			adsManager.addEventListener(AdEvent.STARTED, onAdStarted);
			displayAdsInformation(adsManager);
			
			trace("LOADNG AD!!!!	"+adsManager.type);
			if (adsManager.type == AdsManagerTypes.FLASH) {

				var flashAdsManager:FlashAdsManager = adsManager as FlashAdsManager;
				flashAdsManager.addEventListener(AdSizeChangedEvent.SIZE_CHANGED,onFlashAdSizeChanged);
				flashAdsManager.addEventListener(FlashAdCustomEvent.CUSTOM_EVENT,onFlashAdCustomEvent);

				loadFlashAd(flashAdsManager);
				//call ad complete for flash ads to continue sequence.
				onVideoAdComplete();
			} else if (adsManager.type == AdsManagerTypes.VIDEO) {
				addChild(video);
				var videoAdsManager:VideoAdsManager = adsManager as VideoAdsManager;
				//videoAdsManager.addEventListener(AdEvent.STARTED,onAdStarted);
				videoAdsManager.addEventListener(AdEvent.STOPPED,onVideoAdStopped);
				videoAdsManager.addEventListener(AdEvent.PAUSED, onVideoAdPaused);
				videoAdsManager.addEventListener(AdEvent.COMPLETE, onVideoAdComplete);
				videoAdsManager.addEventListener(AdEvent.MIDPOINT, onVideoAdMidpoint);
				videoAdsManager.addEventListener(AdEvent.FIRST_QUARTILE, onVideoAdFirstQuartile);
				videoAdsManager.addEventListener(AdEvent.THIRD_QUARTILE, onVideoAdThirdQuartile);
				videoAdsManager.addEventListener(AdEvent.RESTARTED, onVideoAdRestarted);
				videoAdsManager.addEventListener(AdEvent.VOLUME_MUTED, onVideoAdVolumeMuted);
				
				videoAdsManager.clickTrackingElement = this;	
				
				videoAdsManager.load(video);
				videoAdsManager.play(video);
				
			} 
			dbclickAdsManager.push(adsManager);
			//dispatching adStart notification here because AdEvent.STARTED is fired off multiple times.
			//will follow up with google on this. 
			_facade.sendNotification(AdsNotificationTypes.AD_START);
		}

		
		private var dbclickAdsManager:Array	= new Array();
		
		
		private function onVideoAdComplete(e:AdEvent = null):void{
			_adTimer.stop();
			_adTimer.removeEventListener(TimerEvent.TIMER, onAdTimer);
			if(this.contains(video))
				removeChild(video);
			
			_adIsLoaded	= false;
			
			clearVideo();
			_facade.sendNotification(AdsNotificationTypes.AD_END);
			_facade.sendNotification(NotificationType.SEQUENCE_ITEM_PLAY_END);
			_facade.sendNotification("enableGui", {guiEnabled: true, enableType: "full"});
			
		}
		
		/**
		 * This method is used to log information regarding the AdsManager and
		 * the Ad objects.
		 *
		 * Publishers will usually not need to do this unless they are interested
		 * in logging or otherwise processing data about the ads.
		 */
		private function displayAdsInformation(adsManager:Object):void {
			var ads:Array = adsManager.ads;
			if (ads) {
				for each (var ad:Ad in ads) {
					try {
						// APIs defined on Ad
						// Check the companion type from flashVars to decide whether to use
						// GUT or getCompanionAds() to load companions.
						if (!_useGUT) {
							renderHtmlCompanionAd(
								ad.getCompanionAds(CompanionAdEnvironments.HTML, 300, 250),
								"300x250");
							renderHtmlCompanionAd(
								ad.getCompanionAds(CompanionAdEnvironments.HTML, 728, 90),
								"728x90");
						}
						if (ad.type == AdTypes.VAST) {
							var vastAd:VastVideoAd = ad as VastVideoAd;
							trace("description: " + vastAd.description);
							trace("adSystem: " + vastAd.adSystem);
							trace("customClicks: " + vastAd.customClicks);
						} else if (ad.type == AdTypes.VIDEO) {
							// APIs defined on all video ads
							var videoAd:VideoAd = ad as VideoAd;
							trace("author: " + videoAd.author);
							trace("title: " + videoAd.title);
							trace("ISCI: " + videoAd.ISCI);
							trace("deliveryType: " + videoAd.deliveryType);
							trace("mediaUrl: " + videoAd.mediaUrl);
							// getCompanionAdUrl will throw error for VAST ads.
							trace("getCompanionAdUrl: " + ad.getCompanionAdUrl("flash"));
						} else if (ad.type == AdTypes.FLASH) {
							// API defined on FlashAd
							var flashAd:FlashAd = ad as FlashAd;
							if (flashAd.asset != null) {
								trace("asset: " + flashAd.asset);
								trace("asset x: " + flashAd.asset.x);
								trace("asset y: " + flashAd.asset.y);
								trace("asset height: " + flashAd.asset.height);
								trace("asset width: " + flashAd.asset.width);
							} else {
								trace("Error: flashAsset is null.");
							}
						}

					} catch (error:Error) {
						trace("doubleclick Error type:" + error + " message:" + error.message);
					}
				}
			}
		}
		
		
		private function onAdStarted(event:AdEvent):void {
			trace("doubleclick sent : db adsManager sent "+event.type);
		}
		
		private function onAdClicked(event:AdEvent):void {
			trace("doubleclick sent : db adsManager sent "+event.type);
		}
		
		private function onFlashAdSizeChanged(event:AdSizeChangedEvent):void {
			trace("doubleclick sent SIZE CHANGE:  "+event.type, event.adType, event.width, event.height, event.state, event.ad);
				var flashAd:FlashAd = event.ad as FlashAd;
				if (flashAd.asset != null) {
					loadFlashAd(adsManager);
					trace("doubleclick sent type: " + flashAd.asset.type);
					trace("doubleclick sent asset: " + flashAd.asset);
					trace("doubleclick sent asset x: " + flashAd.asset.x);
					trace("doubleclick sent asset y: " + flashAd.asset.y);
					trace("doubleclick sent asset height: " + flashAd.asset.height);
					trace("doubleclick sent asset width: " + flashAd.asset.width);
					
				} else {
					trace("Error: flashAsset is null.");
				}
		}
		
		private function onFlashAdCustomEvent(event:FlashAdCustomEvent):void {
			trace("doubleclick sent FLASH AD CUSTOM EVENT:"+event.type);
		}
		private function onVideoAdStopped(event:AdEvent):void {
			trace("doubleclick sent : "+event.type);
		}
		
		private function onVideoAdPaused(event:AdEvent):void {
			trace("doubleclick sent : "+event.type);
		}
		
		private function onVideoAdMidpoint(event:AdEvent):void {
			trace("doubleclick sent : "+event.type);
		}
		
		private function onVideoAdFirstQuartile(event:AdEvent):void {
			trace("doubleclick sent : "+event.type);
		}
		
		private function onVideoAdThirdQuartile(event:AdEvent):void {
			trace("doubleclick sent : "+event.type);
		}
		
		private function onVideoAdClicked(event:AdEvent):void {
			trace("doubleclick sent : "+event.type);
		}
		
		private function onVideoAdRestarted(event:AdEvent):void {
			trace("doubleclick sent : "+event.type);
		}
		
		private function onVideoAdVolumeMuted(event:AdEvent):void {
			trace("doubleclick sent : "+event.type);
		}
		
		private function renderHtmlCompanionAd(companionArray:Array,size:String):void {
			if (companionArray.length > 0) {
				trace("doubleclick There are " + companionArray.length + " companions for this ad.");
				var companion:CompanionAd = companionArray[0] as CompanionAd;
				if (companion.environment == CompanionAdEnvironments.HTML) {
					trace("doubleclick companion " + size + " environment: " + companion.environment);
					var htmlCompanion:HtmlCompanionAd = companion as HtmlCompanionAd;
					if(ExternalInterface.available) {
						ExternalInterface.call(WRITE_INTO_COMPANION_DIV,htmlCompanion.content,size);
					}
				}
			}
		}
		
		/**
		 * This method is invoked when an interactive flash ad raises the
		 * contentPauseRequested event.
		 *
		 * We recommend that publishers pause their video content when this method
		 * is invoked. This is usually because the ad will play within the video
		 * player itself or cover the video player so that the publisher content
		 * would not be easily visible.
		 */
		private function onContentPauseRequested(event:AdEvent):void {
			
		}
		
		
		/**
		 * This method is invoked when an interactive flash ad raises the
		 * contentResumeRequested event.
		 *
		 * We recommend that publishers resume their video content when this method
		 * is invoked. This is because the ad has completed playing and the
		 * publisher content should be resumed from the time it was paused.
		 */
		private function onContentResumeRequested(event:AdEvent = null):void {
			_facade.sendNotification(NotificationType.SEQUENCE_ITEM_PLAY_END);
		}
		
		
		/**
		 * Function to start playing the plugin content - each plugin implements this differently
		 * 
		 */		
		public function start () : void{
			_doubleclickMediator.forceStart();
		}
			
		/**
		 * Creates the AdsLoader object if its not present
		 * and request ads using the AdsLoader object.
		 */
		private var adsLoaders:Array	= new Array();
		private function loadAd():void {
				adsLoader = new AdsLoader();
				adsLoaders.push(adsLoader);
				adsLoader.addEventListener(AdsLoadedEvent.ADS_LOADED, onAdsLoaded);
				adsLoader.addEventListener(AdErrorEvent.AD_ERROR, onAdError);
			
			adsLoader.requestAds(createAdsRequest());
		}
		

		
		private function hasValue(val:String):Boolean{
			return (val != "" && val != "undefined")?true:false;
		}
		
			/**
			 *Function returns whether the plugin in question has a sub-sequence 
			 * @return The function returns true if the plugin has a sub-sequence, false otherwise.
			 * 
			 */		
		public function hasSubSequence() : Boolean{return false;}
				
				/**
				 * Function returns the length of the sub-sequence length of the plugin 
				 * @return The function returns an integer signifying the length of the sub-sequence;
				 * 			If the plugin has no sub-sequence, the return value is 0.
				 */		
		public function subSequenceLength () : int{return 0;}
					
					/**
					 * Returns whether the Sequence Plugin plays within the KDP or loads its own media over it. 
					 * @return The function returns <code>true</code> if the plugin media plays within the KDP
					 *  and <code>false</code> otherwise.
					 * 
					 */		
		public function hasMediaElement () : Boolean{trace("doubleclick plugin: hasMediaElement()");return false;}
						
						/**
						 * Function for retrieving the entry id of the plugin media
						 * @return The function returns the entry id of the plugin media. If the plugin does not play
						 * 			a kaltura-based entry, the return value is the URL of the media of the plugin.
						 */		
		public function get entryId () : String{trace("doubleclick plugin: entryId()");return "0_kjvoet76";}
							
							/**
							 * Function for retrieving the source type of the plugin media (url or entryId) 
							 * @return If the plugin plays a Kaltura-Based entry the function returns <code>entryId</script>.
							 * Otherwise the return value is <code>url</script>
							 * 
							 */		
		public function get sourceType () : String{trace("doubleclick plugin: sourceType()");return "entryId";}
								/**
								 * Function to retrieve the MediaElement the plugin will play in the KDP. 
								 * @return returns the MediaElement that the plugin will play in the KDP. 
								 * 
								 */		
		public function get mediaElement () : Object{trace("doubleclick plugin: mediaElement()");return new Object()}
									
									/**
									 * Function for determining where to place the ad in the pre sequence; 
									 * @return The function returns the index of the plugin in the pre sequence; 
									 * 			if the plugin should not appear in the pre-sequence, return value is -1.
									 */		
		public function get preIndex () : Number{trace("doubleclick plugin: preIndex()");return Number(preSequence);}
									
									/**
									 *Function for determining where to place the plugin in the post-sequence. 
									 * @return The function returns the index of the plugin in the post-sequence;
									 * 			if the plugin should not appear in the post-sequence, return value is -1.
									 */		
		public function get postIndex () : Number{trace("doubleclick plugin: postIndex()");return Number(postSequence);}
									
		
		
		
		private function onPauseRequested(e:AdEvent):void{
			
		}
		
		private function onResumeRequested(e:AdEvent):void{
			
		}
		
		private function onAdError(e:AdErrorEvent):void{
			trace("doubleclick DOUBLE CLICK ON ADS ERROR	"+e);
			//TODO add check if this is a pre/post/mid and context for video/overlay
			onVideoAdComplete();
		}
		
		
		/**
		 * Do nothing.
		 * No implementation required for this interface method on this plugin.
		 * @param styleName
		 * @param setSkinSize
		 */
		public function setSkin(styleName:String, setSkinSize:Boolean = false):void {}

		
		private function onSecurityError(e:SecurityErrorEvent):void{
			trace("doubleclick ERROR: DOUBLECLICK Plugin - error sending beacon : "+e);
		}
		
		private function onIOError(e:IOErrorEvent):void{
			trace("doubleclick ERROR: DOUBLECLICK Plugin - error sending beacon : "+e);
		}
	}
}