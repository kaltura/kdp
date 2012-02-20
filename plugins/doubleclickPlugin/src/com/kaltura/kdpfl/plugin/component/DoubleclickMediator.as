package com.kaltura.kdpfl.plugin.component
{
	import com.kaltura.kdpfl.model.MediaProxy;
	import com.kaltura.kdpfl.model.SequenceProxy;
	import com.kaltura.kdpfl.model.type.NotificationType;
	import com.kaltura.kdpfl.model.type.SequenceContextType;
	import com.kaltura.puremvc.as3.patterns.mediator.SequenceMultiMediator;
	import com.kaltura.types.KalturaAdProtocolType;
	import com.kaltura.types.KalturaAdType;
	import com.kaltura.vo.KalturaAdCuePoint;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class DoubleclickMediator extends SequenceMultiMediator
	{
		
		/**
		 * mediator name 
		 */		
		public static const NAME:String = "doubleclickMediator";
		public static const AD_PROVIDER : String = "doubleclick"; 
		
		public static const DISPATCH_BEACON:String	= "dispatchBeacon";
		public static const INIT_AD_MANAGER:String	= "initAdManager";
		public static const PLAY_AD:String			= "initAd";
		public static const INIT_POSTROLL:String	= "initPostRoll";
		public static const INIT_PREROLL:String		= "initPreRoll";
		public static const INIT_MIDROLL:String		= "initMidRoll";
		public static const INIT_ADRULE:String		= "initAdRule";
		// DO NOT change the following consts values, they match the ones in statistics plugin
		public static const PRE:String = "preroll";
		public static const MID:String = "midroll";
		public static const POST:String = "postroll";
		
		
		/**
		 * DoubleClick program id
		 */
		public var progId:String = "";
		
		/**
		 * DoubleClick Log level. <br/>
		 * optional values: ALL, DEBUG, INFO, WARN, ERROR and FATAL
		 */
		public var traces:String = "";
		
		/**
		 * current ad context. 
		 * possible values are preroll / midroll / postroll. 
		 */
		private var _adContext:String = DoubleclickMediator.MID;
		
		/**
		 * title of current media entry 
		 */		
		private var _entryTitle:String = "";
		
		/**
		 * id of current media entry 
		 */		
		private var _entryId:String = "";
		
		/**
		 * url of current media entry 
		 */		
		private var _entryUrl:String = "";
		
		/**
		 * current player volium 
		 */		
		private var _currentVolume:Number = 100;
		
		/**
		 * indicates the video had started playing and asked for prerolls
		 */		
		private var _requestAd:Boolean;
		
		/**
		 * indicates ads program is loaded 
		 */		
		private var _programLoaded:Boolean = false;
		
		/**
		 * since the new enableGui mechanism in KDP counts calls to 
		 * enable/disable gui, use this to not call too many of any of them. 
		 */
		private var _controlsEnabled:Boolean = true;
		/**
		 * init manager once only. 
		 */		
		private var _managerInit:Boolean = false;
		
		public var eventDispatcher:EventDispatcher	= new EventDispatcher();
		private var _plugin:doubleclickPluginCode;
		public function DoubleclickMediator(code:doubleclickPluginCode)
		{
			_plugin					= code;
			super(NAME);
		}
		
		/**
		 * Hook to the relevant KDP notifications
		 */
		override public function listNotificationInterests():Array
		{
			
			var notificationsArray:Array =  [preSequenceNotificationStartName,
				postSequenceNotificationStartName,
				NotificationType.ROOT_RESIZE,
				NotificationType.CHANGE_MEDIA,
				NotificationType.MEDIA_READY,
				NotificationType.AD_OPPORTUNITY,
				NotificationType.ENABLE_GUI,
				NotificationType.PLAYBACK_COMPLETE,
				NotificationType.CHANGE_MEDIA_PROCESS_STARTED,
				NotificationType.VOLUME_CHANGED
			];
			return notificationsArray;
		}
		
		/**
		 * @inheritDocs
		 */		
		private var _isNewLoad:Boolean	= false;
		private var _played:Boolean		= false;
		private var _lastId:String		= "";
		private var _lastSeek:Number;
		
		private var sequenceProxy:SequenceProxy;
		override public function handleNotification(note:INotification):void {
			var kc:Object = facade.retrieveProxy("servicesProxy")["kalturaClient"];
			var config:Object = facade.retrieveProxy("configProxy");
			var media:Object = facade.retrieveProxy("mediaProxy");
			if (!sequenceProxy)
				sequenceProxy = facade.retrieveProxy(SequenceProxy.NAME) as SequenceProxy;
			var data:Object = note.getBody();
			switch (note.getName()) {
				case NotificationType.PLAYER_UPDATE_PLAYHEAD:
					if (media["vo"]["entry"]["duration"] && !sequenceProxy["vo"]["isInSequence"]) {
						setPlayhead(data as Number, media["vo"]["entry"]["duration"]);
					}
					break;
				case NotificationType.CHANGE_MEDIA_PROCESS_STARTED:
					if (!sequenceProxy.vo.isInSequence )
					{
						sequenceProxy.populatePrePostArr();
					}
					break;
				case NotificationType.VOLUME_CHANGED:
					setVolume(data.newVolume);
					this.eventDispatcher.dispatchEvent(new Event(NotificationType.VOLUME_CHANGED));
					break;
				case NotificationType.ENABLE_GUI:
					_controlsEnabled = (data.guiEnabled	== true)?true:false;
					break;
				case NotificationType.CHANGE_MEDIA:
					initAdManager();
					break;
				case NotificationType.PLAYBACK_COMPLETE:
					this.eventDispatcher.dispatchEvent(new Event(NotificationType.PLAYBACK_COMPLETE));
					break;
				case NotificationType.AD_OPPORTUNITY:
					trace("MY CUEPOINT:::::: 		"+
						note.getBody().cuePoint.title, 
						note.getBody().cuePoint.protocolType,
						note.getBody().cuePoint.sourceUrl,
						note.getBody().cuePoint.adType,
						note.getBody().cuePoint.endTime,
						note.getBody().cuePoint.duration);					
					//if adTagURL exists ignore cuepoints from the KMC. 
					//doubleclick will monitor netstream to display ads base on the netstream. 
					if(!_plugin.adTagUrl)
						onAdOpportunity(note.getBody());
					break;
			}
		}
		
		private function onAdOpportunity(cpData:Object):void{
			if (_plugin.trackCuePoints == "true" && cpData.cuePoint.title == AD_PROVIDER)
			{
				_adContext = cpData.context;
				
				var cuePoint : KalturaAdCuePoint = cpData.cuePoint as KalturaAdCuePoint;
				switch ( _adContext )
				{
					case SequenceContextType.PRE:
						if (cuePoint.adType == KalturaAdType.VIDEO)
						{
							//_plugin.prerollUrlArr.push( cuePoint.sourceUrl );
							if ( cuePoint.adType == KalturaAdType.VIDEO)
							{
								_plugin.adOppTagUrl	= cuePoint.sourceUrl;
								_plugin.adType		= "video";
								sequenceProxy.vo.preSequenceArr.push(_plugin);
							}
							else if(cuePoint.adType == KalturaAdType.OVERLAY)
							{
								sendNotification ("changeOverlayDisplayDuration" , {newDuration : (cuePoint.endTime - cuePoint.startTime)});
								_plugin.adType		= "text_or_graphical"; //covers text overlays, text full slot, graphical overlay, or graphical full slot ads.
								_plugin.adOppTagUrl	= cuePoint.sourceUrl;
								_plugin.loadNonLinearAd();
							}
						}
						break;
					case SequenceContextType.POST:
						if (cuePoint.adType == KalturaAdType.VIDEO)
						{
							//_plugin.postrollUrlArr.push( cuePoint.sourceURL );
							sequenceProxy.vo.postSequenceArr.push(_plugin);
						}
						break;
					case SequenceContextType.MID:
						resolveMidrollAd( cuePoint , sequenceProxy);
						break;                                                                                                                                                                             
				}
			}
		}
		
		private function initAdManager():void {
			//_managerInit = true;
			eventDispatcher.dispatchEvent(new Event(NotificationType.CHANGE_MEDIA));
		}
		
		
		private function resolveMidrollAd( midrollObject : KalturaAdCuePoint , sequenceProxy: SequenceProxy) : void
		{
			//check if this is a video or an overlay
			if ( midrollObject.adType == KalturaAdType.VIDEO)
			{
				sendNotification( NotificationType.DO_PAUSE );
				sequenceProxy.vo.midrollArr.push(_plugin);
				_plugin.adType		= "video";
				_plugin.adTagUrl	= midrollObject.sourceUrl;
			}
			else
			{
				sendNotification ("changeOverlayDisplayDuration" , {newDuration : (midrollObject.endTime - midrollObject.startTime)});
				
				_plugin.adType		= "overlay";
				_plugin.adTagUrl	= midrollObject.sourceUrl;
				_plugin.loadNonLinearAd();
			}
		}
		
		
		//////////////////////////////////////////////////////////////////////////////////////
		//Player properties changed
		/////////////////////////////////////////////////////////////////////////////////////		
		/**
		 * Update the doubleclick component on playhead changes.
		 * @param currentPosition playhead current position
		 * @param duration the length of the movie
		 */
		private function setPlayhead(currentPosition:Number, duration:Number):void {
			trace("TIMELINE PLAYHEAD:::	"+currentPosition, duration);
		}
		
		/**
		 * Update the doubleclick component on volume changes.
		 * @param volume the new volume (0 to 1 scale)
		 */
		public function setVolume(volume:Number):void {
			_currentVolume = volume;
		}
		
		public function getVolume():Number{
			return _currentVolume;
		}
		
		
		/**
		 * show preroll ads
		 */
		private function preAds():void {
			disableControls();
			_adContext = DoubleclickMediator.PRE;
			eventDispatcher.dispatchEvent(new Event(INIT_PREROLL));
		}
		
		
		/**
		 * show postroll ads
		 */
		private function postAds():void {
			disableControls();
			_adContext = DoubleclickMediator.POST;
			eventDispatcher.dispatchEvent(new Event(INIT_POSTROLL));
		}
		
		public function pauseDisablePlayer():void{
			disableControls();
			facade.sendNotification("doPause");
		}
		
		public function playEnablePlayer():void{
			facade.sendNotification("enableGui", {guiEnabled: true, enableType: "full"});
			facade.sendNotification("doPlay");
		}
		
		private function adRule():void{
			disableControls();
			eventDispatcher.dispatchEvent(new Event(INIT_ADRULE));
		}
		
		/**
		 * show midroll ads
		 */
		private function midAds():void {
			disableControls();
			_adContext = DoubleclickMediator.MID;
			eventDispatcher.dispatchEvent(new Event(INIT_MIDROLL));
		}
		
		
		private function disableControls():void {
			if (_controlsEnabled) 
				facade.sendNotification("enableGui", {guiEnabled: false, enableType: "full"});
		}
		
		
		private function sendBeacon(event:String):void{
			eventDispatcher.dispatchEvent(new Event(event));
		}
		
		public function forceStart():void{
			var sequenceManager:IProxy = facade.retrieveProxy("sequenceProxy");
			if (sequenceManager["sequenceContext"] == SequenceContextType.PRE) {
				preAds();//facade.sendNotification(preSequenceNotificationStartName);
			} else if (sequenceManager["sequenceContext"] == SequenceContextType.POST) {
				postAds();//facade.sendNotification(postSequenceNotificationStartName);
			}else if (sequenceManager["sequenceContext"] == SequenceContextType.MID){
				midAds();
			}
		}
	}
}