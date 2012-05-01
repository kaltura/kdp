package com.kaltura.kdpfl.model.strings
{
	import com.kaltura.kdpfl.model.ConfigProxy;
	
	import org.puremvc.as3.interfaces.IFacade;
	
	/**
	 * Class MessageStrings holds constants for messages displayed by the KDP.
	 * 
	 */		
	public class MessageStrings
	{
		private static var _flashvars:Object;
		private static var _instance:MessageStrings;
		
		
		/**
		 * Function initiates the class. 
		 * @param o - the KDP flashvars.
		 * 
		 */		
		public static function init(o:Object):void {
			_flashvars = o;
		}
		
		
		
		/**
		 * The function returns the string of a KDP message according to a particular key.
		 * @param key The key of the desired message string.
		 * @return The function returns the required message string according to the key that was passed.
		 * 
		 */		
		public static function getString(key:String):String
		{
			
			if (_flashvars.hasOwnProperty("strings") && _flashvars["strings"].hasOwnProperty(key))
				return _flashvars["strings"][key];
			
			return MessageStrings[key];
		}
		
		// Values of the constant keys.
		private static var UNAUTHORIZED_DOMAIN_TITLE  	: String = "Unauthorized domain";
		private static var UNAUTHORIZED_COUNTRY_TITLE 	: String = "Unauthorized country";
		private static var UNAUTHORIZED_IP_ADDRESS_TITLE 	: String = "Unauthorized IP address";
		private static var OUT_OF_SCHEDULING_TITLE    	: String = "Out of scheduling  ";
		private static var NO_KS_TITLE				 	: String = "No KS where KS is required ";
		private static var USER_AGENT_RESTRICTED_TITLE	: String = "Unauthorized user agent";
		private static var ENTRY_CONVERTING_TITLE     	: String = "Entry is converting";
		private static var ENTRY_REJECTED_TITLE  	 	: String = "Entry is rejected";
		private static var ENTRY_DELETED_TITLE			: String = "Entry is deleted ";
		private static var ERROR_PROCESSING_MEDIA_TITLE  : String = "Error processing media ";
		private static var FREE_PREVIEW_END_TITLE        : String = "Free Preview is Complete";
		private static var ENTRY_MODERATE_TITLE			: String = "Media is awaiting moderation";
		private static var ENTRY_PRECONVERT_TITLE		: String = "Media is converting";
		private static var ENTRY_IMPORTING_TITLE 		: String = "Media is converting";
		private static var UNKNOWN_STATUS_TITLE			: String = "Unknown Status";
		private static var SERVICE_ERROR					: String = "Service Error";
		private static var CLIP_NOT_FOUND		        : String = "Media not found";
		private static var CLIP_NOT_FOUND_TITLE		    : String = "Sorry, clip not found";
		private static var NO_MIX_PLUGIN_TITLE			: String = "No Mix Plugin";
		private static var SERVICE_GET_EXTRA_ERROR_TITLE : String = "Error Get Extra Data";
		private static var NO_CONTENT_TITLE : String 			= "No Content";
		
		
		private static var UNAUTHORIZED_DOMAIN  			: String = "We're sorry, this content is only available on certain domains.";
		private static var UNAUTHORIZED_COUNTRY 			: String = "We're sorry, this content is only available in certain countries.";
		private static var UNAUTHORIZED_IP_ADDRESS 			: String = "We're sorry, this content is only available for certain IP addresses.";
		private static var OUT_OF_SCHEDULING    			: String = "We're sorry, this content is currently unavailable.";
		private static var NO_KS  				 		: String = "We're sorry, access to this content is restricted. ";
		private static var USER_AGENT_RESTRICTED  			: String = "We're sorry, this content is only available for certain user agents. ";
		private static var ENTRY_CONVERTING     			: String = "Media is currently being converted, please try again in a few minutes.";
		private static var ENTRY_REJECTED  	 			: String = "We're sorry, this content was removed";
		private static var ENTRY_DELETED					: String = "We're sorry, this content is no longer available.";
		private static var ERROR_PROCESSING_MEDIA    	: String = "There was an error processing this media.";
		private static var FREE_PREVIEW_END  			: String = "Access to the rest of the content is restricted.";
		private static var ENTRY_MODERATE    			: String = "This media is currently awaiting moderation, please try again in a few minutes.";
		private static var ENTRY_PRECONVERT				: String = "This media is currently being converted, please try again in a few minutes.";
		private static var ENTRY_IMPORTING				: String = "This media is currently being converted, please try again in a few minutes.";
		private static var UNKNOWN_STATUS				: String = "Unknown status";
		private static var SERVICE_START_WIDGET_ERROR 	: String = "Error in Start Widget Session";
		private static var SERVICE_GET_WIDGET_ERROR 		: String = "Error in Get Widget";
		private static var SERVICE_GET_UICONF_ERROR 		: String = "Error in Get UiConf";
		private static var SERVICE_GET_ENTRY_ERROR 		: String = "Media item not found.";
		private static var SERVICE_GET_EXTRA_ERROR		: String = "Error in get base entry extra data";
		private static var SERVICE_GET_CUSTOM_METADATA_ERROR_MESSAGE: String = "Error retrieving custom metadata."	
		private static var NO_MIX_PLUGIN					: String = "In order to view mix entry, you must add the mix plugin to the UiConf xml";
		private static var NO_CONTENT					: String = "No Content";
	}
}