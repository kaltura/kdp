package com.type
{
	public class ClosedCaptionsNotifications
	{
		/**
		 * toggle closed captions visibility
		 */		
		public static const SHOW_HIDE_CLOSED_CAPTIONS : String = "showHideClosedCaptions";
		
		/**
		 * dispatched when captions file load failed with IOError 
		 */		
		public static const CC_IO_ERROR : String = "ccIOError";
		
		/**
		 * dispatched when failed parsing the loaded captions file
		 */		
		public static const CC_FAILED_TO_VALIDATE : String = "ccFailedToValidate";
		
		/**
		 * dispatched when captions file load failed with 
		 * either async error, security error or general error 
		 */		
		public static const CC_ERROR : String = "ccError";
		
		/**
		 * dispatched when listing closed captions files succeeds 
		 */
		public static const CC_DATA_LOADED : String = "ccDataLoaded";
		
		/**
		 * dispatched when listing closed captions files fails
		 */
		public static const CC_DATA_LOAD_FAILED : String = "ccDataLoadFailed";
		
		/**
		 * reload caption assets 
		 */		
		public static const RELOAD_CAPTIONS	: String = "reloadCaptions";
		
	}
}