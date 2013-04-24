package com.kaltura.kdpfl.plugin.component
{
	import com.kaltura.kdpfl.ApplicationFacade;
	import com.kaltura.kdpfl.model.SequenceProxy;
	import com.kaltura.kdpfl.model.type.NotificationType;
	import com.kaltura.kdpfl.model.type.SequenceContextType;
	import com.kaltura.puremvc.as3.patterns.mediator.SequenceMultiMediator;
	import com.kaltura.types.KalturaAdProtocolType;
	import com.kaltura.types.KalturaAdType;
	import com.kaltura.vo.KalturaAdCuePoint;
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.puremvc.as3.interfaces.INotification;

	public class VastMediator extends SequenceMultiMediator
	{
		public static const NAME : String = "vastMediator";
		
		public static const VAST_AD_PROVIDER : String = "vast"; 
		
		public var sequenceProxy : SequenceProxy;
		
		private var _shouldPlayPreroll : Boolean = false;
		private var _shouldPlayPostroll : Boolean = false;
		
		private var _reached25:Boolean = false;
		private var _reached50:Boolean = false;
		private var _reached75:Boolean = false;
		private var _loadedFirstOverlayVAST : Boolean = false;
		private var _playedFirstMidroll : Boolean = false;
		private var _pluginCode : vastPluginCode;
		
	//	private var _vastMidrollTimer : Timer;
		
		/**
		 * @copy adContext
		 * */
		private var _adContext:String;
		
		/**
		 * @copy #isListening  
		 */
		private var _isListening : Boolean = false;
		
		/**
		 * Constructor. 
		 * @param pluginCode
		 * @param viewComponent
		 */		
		public function VastMediator(pluginCode : vastPluginCode, viewComponent:Object=null)
		{
			super(viewComponent);
			_pluginCode = pluginCode;
		}
		
		
		override public function listNotificationInterests():Array
		{
			var interests : Array = [
									NotificationType.PLAYER_UPDATE_PLAYHEAD, 
									NotificationType.SEQUENCE_ITEM_PLAY_END,
									NotificationType.OPEN_FULL_SCREEN,
									NotificationType.CLOSE_FULL_SCREEN,
									NotificationType.ENTRY_READY,
									"vastStartedPlaying",
									NotificationType.PLAYER_PAUSED,
									NotificationType.PLAYER_PLAYED,
									NotificationType.AD_OPPORTUNITY,
									NotificationType.CHANGE_MEDIA_PROCESS_STARTED,
									NotificationType.ROOT_RESIZE
									];
			
			return interests;
		}
		
		
		/**
		 * only use notification for stats, where the actual timing doesn't matter.<br/>
		 * <code>adStart</code> and <code>adClick</code> are sent from <code>VastLinearAdProxy</code>.
		 * @param notification
		 */		
		override public function handleNotification(notification:INotification):void
		{
			if (!sequenceProxy)
				sequenceProxy = facade.retrieveProxy(SequenceProxy.NAME) as SequenceProxy;
			
			switch (notification.getName()) {

				case NotificationType.PLAYER_UPDATE_PLAYHEAD:
					if (_isListening) {
						// only listen to notification while active.
						handlePlayhead(notification.getBody());
					}
					else
					{
						if (!_loadedFirstOverlayVAST && _pluginCode.overlayStartAt >= Number(notification.getBody()))
						{
							_loadedFirstOverlayVAST = true;
							_pluginCode.loadNonLinearAd();
							
							if (_pluginCode.overlayInterval)
							{
								var overlayDisplayDuration : Number = _pluginCode["overlayDisplayDuration"] ? _pluginCode["overlayDisplayDuration"] : 5;
								var overlayTimer : Timer = new Timer((_pluginCode["overlayInterval"] + overlayDisplayDuration)*1000 ,1);
								overlayTimer.addEventListener(TimerEvent.TIMER_COMPLETE, loadOverlay );
								overlayTimer.start();
							}
						}
						
						if ( !_playedFirstMidroll && _pluginCode.showFirstMidrollAt && _pluginCode.showFirstMidrollAt <= Number(notification.getBody()) )
						{
							_playedFirstMidroll = true;
							
							_pluginCode.midrollUrlArr.push( _pluginCode.midrollUrl );
							
						/*	if ( _pluginCode.midrollInterval )
							{
								_vastMidrollTimer = new Timer (_pluginCode.midrollInterval);
								
								_vastMidrollTimer.start()
							}*/
							
							startVASTMidroll();
						}
					}
					break;
				case NotificationType.PLAYER_PLAYED:
				//	if (_playedFirstMidroll && _vastMidrollTimer)
				//		_vastMidrollTimer.start();
			
					break;
				case NotificationType.PLAYER_PAUSED:
				//	if (_playedFirstMidroll && _vastMidrollTimer)
				//		_vastMidrollTimer.stop();
					break;
				case "vastStartedPlaying":
					isListening = true;
					break;
				case NotificationType.SEQUENCE_ITEM_PLAY_END:
					if (isListening ) {
						sendNotification("adEnd", {timeSlot:getTimeSlot()});
						_pluginCode["playedPrerollsSingleEntry"] = 0;
						_pluginCode["playedPostrollsSingleEntry"] = 0;
						_pluginCode.finishLinearAd();
						enableGUI(true)
					}
					// stop listening to notifications
					isListening = false;
					break;
				case NotificationType.OPEN_FULL_SCREEN:
					_pluginCode.resize(notification.getBody().width, notification.getBody().height,"fullscreen");
					break;
				case NotificationType.CLOSE_FULL_SCREEN:
					_pluginCode.resize(notification.getBody().width, notification.getBody().height,"normal");
					
					break;
				case NotificationType.ENTRY_READY :
		
					if (!sequenceProxy.vo.isInSequence)
					{
						_loadedFirstOverlayVAST = false;
						_playedFirstMidroll = false;
					}
					break;
				case NotificationType.AD_OPPORTUNITY:
					
					if (_pluginCode.trackCuePoints == "true")
					{
						var adContext : String = notification.getBody().context;
						
						var cuePoint : KalturaAdCuePoint = notification.getBody().cuePoint as KalturaAdCuePoint;
						
						if ( cuePoint.protocolType == KalturaAdProtocolType.VAST || cuePoint.protocolType == KalturaAdProtocolType.VAST_2_0)
						{
							switch ( adContext )
							{
								case SequenceContextType.PRE:
									if (cuePoint.adType == KalturaAdType.VIDEO)
									{
											_pluginCode.prerollUrlArr.push( cuePoint.sourceUrl );
											sequenceProxy.vo.preSequenceArr.push(_pluginCode);
									}
									break;
								case SequenceContextType.POST:
									if (cuePoint.adType == KalturaAdType.VIDEO)
									{
										_pluginCode.postrollUrlArr.push( cuePoint.sourceURL );
										sequenceProxy.vo.postSequenceArr.push(_pluginCode);
									}
									break;
								case SequenceContextType.MID:
									
									resolveMidrollAd( cuePoint , sequenceProxy);
									
									break;                                                                                                                                                                             
							}
						}
					}
						
					break;
					case NotificationType.CHANGE_MEDIA_PROCESS_STARTED:
						
						// Restore previous situation (if existed at all)
						if (_pluginCode.prerollUrl )
						{
							_pluginCode.prerollUrlArr = new Array( _pluginCode.prerollUrl );
						}
						
						if (_pluginCode.postrollUrl)
						{
							_pluginCode.postrollUrlArr = new Array(_pluginCode.postrollUrl);	
						}
						
					break;
				
			}	
			
		}
		
		private function startVASTMidroll (e : TimerEvent = null) : void
		{
			sequenceProxy.vo.midCurrentIndex = 0;
			
			sendNotification( NotificationType.DO_PAUSE );
			
			sequenceProxy.playNextInSequence();
		}
		
		private function resolveMidrollAd( midrollObject : KalturaAdCuePoint , sequenceProxy: SequenceProxy) : void
		{
			if ( midrollObject.adType == KalturaAdType.VIDEO )
			{
				sendNotification( NotificationType.DO_PAUSE );
				
				_pluginCode.midrollUrlArr.push( midrollObject.sourceUrl );
				
				sequenceProxy.vo.midrollArr.push(_pluginCode);
				
			}
			else
			{
				sendNotification ("changeOverlayDisplayDuration" , {newDuration : ((midrollObject.endTime - midrollObject.startTime) / 1000)})
				_pluginCode.loadNonLinearAd( midrollObject.sourceUrl );
			}
		}
		
		private function loadOverlay ( e: TimerEvent) : void
		{
			_pluginCode.loadNonLinearAd();
			(e.target as Timer).start();
		}
		/**
		 * @return	statistics string for current ad context 
		 */		
		private function getTimeSlot():String {
			var res:String;
			switch (adContext) {
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
		
		
		/**
		 * dispatch progress event if needed. 
		 * @param o progress notification body
		 */		
		private function handlePlayhead(o:Object):void {
			var duration:Number = (facade.retrieveMediator("kMediaPlayerMediator"))["player"]["duration"];
			var fraction:Number = (o as Number) / duration;
			if (!_reached25 && fraction > 0.25) {
				sendNotification("firstQuartileOfAd", {timeSlot:getTimeSlot()});
				_reached25 = true;
			}
			else if (!_reached50 && fraction > 0.5){
				sendNotification("midOfAd", {timeSlot:getTimeSlot()});
				_reached50 = true;
			}
			else if (!_reached75 && fraction > 0.75){
				sendNotification("ThirdQueartileOfAd", {timeSlot:getTimeSlot()});
				_reached75 = true;	
			}
		}
		
		
		/**
		 * resets the "reached" variables. 
		 * used when we have more than 1 ad.
		 */		
		public function reset():void {
			_reached25 = false;
			_reached50 = false;
			_reached75 = false;
		}
		
		
		public function get shouldPlayPreroll () : Boolean
		{
			return _shouldPlayPreroll;
		}
		
		public function get shouldPlayPostroll () : Boolean
		{
			return _shouldPlayPreroll;
		}
		
		public function enableGUI (enabled : Boolean) : void
		{
			sendNotification("enableGui", {guiEnabled : enabled, enableType : "full"});
		}

		/**
		 * indicates the mediator is listening to notifications. 
		 */
		public function get isListening():Boolean {
			return _isListening;
		}

		/**
		 * @private
		 */
		public function set isListening(value:Boolean):void {
			if (_isListening != value) {
				_isListening = value;
				if (value) {
					reset();
				}
			}
		}

		/**
		 * current ad context. <br/>
		 * possible values enumerated in <code>SequenceContextType</code> 
		 */		
		public function get adContext():String
		{
			return _adContext;
		}

		/**
		 * @private 
		 */		
		public function set adContext(value:String):void
		{
			_adContext = value;
		}
	
	}
}