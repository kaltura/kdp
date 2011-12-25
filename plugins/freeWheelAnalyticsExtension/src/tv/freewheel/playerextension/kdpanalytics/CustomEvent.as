package tv.freewheel.playerextension.kdpanalytics
{
	import flash.events.Event;
	
	import tv.freewheel.logging.Logger;
	import tv.freewheel.renderer.util.StringUtil;
	
	public class CustomEvent extends Event
	{
		public static const AD_START:String = "adStart";
		public static const AD_PROGRESS:String = "adProgress";
		public static const AD_COMPLETE:String = "adComplete";
		public static const AD_CLICK:String = "adClick";
		public static const AD_INFO_ADDED:String = "adInfoAdded";
		public static const POD_COMPLETE:String = "podComplete";
		public static const POD_START:String = "podStart";
		
		private static const INFO_LENGTH:String = "length";
		private static const INFO_TITLE:String = "title";
		private static const INFO_UNIQUE_URL:String = "uurl";
		private static const INFO_TYPE:String = "type";
		private static const INFO_AD_URL:String = "adurl";
		private static const INFO_CATEGORY:String = "category";
		private static const INFO_SUBCATEGORY:String = "subcategory";
		private static const INFO_POSITION:String = "position";
		private static const INFO_CLICKTHRU:String = "clickurl";
		private static const INFO_DURATION:String = "duration";
		private static const INFO_CUSTOM_DATA:String = "customData";
		
		public var info:Object;
		
		public static var logger:Logger = Logger.getSimpleLogger('KDPAnalyticsExtension: ');
		
		public function CustomEvent(type:String, info:Object = null)
		{
			if (type)
				super(type);
			switch (type){
				case AD_START:
				case AD_PROGRESS:
				case AD_COMPLETE:
				case AD_INFO_ADDED:
				case AD_CLICK:
				case POD_COMPLETE:
				case POD_START:
					this.info = info;
					break;
				default:
					throw new Error("ERROR: " + type + " has not been defined.");
			}
		}
		
		public static function newAdStartEvent(adInfo:AdInfo):CustomEvent{
			var info:Object = new Object();
			info[INFO_LENGTH] = adInfo.duration;
			info[INFO_TITLE] = adInfo.title;
			info[INFO_UNIQUE_URL] = adInfo.uniqueURL;
			info[INFO_TYPE] = adInfo.type;
			info[INFO_AD_URL] = adInfo.adURL;
			info[INFO_CATEGORY] = adInfo.category;
			info[INFO_SUBCATEGORY] = adInfo.subCategory;
			info[INFO_CUSTOM_DATA] = adInfo.customData;
			logger.debug("newAdStartEvent: " + StringUtil.objectToString(info));
			return new CustomEvent(AD_START, info);
		}
		
		public static function newAdProgressEvent(adInfo:AdInfo):CustomEvent{
			var info:Object = new Object();
			info[INFO_POSITION] = adInfo.playheadTime;
			info[INFO_CUSTOM_DATA] = adInfo.customData;
			logger.debug("newAdProgressEvent: " + StringUtil.objectToString(info));
			return new CustomEvent(AD_PROGRESS, info);
		}
		
		public static function newAdCompleteEvent(adInfo:AdInfo):CustomEvent{
			var info:Object = new Object();
			info[INFO_POSITION] = adInfo.playheadTime;
			info[INFO_CUSTOM_DATA] = adInfo.customData;
			logger.debug("newAdCompleteEvent: " + StringUtil.objectToString(info));
			return new CustomEvent(AD_COMPLETE, info);
		}
		
		public static function newAdClickEvent(adInfo:AdInfo):CustomEvent{
			var info:Object = new Object();
			info[INFO_POSITION] = adInfo.playheadTime;
			info[INFO_CLICKTHRU] = adInfo.clickThru;
			info[INFO_CUSTOM_DATA] = adInfo.customData;
			logger.debug("newAdClickEvent: " + StringUtil.objectToString(info));
			return new CustomEvent(AD_CLICK, info);
		}
		
		public static function newPodStartEvent(position:Number, customData:String):CustomEvent{
			var info:Object = new Object();
			info[INFO_POSITION] = position;
			info[INFO_CUSTOM_DATA] = customData;
			logger.debug("newPodStartEvent: " + StringUtil.objectToString(info));
			return new CustomEvent(POD_START, info);
		}
		
		public static function newPodCompleteEvent(position:Number, duration:Number, customData:String):CustomEvent{
			var info:Object = new Object();
			info[INFO_POSITION] = position;
			info[INFO_DURATION] = duration;
			info[INFO_CUSTOM_DATA] = customData;
			logger.debug("newPodCompleteEvent: " + StringUtil.objectToString(info));
			return new CustomEvent(POD_COMPLETE, info);
		}
	}
}