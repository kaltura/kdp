package
{
	import com.google.ads.ima.api.Ad;
	import com.google.ads.ima.api.AdErrorEvent;
	import com.google.ads.ima.api.AdEvent;
	import com.google.ads.ima.api.AdsLoader;
	import com.google.ads.ima.api.AdsManager;
	import com.google.ads.ima.api.AdsManagerLoadedEvent;
	import com.google.ads.ima.api.AdsRenderingSettings;
	import com.google.ads.ima.api.AdsRequest;
	import com.google.ads.ima.api.CompanionAd;
	import com.google.ads.ima.api.CompanionAdEnvironments;
	import com.google.ads.ima.api.CompanionAdSelectionSettings;
	import com.google.ads.ima.api.FlashCompanionAd;
	import com.google.ads.ima.api.HtmlCompanionAd;
	import com.google.ads.ima.api.ImaSdkSettings;
	import com.google.ads.ima.api.ViewModes;
	import com.google.ads.ima.wrappers.ImaSdkSettingsWrapper;
	import com.kaltura.kdpfl.model.LayoutProxy;
	import com.kaltura.kdpfl.model.MediaProxy;
	import com.kaltura.kdpfl.model.SequenceProxy;
	import com.kaltura.kdpfl.model.type.NotificationType;
	import com.kaltura.kdpfl.model.type.SequenceContextType;
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.plugin.IPluginFactory;
	import com.kaltura.kdpfl.plugin.ISequencePlugin;
	import com.kaltura.kdpfl.plugin.component.DoubleclickMediator;
	import com.kaltura.kdpfl.view.media.KMediaPlayerMediator;
	
	import fl.core.UIComponent;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.media.Video;
	import flash.system.Security;
	import flash.text.TextField;
	import flash.utils.Timer;
	
	import org.osmf.events.MediaPlayerStateChangeEvent;
	import org.osmf.media.MediaElement;
	import org.osmf.media.MediaFactory;
	import org.osmf.media.URLResource;
	import org.puremvc.as3.interfaces.IFacade;
	import org.puremvc.as3.interfaces.IProxy;
	
	public dynamic class doubleclickPluginCode extends UIComponent implements IPlugin, ISequencePlugin
	{
		public var debugMode:Boolean	=	false;
		
		public var contentPlayhead:Object = {};
		
		public var playerIsPlaying:Boolean	= false;
		
		//which slot index should this plugin take during a postroll event
		public var postSequence:int;
		//which slot index should this plugin take during a preroll event
		public var preSequence:int;
		//which slot index should this plugin take during a midroll event
		public var midSequence:int;
		
		//adTagURL from cuepoint
		public var cpAdTagUrl:String;
		
		//adTagURL from config, overrides cuepoint ad tags. 
		private var _adTagUrl:String;
		
		//do we care about cuepoints? 
		public var trackCuePoints:Boolean		= true;
		
		//time remaining during ad playback
		public var remainingTime:Number			= -1;
		
		//current ad playback time
		public var currentTime:Number			= -1;
		
		//current ad duration
		public var adDuration:Number;
		
		public var durationRetrieved:Boolean = false; 
		
		//channels id
		public var channels:Number;
		
		//The contentId, generally the entry id, but can also be custom metadata mapping
		public var contentId:String;
		
		//if companion ads should be disabled
		public var disableCompanionAds:Boolean = true;
		
		//placeholder for flash companion ad
		public var companionContainerId:String;
		
		//background color
		public var bgColor:uint			= 0x000000;
		
		public var adInProgress:Boolean		= false;
		// SDK Objects
		private var _adsLoader:Object = {"loader":null, "type":null};
		private var _adManagers:Array;
		private var adsManager:AdsManager;
		private var flashCompanion:FlashCompanionAd;
		private var htmlCompanion:HtmlCompanionAd;
		//track when the ad was clicked so we can resume content
		private var _isAdClicked:Boolean	= false;
		private var _mediaUrl:String;
		private var _adContext:String;
		private var _sequenceProxy:SequenceProxy;
		private var _playerMediator:KMediaPlayerMediator;
		private var _mediaProxy:MediaProxy;
		private var _layoutProxy:LayoutProxy;
		private var _mediator:DoubleclickMediator;
		private var _facade:IFacade;
		//inspect first loaded ad to see if it has cuepoints. cuepoint == adRule  
		private var _isAdRule:Boolean	= 	false;
		//used to cover the viewing area so images behind the plugin are not visible. 
		private var _background:Sprite;
		
		/////////////////TEST AD TAG URLS\\\\\\\\\\\\\\\\\\\\
		//also has companion ads
		private static const LINEAR_AD_TAG:String = "http://pubads.g.doubleclick.net/gampad/ads?sz=400x300&iu=%2F6062%2Fiab_vast_samples&ciu_szs=300x250%2C728x90&impl=s&gdfp_req=1&env=vp&output=xml_vast2&unviewed_position_start=1&url=[referrer_url]&correlator=[timestamp]&cust_params=iab_vast_samples%3Dlinear";
		
		//also has companion ads
		private static const NONLINEAR_AD_TAG:String = 
			"http://pubads.g.doubleclick.net/gampad/ads?sz=400x300&" +
			"iu=%2F6062%2Fiab_vast_samples&ciu_szs=300x250%2C728x90&" +
			"impl=s&gdfp_req=1&env=vp&output=xml_vast2&unviewed_position_start=1&" +
			"url=[referrer_url]&correlator=[timestamp]&" +
			"cust_params=iab_vast_samples%3Dimageoverlay";
		
		//has 2 prerolls, 30sec ad, 60sec ad, 90 sec ad and postroll
		//also has companion ads
		private static const AD_RULE_TAG:String	= "http://pubads.g.doubleclick.net/gampad/ads?sz=640x480&iu=%2F3510761%2FadRulesSampleTags&ciu_szs=160x600%2C300x250%2C728x90&cust_params=adrule%3Dpremidpostpodandbumpers&impl=s&gdfp_req=1&env=vp&ad_rule=1&vid=41117659&cmsid=481&output=xml_vast2&unviewed_position_start=1&url=[referrer_url]&correlator=[timestamp]";
		
		/////////////////TEST AD TAG URLS\\\\\\\\\\\\\\\\\\\\
		
		
		public function doubleclickPluginCode()
		{
			super();
			Security.allowDomain("*");
		}
		
		public function get adTagUrl():String
		{
			return _adTagUrl;
		}
		
		public function set adTagUrl(value:String):void
		{
			_adTagUrl = unescape(value);
		}
		
		public function initializePlugin(facade:IFacade):void
		{
			
			_mediator		= new DoubleclickMediator(this); 
			_facade			= facade;
			
			facade.registerMediator(_mediator);
			_mediator.eventDispatcher.addEventListener(DoubleclickMediator.INIT_PREROLL, initAd);
			_mediator.eventDispatcher.addEventListener(DoubleclickMediator.INIT_POSTROLL, initAd);
			_mediator.eventDispatcher.addEventListener(DoubleclickMediator.INIT_MIDROLL, initAd);
			_mediator.eventDispatcher.addEventListener(NotificationType.CHANGE_MEDIA, runReset);
			_mediator.eventDispatcher.addEventListener(NotificationType.PLAYBACK_COMPLETE, playbackComplete);
			_mediator.eventDispatcher.addEventListener(NotificationType.DO_REPLAY, runReset);
			
		}  
		
		/**
		 * plugin properties should reset after each media change
		 * **/
		protected function runReset(event:Event = null):void{
			log("runReset!");
			if(_adsLoader.loader)_adsLoader.loader.destroy();
			
			_adsLoader.loader	= null;
			_isAdRule			= false;
			_contentComplete	= false;
			
			destroyAdsManager("all");
		}
		
		private var _contentComplete:Boolean	= false;
		private function playbackComplete(e:Event):void{
			log("playbackComplete!");
			_contentComplete	= true;
			_adsLoader.loader.contentComplete();
		}
		
		public function initAd(e:Event =  null):void{
			//			if(e)
			//			if(e.type	== doubleClickMediator.INIT_PREROLL)runReset();
			if(!_adManagers)
				_adManagers	= new Array();
			
			if(!_sequenceProxy)
				_sequenceProxy	= (_facade.retrieveProxy("sequenceProxy") as SequenceProxy);
			
			if(!_playerMediator)
				_playerMediator	= (_facade.retrieveMediator("kMediaPlayerMediator") as KMediaPlayerMediator);
			
			if(!_mediaProxy)
				_mediaProxy		= (_facade.retrieveMediator("mediaProxy") as MediaProxy);
			
			if(!_layoutProxy){
				_layoutProxy	= (_facade.retrieveMediator("layoutProxy") as LayoutProxy);
				
			}
			
			if(!_background){
				_background		= new Sprite();
				_background.graphics.beginFill(bgColor);
				_background.graphics.drawRect(0,0,this.width,this.height);
				_background.graphics.endFill();
			}
			
			
			
			var adTag:String	= getAdTagUrl();
			
			if(adTag == ""){
				trace("[DOUBLECLICK]	- no adTagsFound");
				return;//no adTags  found
			}
			
			_adContext			= _mediator.adContext;
			
			log("initialize	 : "+_adContext);
			log("initialize	 : AdTag:	"+decodeURIComponent(adTag));
			
			//return response if no adTag found. 
			if(!adTag && preSequence > -1)this.contentResumeRequestedHandler();
			
			requestAds(adTag);
			
		}
		
		/**
		 * determines which adTagUrl to use
		 * **/
		protected function getAdTagUrl():String{
			var response:String	= "";
			
			//if there's an adTagUrl and this is presequence use adTagUrl
			if(adTagUrl && preSequence > 0 && _sequenceProxy.sequenceContext == SequenceContextType.PRE){
				response		= adTagUrl;
			}
			
			//if there's an adTagUrl and this is post use adTagUrl
			if(adTagUrl && postSequence > 0 && _sequenceProxy.sequenceContext == SequenceContextType.POST){
				response		= adTagUrl;
			}
			//if this is a cuepoint adTagUrl
			if(cpAdTagUrl && cpAdTagUrl.indexOf("http") > -1){
				response		= cpAdTagUrl;
				cpAdTagUrl		= "";
			}
			
			return response;
		}
		
		/**
		 * Request ads using the specified ad tag.
		 *
		 * @param adTag A URL that will return a valid VAST response.
		 */
		public function requestAds(adTag:String):void { 
			log("requestAds");
			
			// The AdsRequest encapsulates all the properties required to request ads.
			var adsRequest:AdsRequest = new AdsRequest();
			adsRequest.adTagUrl = adTag;
			adsRequest.disableCompanionAds	= disableCompanionAds;
			adsRequest.linearAdSlotWidth 	= this.width;
			adsRequest.linearAdSlotHeight 	= this.height;
			adsRequest.nonLinearAdSlotWidth = this.width;
			adsRequest.nonLinearAdSlotHeight = this.width;
			
			//	if(contentId)
			//		adsRequest.contentId			= contentId;
			var loaderType:AdsLoader;
			if(_adsLoader.type != "adRule"){
				//typically the first loader request should be an adRule, so we give it global scope. 
				_adsLoader.loader = new AdsLoader();
				
				//add IMASdkSettings?
				_adsLoader.loader.addEventListener(AdsManagerLoadedEvent.ADS_MANAGER_LOADED, adsManagerLoadedHandler);
				_adsLoader.loader.addEventListener(AdErrorEvent.AD_ERROR, adsLoadErrorHandler);
				loaderType	= _adsLoader.loader;
				
			}else{
				var nonAdRuleLoader:AdsLoader	= new AdsLoader();
				
				nonAdRuleLoader.addEventListener(AdsManagerLoadedEvent.ADS_MANAGER_LOADED, adsManagerLoadedHandler);
				nonAdRuleLoader.addEventListener(AdErrorEvent.AD_ERROR, adsLoadErrorHandler);
				
				loaderType			= nonAdRuleLoader;
			}
			//			}
			
			
			
			// Instruct AdsLoader to request ads using the AdsRequest object.
			loaderType.requestAds(adsRequest);
			
			
		}
		
		/**
		 * Invoked when the AdsLoader successfully fetched ads.
		 */
		private function adsManagerLoadedHandler(event:AdsManagerLoadedEvent):void 
		{log("adsManagerLoadedHandler");
			// Publishers can modify the default preferences through this object.
			var adsRenderingSettings:AdsRenderingSettings =
				new AdsRenderingSettings();
			
			adsRenderingSettings.autoAlign				= true;
			
			// In order to support VMAP ads, ads manager requires an object that
			// provides current playhead position for the content.						
			contentPlayhead		= {
				time:function():Number {
					
					var playTime:Number = _playerMediator.player.currentTime;
					//correct the .25 sec delay on ads during adrule playback
					playTime	= _mediator.playheadTime;//(playTime)*1000;
					if(playTime < 0){
						playTime = 0;
					}
					
					return playTime; // Make time in ms.
				}
			} // convert to milliseconds.
			
			// Get a reference to the AdsManager object through the event object.
			adsManager = event.getAdsManager(contentPlayhead, adsRenderingSettings);
			
			//ads seem to be tied to one adManager, so we store them here for resize purposes 
			//and destory after each changemedia.  TODO: possibly destory ad sooner. 
			_adManagers.push(adsManager);
			
			if (adsManager) 
			{
				// Add required ads manager listeners.
				// ALL_ADS_COMPLETED event will fire once all the ads have played. There
				// might be more than one ad played in the case of ad pods and VMAP.
				adsManager.addEventListener(AdEvent.ALL_ADS_COMPLETED,
					allAdsCompletedHandler);
				// If ad is linear, it will fire content pause request event.
				adsManager.addEventListener(AdEvent.CONTENT_PAUSE_REQUESTED,
					contentPauseRequestedHandler);
				// When ad finishes or if ad is non-linear, content resume event will be
				// fired. For example, if VMAP response only has post-roll, content
				// resume will be fired for pre-roll ad (which is not present) to signal
				// that content should be started or resumed.
				adsManager.addEventListener(AdEvent.CONTENT_RESUME_REQUESTED,
					contentResumeRequestedHandler);
				// All AD_ERRORs indicate fatal failures. You can discard the AdsManager and
				// resume your content in this handler.
				adsManager.addEventListener(AdErrorEvent.AD_ERROR,
					adsManagerPlayErrorHandler);
				
				adsManager.addEventListener(AdEvent.COMPLETED,
					adCompletedHandler);
				
				adsManager.addEventListener(AdEvent.STARTED, adStartedHandler);
				adsManager.addEventListener(AdEvent.CLICKED, function(e:AdEvent):void{
					_isAdClicked	= true;
				});
				adsManager.addEventListener(AdEvent.STOPPED, function(e:AdEvent):void{
					log("ad stopped!");
				});
				adsManager.addEventListener(AdEvent.FIRST_QUARTILE, firstQuartileHandler);
				adsManager.addEventListener(AdEvent.MIDPOINT, midpointHandler);
				adsManager.addEventListener(AdEvent.THIRD_QUARTILE, thirdQuartileHandler);
				
				adsManager.addEventListener(AdEvent.DURATION_CHANGED, function(e:AdEvent):void{
					log("AdEvent.DURATION_CHANGED");
					
					//TODO: expose duration of ad as a public
					//NOTE: not sure if this works because duration does not change, so this event is not triggered
					//NOTE: so i did this in the remaining_time_changed function
					//this.adDuration = e.target.duration;					
				});
				
				// Dispatched when a user interacts with a VPAID 2.0 ad.
				adsManager.addEventListener(AdEvent.INTERACTION , function(e:AdEvent):void{
					log("AdEvent.INTERACTION");	
					//TODO: send notification for adclick
					_facade.sendNotification("adClick");
				});
				
				adsManager.addEventListener(AdEvent.REMAINING_TIME_CHANGED, function(e:AdEvent):void
				{
					if(!durationRetrieved)
					{
						this.adDuration = e.target.remainingTime;
						durationRetrieved = true;
					}
					this.remainingTime		= e.target.remainingTime;
					this.currentTime		= e.ad.currentTime;
				});
				
				adsManager.addEventListener(AdEvent.SKIPPED, function(e:AdEvent):void
				{
					log("AdEvent.SKIPPED");
					
					_facade.sendNotification("adSkipped");
					
					destroyAdsManager();
					contentResumeRequestedHandler();
				});
				
				adsManager.addEventListener(AdEvent.USER_CLOSED, function(e:AdEvent):void{
					log("AdEvent.USER_CLOSED");
					_facade.sendNotification("userClosedAd");
					destroyAdsManager();
					contentResumeRequestedHandler();
				});
				
				adsManager.addEventListener(AdEvent.VOLUME_CHANGED, function(e:AdEvent):void{
					log("AdEvent.VOLUME_CHANGED");	
				});
				
				adsManager.addEventListener(AdEvent.VOLUME_MUTED, function(e:AdEvent):void{
					log("AdEvent.VOLUME_MUTED");
					
				});
				
				adsManager.addEventListener(AdEvent.LOADED, function(e:AdEvent):void{
					log("AdEvent.LOADED	totalAds:"+e.ad.adPodInfo.totalAds );
					log("AdEvent.LOADED	position:"+e.ad.adPodInfo.adPosition );
					log("AdEvent.LOADED	isBumper:"+e.ad.adPodInfo.isBumper );
					if(e.target.cuePoints.length > 0){
						log("cuepont lenght:::: "+e.target.cuePoints.length);
						_isAdRule		= true;
					}
					
					//if overlay or adrule, resume content
					if (!adsManager.linear)
						contentResumeRequestedHandler(e);
				});
				
				adsManager.addEventListener(AdEvent.USER_ACCEPTED_INVITATION, function(e:Event):void{
					log("AdEvent.USER_ACCEPTED_INVITATION");
				});
				
				// If your video player supports a specific version of VPAID ads, pass
				// in the version. If your video player does not support VPAID ads yet,
				// just pass in 1.0.
				adsManager.handshakeVersion("1.0");
				// Init should be called before playing the content in order for VMAP
				// ads to function correctly.
				
				if(this.width == 0 || this.height == 0){
					
					super.width		= _facade["bindObject"]["video"]["width"];
					super.height	= _facade["bindObject"]["video"]["height"];
					
				}
				
				adsManager.init(this.width, this.height, ViewModes.NORMAL);		
				
				addChild(adsManager.adsContainer);
				
				// Start ad playback.
				adsManager.start();
			}
		}
		
		
		/**
		 * If an error occurs during the ads load, the content can be resumed or
		 * another ads request can be made. In this example, the content is resumed
		 * if there's an error loading ads.
		 */
		private function adsLoadErrorHandler(event:AdErrorEvent):void 
		{
			log("adsLoadErrorHandler ERROR.CODE:		"+event.error.errorCode);
			log("adsLoadErrorHandler ERROR.MESSAGE:	"+event.error.errorMessage);
			log("adsLoadErrorHandler ERROR.AD_IDS:	"+event.error.adIds);
			log("adsLoadErrorHandler ERROR.ERROR_TYPE:"+event.error.errorType);
			contentResumeRequestedHandler();
			_mediator.sendNotification(NotificationType.DO_PLAY);
		}
		
		/**
		 * The AdsManager raises this event when all ads for the request have been
		 * played.
		 */
		private function allAdsCompletedHandler(event:AdEvent):void 
		{	log("allAdsCompletedHandler");
			// This sends a notification that the ad has started
			_facade.sendNotification("adEnd", {context:_adContext});
			//TODO: check to see if isLinear then send DO PLAY
			//reset cpAdTagURL
			cpAdTagUrl	= "";
			
			// Ads manager can be destroyed after all of its ads have played.
			destroyAdsManager();
		}
		
		private function adCompletedHandler(event:AdEvent):void{
			log("AdEvent.adCompletedHandler	"+event.ad.adPodInfo.adPosition +" of "+ event.ad.adPodInfo.totalAds);
			if (!disableCompanionAds && flashCompanion)
				flashCompanion.destroy();
		}
		
		/**
		 * Clean up AdsManager references when no longer needed. Explicit cleanup
		 * is necessary to prevent memory leaks.
		 */
		private function destroyAdsManager(arg0:String=null):void 
		{log("destroyAdsManager"); 
			if(!_adManagers)return;
			for(var i:int=0;i<_adManagers.length;i++){
				if (_adManagers[i].cuePoints.length == 0 && _adManagers[i].linear) 
				{
					if (_adManagers[i].adsContainer.parent &&
						_adManagers[i].adsContainer.parent.contains(adsManager.adsContainer)) 
					{
						_adManagers[i].adsContainer.parent.removeChild(adsManager.adsContainer);
					}
					_adManagers[i].destroy();
				}else if(arg0 == "all"){
					_adManagers[i].destroy();
				}
				
			}
		}
		
		/**
		 * The AdsManager raises this event when the ad starts
		 */
		private function adStartedHandler(event:AdEvent):void
		{
			
			if(event.target.cuePoints){
				if(event.target.cuePoints.length > -1)
					_adsLoader.type		= "adRule";
			}
			
			log("adStartedHandler : isLinear: "+event.ad.linear);
			//flag to disable controls, stop playback and send adstart event
			var controlPlayer:Boolean		= false;
			
			var companionsAdContainer:Sprite = new Sprite();
			var ad:Ad = event.ad;
			
			//disable controls if it's an adrule or video ad
			if(ad.linear){
				//if _background has a parent, that means it's on the stage.  if its not on there add child at 0 display index.  so it won't overlap ads. 
				if(!_background.parent)this.addChildAt(_background,0);
				
				adInProgress	= true;
				// Send adStart notification	
				_facade.sendNotification("adStart", {context:_adContext});
				
				_mediator.stopPlayback();
				_mediator.disableControls();
				
			}
			
			// This loads and displays the Companion Ads 
			if(ad && companionContainerId){
				var companions:Array = ad.getCompanionAds(CompanionAdEnvironments.FLASH, 300, 250);
				
				
				if (companions.length != 0)
				{   
					flashCompanion = FlashCompanionAd(companions[0]);
					
					if(companionContainerId)
						_facade["bindObject"][companionContainerId].addChild(flashCompanion.adsContainer);
					
					flashCompanion.init();
					flashCompanion.start();
				}
			}
		}
		
		/**
		 * The AdsManager raises this event when it requests the publisher to pause
		 * the content.
		 */
		private function contentPauseRequestedHandler(event:AdEvent):void 
		{
			if(_isAdClicked){
				adsManager.resume();
				_isAdClicked	= false; //reset after each ad click
			}
			
			log("contentPauseRequestedHandler	"+playerIsPlaying);
			// The ad will cover a large portion of the content, therefore content
			// must be paused.
			if(!_contentComplete)
				if (playerIsPlaying || _isAdRule) 
				{log("sendNotification(NotificationType.DO_PAUSE)");
					_mediator.sendNotification(NotificationType.DO_PAUSE);
				}
			
			// Rewire controls to affect ads manager instead of the content video.
			//enableLinearAdControls();
			// Ads usually do not allow scrubbing.
			//canScrub = false; 
		}
		
		/**
		 * The AdsManager raises this event when it requests the publisher to resume
		 * the content.
		 */
		private function contentResumeRequestedHandler(event:AdEvent	= null):void 
		{	
			adInProgress		= false;
			
			if(_background.parent)
				_background.parent.removeChild(_background);
			
			log("contentResumeRequestedHandler	");
			
			// Rewire controls to affect content instead of the ads manager.
			//tell sequence proxy, hey this sequence item is done. do your thang. 
			_mediator.enableControls();
			//we tell it that we're done if the current ad was requested by the sequenceProxy
			if(_sequenceProxy.vo.isInSequence && !event.ad)
				_facade.sendNotification(NotificationType.SEQUENCE_ITEM_PLAY_END);
			else if (event.ad){
				if(!event.ad.linear && _sequenceProxy.vo.isInSequence)
					_facade.sendNotification(NotificationType.SEQUENCE_ITEM_PLAY_END);
			}
			else if (!_mediator.playbackComplete){
				//this is called when there's an adRule and midrolls are complete
				_facade.sendNotification(NotificationType.DO_PLAY);
			}
			
			
			
			
		}
		
		/**
		 * Errors that occur during ads manager play should be treated as
		 * informational signals. The SDK will send all ads completed event if there
		 * are no more ads to display.
		 */
		private function adsManagerPlayErrorHandler(event:AdErrorEvent):void 
		{
			log("adsManagerPlayErrorHandler	"+event.error.errorMessage);
		}
		
		private function firstQuartileHandler(event:AdEvent):void
		{
			log("firstQuartileHandler");
			_facade.sendNotification("firstQuartile");
		}
		
		private function midpointHandler(event:AdEvent):void
		{
			log("midpointHandler");
			adsManager.resize(this.width, this.height, ViewModes.NORMAL)
			_facade.sendNotification("midpoint");
		}
		
		private function thirdQuartileHandler(event:AdEvent):void
		{
			log("thirdQuartileHandler");
			_facade.sendNotification("thirdQuartile");
		}
		
		public function setSkin(styleName:String, setSkinSize:Boolean=false):void
		{
			
		}
		
		override public function set width(value:Number):void{
			log("has ads MANAGER::: 	"+adsManager);
			if(adsManager && value && this.height)
				resizeManagers(this.width, this.height);
			
			super.width 	= value;
		}
		
		override public function set height(value:Number):void{
			if(adsManager && value && this.width)
				resizeManagers(this.width, this.height);
			
			super.height 	= value;
		}
		
		private function resizeManagers(w:Number,h:Number):void{
			for(var i:int=0;i<_adManagers.length;i++){
				_adManagers[i].resize(w, h, ViewModes.NORMAL);
			}
		}
		
		/**
		 * Function to start playing the plugin content - each plugin implements this differently
		 * 
		 */		
		public function start () : void{
			_mediator.forceStart();
		}
		
		/**
		 *Function returns whether the plugin in question has a sub-sequence 
		 * @return The function returns true if the plugin has a sub-sequence, false otherwise.
		 * 
		 */		
		public function hasSubSequence() : Boolean{return false;}//TODO: CAN THIS BE USED FOR AD PODS? 
		
		/**
		 * Function returns the length of the sub-sequence length of the plugin 
		 * @return The function returns an integer signifying the length of the sub-sequence;
		 * 			If the plugin has no sub-sequence, the return value is 0.
		 */		
		public function subSequenceLength () : int{return 0;}//TODO: LOOK INTO USAGE FOR AD POD
		
		/**
		 * Returns whether the Sequence Plugin plays within the KDP or loads its own media over it. 
		 * @return The function returns <code>true</code> if the plugin media plays within the KDP
		 *  and <code>false</code> otherwise.
		 * 
		 */		
		public function hasMediaElement () : Boolean{return false;}
		
		/**
		 * Function for retrieving the entry id of the plugin media
		 * @return The function returns the entry id of the plugin media. If the plugin does not play
		 * a kaltura-based entry, the return value is the URL of the media of the plugin.
		 */		
		public function get entryId () : String
		{
			return _mediaProxy.vo.entry.id;
		}
		
		
		/**
		 * Function for retrieving the source type of the plugin media (url or entryId) 
		 * @return If the plugin plays a Kaltura-Based entry the function returns <code>entryId</script>.
		 * Otherwise the return value is <code>url</script>
		 * 
		 */		
		public function get sourceType () : String{return "url";}
		/**
		 * Function to retrieve the MediaElement the plugin will play in the KDP. 
		 * @return returns the MediaElement that the plugin will play in the KDP. 
		 * 
		 */		
		public function get mediaElement () : Object{return new Object()}
		
		/**
		 * Function for determining where to place the ad in the pre sequence; 
		 * @return The function returns the index of the plugin in the pre sequence; 
		 * 			if the plugin should not appear in the pre-sequence, return value is -1.
		 */		
		public function get preIndex () : Number{return Number(preSequence);}
		
		/**
		 *Function for determining where to place the plugin in the post-sequence. 
		 * @return The function returns the index of the plugin in the post-sequence;
		 * 			if the plugin should not appear in the post-sequence, return value is -1.
		 */		
		public function get postIndex () : Number{return Number(postSequence);}
		
		
		
		public function log(message:String):void{
			if(debugMode)
				trace("[DOUBLECLICK] : "+message);
		}
		
		
	}
}