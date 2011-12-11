package com.kaltura.kdpfl.model.type {

	/**
	 * the AdsNotificationTypes class declares constants which are used as 
	 * notification types for ads statistics notifications.
	 */
	public class AdsNotificationTypes {

		/**
		 * defines the value of the type property of a bumper start notification
		 */
		public static const BUMPER_STARTED:String = "bumperStarted";

		/**
		 * defines the value of the type property of a bumper click notification
		 */
		public static const BUMPER_CLICKED:String = "bumperClicked";

		/**
		 * defines the value of the type property of an ad start notification
		 * this notification will have a data object {timeSlot:preroll/postroll/midroll/overlay}
		 */
		public static const AD_START:String = "adStart";

		/**
		 * defines the value of the type property of an ad click notification.
		 * this notification will have a data object {timeSlot:preroll/postroll/midroll/overlay}
		 */
		public static const AD_CLICK:String = "adClick";
		
		/**
		 * defines the value of the type property of an ad end notification.
		 * this notification will have a data object {timeSlot:preroll/postroll/midroll/overlay}
		 */
		public static const AD_END:String = "adEnd";
		
		/**
		 * defines the value of the type property of 25% percents of ad notification.
		 * this notification will have a data object {timeSlot:preroll/postroll/midroll/overlay}
		 */
		public static const FIRST_QUARTILE_OF_AD:String = "firstQuartileOfAd";
		
		/**
		 * defines the value of the type property of 50% percents of ad notification.
		 * this notification will have a data object {timeSlot:preroll/postroll/midroll/overlay}
		 */
		public static const MID_OF_AD:String = "midOfAd";
		
		/**
		 * defines the value of the type property of 75% percents of ad notification.
		 * this notification will have a data object {timeSlot:preroll/postroll/midroll/overlay}
		 */
		public static const THIRD_QUARTILE_OF_AD:String = "ThirdQuartileOfAd";
	}
}