package com.kaltura.kdpfl.plugin.component
{
	import com.kaltura.kdpfl.model.MediaProxy;
	import com.kaltura.kdpfl.model.SequenceProxy;
	import com.kaltura.kdpfl.model.type.AdsNotificationTypes;
	import com.kaltura.kdpfl.model.type.NotificationType;
	import com.kaltura.kdpfl.model.type.SequenceContextType;
	import com.kaltura.puremvc.as3.patterns.mediator.SequenceMultiMediator;
	import com.kaltura.types.KalturaAdType;
	import com.kaltura.vo.KalturaAdCuePoint;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.mediator.Mediator;
	import org.puremvc.as3.patterns.observer.Notification;
	
	public class DoubleclickMediator extends SequenceMultiMediator
	{
		
		/**
		 * mediator name 
		 */		
		public static const NAME:String = "DoubleclickMediator";
		public static const AD_PROVIDER : String = "doubleclick"; 
		
		public static const DISPATCH_BEACON:String	= "dispatchBeacon";
		public static const INIT_AD_MANAGER:String	= "initAdManager";
		public static const PLAY_AD:String			= "initAd";
		public static const INIT_POSTROLL:String	= "initPostRoll";
		public static const INIT_PREROLL:String		= "initPreRoll";
		public static const INIT_MIDROLL:String		= "initMidRoll";
		// DO NOT change the following consts values, they match the ones in statistics plugin
		public static const PRE:String = "preroll";
		public static const MID:String = "midroll";
		public static const POST:String = "postroll";
		
		private var _plugin:doubleclickPluginCode;
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
		private var _adContext:String = MID;
		
		/**
		 * url of current media entry 
		 */		
		private var _entryUrl:String = "";
		
		/**
		 * current player volume
		 */		
		private var _currentVolume:Number = 100;
		
		/**
		 * since the new enableGui mechanism in KDP counts calls to 
		 * enable/disable gui, use this to not call too many of any of them. 
		 */
		private var _controlsEnabled:Boolean = true;
		/**
		 * init manager once only. 
		 */		
		private var _managerInit:Boolean = false;
		
		private var sequenceProxy:SequenceProxy;
		
		private var _mediaProxy:MediaProxy;
		
		public var eventDispatcher:EventDispatcher	= new EventDispatcher();
		
		public var playheadTime:Number			= -1;
		
		/**
		 * did playback complete? 
		 * **/
		private var _playbackComplete:Boolean		= false;
		
		/**
		 * Sometimes doReplay is not sent so we track our own replay
		 * **/
		private var _isReplay:Boolean				= false;
		
		public function DoubleclickMediator(p:*)
		{
			_plugin	= p;
			
			super(_plugin);
			
			sequenceProxy		= (facade.retrieveProxy("sequenceProxy") as SequenceProxy);
			_mediaProxy			= (facade.retrieveProxy("mediaProxy") as MediaProxy);
		}
		/**
		 since this class extends Mediator, and mediator extends Notifier, you have access to the sendNotification 
		 **/
		override public function listNotificationInterests():Array
		{
			
			var notes:Array =  [preSequenceNotificationStartName,
				postSequenceNotificationStartName,
				NotificationType.PLAYER_PLAYED,
				NotificationType.ROOT_RESIZE,
				NotificationType.CHANGE_MEDIA,
				NotificationType.MEDIA_READY,
				NotificationType.ENABLE_GUI,
				NotificationType.PLAYBACK_COMPLETE,
				NotificationType.CHANGE_MEDIA_PROCESS_STARTED,
				NotificationType.VOLUME_CHANGED,
				NotificationType.DO_PLAY,
				NotificationType.PLAYER_UPDATE_PLAYHEAD,
				NotificationType.OPEN_FULL_SCREEN,
				NotificationType.CLOSE_FULL_SCREEN,
				NotificationType.HAS_CLOSED_FULL_SCREEN,
				NotificationType.HAS_OPENED_FULL_SCREEN,
				NotificationType.ROOT_RESIZE,
				"adStarted"
			];
			
			if(_plugin.trackCuePoints)
				notes.push(NotificationType.AD_OPPORTUNITY);
			
			return notes;
		}
		
		override public function handleNotification(notification:INotification):void
		{
			var data:Object = notification.getBody();
			
			
			switch(notification.getName())
			{
				case NotificationType.HAS_OPENED_FULL_SCREEN:
					eventDispatcher.dispatchEvent(new Event(NotificationType.ROOT_RESIZE));
					break;
				case NotificationType.HAS_CLOSED_FULL_SCREEN:
					eventDispatcher.dispatchEvent(new Event(NotificationType.ROOT_RESIZE));
					break;
				case NotificationType.PLAYER_UPDATE_PLAYHEAD:
					//correct the 1 sec delay on ads during adrule playback
					playheadTime = (Number(data)) * 1000;
					break;
				case NotificationType.PLAYER_PLAYED:
					_plugin.playerIsPlaying	= true;
					break;
				case NotificationType.ENABLE_GUI:
					_controlsEnabled = (data.guiEnabled	== true)?true:false;
					break;
				case NotificationType.AD_OPPORTUNITY:
					trace("[DOUBLECLICK] - cuepoint:::::: 		 "+
						notification.getBody().cuePoint.title, 
						notification.getBody().cuePoint.protocolType,
						notification.getBody().cuePoint.sourceUrl,
						notification.getBody().cuePoint.adType,
						notification.getBody().cuePoint.endTime,
						notification.getBody().cuePoint.duration);					 
					//					if(!_plugin.adTagUrl)
					onAdOpportunity(notification.getBody());
					break;				
				case NotificationType.VOLUME_CHANGED:
					_plugin.adsManager.volume = data.newVolume as Number;
					break;
				case NotificationType.CHANGE_MEDIA:
					eventDispatcher.dispatchEvent(new Event(NotificationType.CHANGE_MEDIA));
					_entryUrl					= data.entryId;
					_playbackComplete			= false;
					_adContext					= "";
					break;
				case NotificationType.PLAYBACK_COMPLETE:
					eventDispatcher.dispatchEvent(new Event(NotificationType.PLAYBACK_COMPLETE));
					_playbackComplete			= true;
					_isReplay					= false;
					break;
				case NotificationType.DO_PLAY:
					//work around for race condition where playback fires off while an adRule(pre) is in progress.
					if(_plugin.adInProgress){
						stopPlayback();
					}
					
					//if playback completed and the current entryID matches the server id and isReplay hasn't been set
					//then this must be a replay
					if(	_playbackComplete && 
						_entryUrl == _mediaProxy.vo.entry.id && 
						!_isReplay){
						playheadTime		= 	0;
						_isReplay			= true;
						_playbackComplete	= false;
						eventDispatcher.dispatchEvent(new Event(NotificationType.DO_REPLAY));
					}
					
					break;
			}
		}
		
		public function stopPlayback():void{
			facade.sendNotification(NotificationType.DO_PAUSE);
			disableControls();
		}
		
		private function onAdOpportunity(cpData:Object):void{
			
			var isDoubleclick:Boolean	= false;
			
			if(!isDoubleclick)
				isDoubleclick		= (String(cpData.cuePoint.tags).toLowerCase() == AD_PROVIDER)
			
			if(!isDoubleclick)
				isDoubleclick		= (String(cpData.cuePoint.title).toLowerCase().indexOf("doubleclick") > -1);
			
			if (_plugin.trackCuePoints && isDoubleclick)
			{
				_adContext = cpData.context;
				
				var cuePoint : KalturaAdCuePoint = cpData.cuePoint as KalturaAdCuePoint;
				
				switch ( _adContext )
				{
					case SequenceContextType.PRE:
						if ( cuePoint.adType == KalturaAdType.VIDEO)
						{
							_plugin.cpAdTagUrl	= cuePoint.sourceUrl;
							//								_plugin.adType		= "video";
							sequenceProxy.vo.preSequenceArr.push(_plugin);
							
						}
						else if(cuePoint.adType == KalturaAdType.OVERLAY)
						{
							sendNotification ("changeOverlayDisplayDuration" , {newDuration : (cuePoint.endTime - cuePoint.startTime)});
							//								_plugin.adType		= "text_or_graphical"; //covers text overlays, text full slot, graphical overlay, or graphical full slot ads.
							_plugin.cpAdTagUrl	= cuePoint.sourceUrl;
							_plugin.initAd();
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
		
		private function resolveMidrollAd( midrollObject : KalturaAdCuePoint , sequenceProxy: SequenceProxy) : void
		{
			//check if this is a video or an overlay
			if ( midrollObject.adType == KalturaAdType.VIDEO)
			{
				sequenceProxy.vo.midrollArr.push(_plugin);
				
				_plugin.cpAdTagUrl	= midrollObject.sourceUrl;
			}
			else
			{
				sendNotification ("changeOverlayDisplayDuration" , {newDuration : (midrollObject.endTime - midrollObject.startTime)});
				
				_plugin.cpAdTagUrl	= midrollObject.sourceUrl;
			}
			_plugin.initAd();
		}
		
		
		//force start ad
		public function forceStart():void{
			
			var sequenceManager:IProxy = facade.retrieveProxy("sequenceProxy");
			
			if (sequenceManager["sequenceContext"] == SequenceContextType.PRE) {
				
				preAds();
				
			} else if (sequenceManager["sequenceContext"] == SequenceContextType.POST) {
				
				postAds();
				
			}else if (sequenceManager["sequenceContext"] == SequenceContextType.MID){
				
				midAds();
				
			}
			
		}
		/**
		 * Update the doubleclick component on volume changes.
		 * @param volume the new volume (0 to 1 scale)
		 **/
		public function setVolume(volume:Number):void {
			_currentVolume = volume;
		}
		
		public function getVolume():Number{
			return _currentVolume;
		}
		
		/**
		 * show postroll ads
		 */
		private function postAds():void {
			_adContext = POST;
			eventDispatcher.dispatchEvent(new Event(INIT_POSTROLL));
		}
		
		
		/**
		 * show midroll ads
		 */
		private function midAds():void {
			_adContext = MID;
			eventDispatcher.dispatchEvent(new Event(INIT_MIDROLL));
		}
		
		/**
		 * show preroll ads
		 */
		private function preAds():void {
			_adContext = PRE;
			eventDispatcher.dispatchEvent(new Event(INIT_PREROLL));
		}
		
		public function disableControls():void {
			if (_controlsEnabled) 
				facade.sendNotification("enableGui", {guiEnabled: false, enableType: "full"});
		}
		
		public function enableControls():void{
			if (!_controlsEnabled) 
				facade.sendNotification("enableGui", {guiEnabled: true, enableType: "full"});
		}
		
		public function get adContext():String{
			return _adContext;
		}
		
		public function get playbackComplete():Boolean{
			return _playbackComplete;
		}
		
		public function get isReplay():Boolean{
			return _isReplay;
		}
	}
}
