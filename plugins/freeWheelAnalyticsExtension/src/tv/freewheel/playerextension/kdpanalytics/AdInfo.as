package tv.freewheel.playerextension.kdpanalytics
{
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import tv.freewheel.logging.Logger;
	
	public class AdInfo
	{	
		private static const UNKNOWN_AD_ID:int = 0;  // same as IEvent.adId's default value.
		private static const UNKNOWN_AD_TYPE:String = "unknown";
		
		private static const PARAM_CREATIVE_NAME:String = "_fw_creative_name";
		private static const PARAM_AD_UNIT_NAME:String = "_fw_ad_unit_name";
		private static const PARAM_ADVERTISER_NAME:String = "_fw_advertiser_name";
		private static const PARAM_SUBCATEGORY_NAME:String = "_fw_campaign_name";
		
		private static const AD_TYPE_PAUSE:String = "pause";
		private static const AD_TYPE_MIDROLL:String = "midroll";
		private static const AD_TYPE_INTERACTIVE:String = "interactive";
		private static const AD_TYPE_BRANDEDSLATE:String = "brandedslate";
		private static const AD_TYPE_PREROLL:String = "preroll";
		private static const AD_TYPE_POSTROLL:String = "postroll";
		private static const AD_TYPE_BUG:String = "bug";
		private static const AD_TYPE_OVERLAY:String = "overlay";
		
		private var constants:Object;
		private var dispatcher:Sprite;
		private var slot:Object;
		private var adProgressTimer:Timer;
		private var playheadTimeOffset:Number;
		
		public var adId:int = UNKNOWN_AD_ID;
		public var duration:Number;
		public var title:String;
		public var uniqueURL:String;
		public var type:String = UNKNOWN_AD_TYPE;
		public var adURL:String;
		public var category:String;
		public var subCategory:String;
		public var clickThru:String;
		public var playheadTime:Number = 0;
		public var customData:String;
		public var basUnit:String;
		
		public function AdInfo(dispatcher:Sprite, slot:Object, adId:int, creativeId:int, constants:Object, customData:String)
		{
			Logger.current.debug("new AdInfo(): slotCustomId: " + slot.getCustomId());
			this.dispatcher = dispatcher;
			this.constants = constants;
			this.slot = slot;
			var slotPlayheadTime:Number = slot.getPlayheadTime();
			this.playheadTimeOffset = slotPlayheadTime >= 0 ? slotPlayheadTime : 0;
			Logger.current.debug("playheadTimeOffset: " + this.playheadTimeOffset);
			
			this.adId = adId;
			this.uniqueURL = this.adId.toString() + creativeId.toString();
			
			var firstInstance:Object = this.getFirstInstanceWithAdId(slot, adId);
			var lastInstance:Object = this.getLastInstanceWithAdId(slot, adId);
			
			this.clickThru = lastInstance.getEventCallbackURLs(this.constants.EVENTCALLBACK_DEFAULTCLICK)[0];
			
			this.title = firstInstance.getCreativeParameter(PARAM_CREATIVE_NAME);
			this.category = firstInstance.getCreativeParameter(PARAM_ADVERTISER_NAME);
			this.subCategory = firstInstance.getCreativeParameter(PARAM_SUBCATEGORY_NAME);
			this.customData = firstInstance.getCreativeParameter(freeWheelAnalyticsExtension.PARAM_NAMESPACE + '.' + freeWheelAnalyticsExtension.PARAM_CUSTOM_DATA)
				|| firstInstance.getCreativeParameter(freeWheelAnalyticsExtension.PARAM_LEGACY_NAMESPACE + '.' + freeWheelAnalyticsExtension.PARAM_CUSTOM_DATA)
				|| firstInstance.getCreativeParameter(freeWheelAnalyticsExtension.PARAM_CUSTOM_DATA)
				|| customData;
			
			var lastPrimaryCreativeRendition:Object = lastInstance.getPrimaryCreativeRendition();
			if (lastPrimaryCreativeRendition){
				this.duration = lastPrimaryCreativeRendition.getDuration();
				this.type = this.getAdType(this.slot, lastPrimaryCreativeRendition, lastInstance.getCreativeParameter(PARAM_AD_UNIT_NAME));
				this.basUnit = lastPrimaryCreativeRendition.getBaseUnit();
				var asset:Object = lastPrimaryCreativeRendition.getPrimaryCreativeRenditionAsset();
				if (asset)
					this.adURL = asset.getURL();
			}
			this.dispatchEvent(CustomEvent.newAdStartEvent(this));
			
			this.startAdTimer();
		}
		
		private function dispatchEvent(evt:CustomEvent):void{
			Logger.current.debug("dispatchEvent()");
			if (this.dispatcher)
				this.dispatcher.dispatchEvent(evt);
			else{
				Logger.current.warn("dispatch failed because dispatcher is unavailable.");
			}
		}
		
		private function startAdTimer():void{
			Logger.current.debug("startAdTimer()");
			this.adProgressTimer = new Timer(1000);
			this.adProgressTimer.addEventListener(TimerEvent.TIMER, onAdProgressTimerEvent);
			this.adProgressTimer.start();
		}
		
		private function stopAdTimer():void{
			Logger.current.debug("stopAdTimer()");
			if (this.adProgressTimer){
				this.adProgressTimer.stop();
				this.adProgressTimer.removeEventListener(TimerEvent.TIMER, onAdProgressTimerEvent);
				this.adProgressTimer = null;
			}
		}
		
		private function onAdProgressTimerEvent(evt:TimerEvent):void{
			Logger.current.debug("onAdProgressTimerEvent()");
			if (this.shouldDispatchProgressEvent()){
				var slotPlayheadTime:Number = this.slot.getPlayheadTime();
				if (slotPlayheadTime < 0){
					Logger.current.debug("Not a valid playhead time, skip sending adProgress event.");
					return;
				}
				this.playheadTime = this.slot.getPlayheadTime() - this.playheadTimeOffset;
				
				if (this.playheadTime < 0){
					this.playheadTime = 0;
				}
				if (this.playheadTime > this.duration)
					this.playheadTime = this.duration;
				Logger.current.debug("Current ad playhead time: " + this.playheadTime);
				this.dispatchEvent(CustomEvent.newAdProgressEvent(this));
			}
		}
		
		public function pause():void{
			Logger.current.debug("pause()");
			if (this.adProgressTimer)
				this.adProgressTimer.stop();
		}
		
		public function resume():void{
			Logger.current.debug("resume()");
			if (this.adProgressTimer)
				this.adProgressTimer.start();
		}
		
		public function click():void{
			Logger.current.debug("click()");
			this.dispatchEvent(CustomEvent.newAdClickEvent(this));
		}
		
		public function complete():void{
			Logger.current.debug("complete()");
			this.dispatchEvent(CustomEvent.newAdCompleteEvent(this));
			this.stopAdTimer();
		}
		
		private function shouldDispatchProgressEvent():Boolean{
			return [AD_TYPE_PREROLL, AD_TYPE_MIDROLL, AD_TYPE_POSTROLL, AD_TYPE_BRANDEDSLATE].indexOf(this.type) > -1;
		}
		
		private function getFirstInstanceWithAdId(slot:Object, adId:int):Object{
			Logger.current.debug("getFirstRenditionWithAdId() slotId: " + slot.getCustomId() + ", adId: " + adId);
			var adInstances:Array = slot.getAdInstances();
			
			for (var i:int = 0; i < adInstances.length; i++){
				var adInstance:Object = adInstances[i];
				if (adInstance.getAdId() == adId){
					return adInstance;
				}
			}
			return null;
		}
		
		private function getLastInstanceWithAdId(slot:Object, adId:int):Object{
			Logger.current.debug("getLastRenditionWithAdId() slotId: " + slot.getCustomId() + ", adId: " + adId);
			var adInstances:Array = slot.getAdInstances();
			
			for (var j:int = adInstances.length - 1; j >= 0; j--){
				var adinstance:Object = adInstances[j];
				if (adinstance.getAdId() == adId){
					return adinstance;
				}
			}
			return null;
		}
		
		private function getAdType(slot:Object, rendition:Object, adUnitName:String = ""):String{
			var type:String = "";
			var timePositionClass:String = slot.getTimePositionClass();
			Logger.current.debug("getAdType(): tpc: " + timePositionClass);
			switch (timePositionClass){
				case this.constants.TIME_POSITION_CLASS_MIDROLL:
					if (slot.getTimePosition() == -1){
						type = AD_TYPE_PAUSE;
					}
					else if (rendition.getAdUnit() == "video-click-to-content"){
						type = AD_TYPE_INTERACTIVE;
					}
					else{
						type = AD_TYPE_MIDROLL;
					}
					break;
				
				case this.constants.TIME_POSITION_CLASS_PREROLL:
				case this.constants.TIME_POSITION_CLASS_POSTROLL:
					if (adUnitName == "Video Branded Slate"){
						type = AD_TYPE_BRANDEDSLATE;
					}
					else{
						type = timePositionClass == this.constants.TIME_POSITION_CLASS_PREROLL ? AD_TYPE_PREROLL : AD_TYPE_POSTROLL;
					}
					break;
				
				case this.constants.TIME_POSITION_CLASS_OVERLAY:
					if (adUnitName == "Overlay Bug"){
						type = AD_TYPE_BUG;
					}
					else{
						type = AD_TYPE_OVERLAY;
					}
					break;
				case this.constants.TIME_POSITION_CLASS_PAUSE_MIDROLL:
					type = AD_TYPE_PAUSE;
					break;
				
				default:
					break;
			}
			Logger.current.debug("getAdType(): " + type);
			return type;
		}
	}
}