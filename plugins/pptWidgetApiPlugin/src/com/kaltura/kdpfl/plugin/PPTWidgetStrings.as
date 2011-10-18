package com.kaltura.kdpfl.plugin
{
	import com.kaltura.kdpfl.model.strings.MessageStrings;

	public class PPTWidgetStrings 
	{
		private static var _flashvars : Object;
		
		public static var PPTWIDGET_SAVE_CHANGES_TITLE:String = "Confirm";
		
		public static var PPTWIDGET_SAVE_CHANGES_TEXT:String = "Do you want to save changes?";
		
		public static var PPTWIDGET_ALERT_BUTTON_LABEL_YES:String = "Yes";
		
		public static var PPTWIDGET_ALERT_BUTTON_LABEL_NO:String = "No";
		
		public static var PPTWIDGET_GENERIC_TITLE:String = "Message";
		
		public static var PPTWIDGET_GENERIC_ERROR_TITLE:String = "Error";
		
		public static var PPT_SWF_NOT_FOUND_TITLE:String="Error loading presentation";
		
		public static var PPTWIDGET_GENERIC_ERROR_MESSAGE:String = "An error occurred";
		
		public static var PPTWIDGET_SYNC_ENTRY_NOT_FOUND_MESSAGE:String = "Sync entry not found";
		
		public static var PPTWIDGET_VIDEO_ENTRY_NOT_FOUND_MESSAGE:String = "Video entry not found";
		
		public static var PPTWIDGET_VIDEO_SLIDE_NOT_FOUND_MESSAGE:String = "Cannot load slides. Path missing from XML.";
		
		public static var PPTWIDGET_SAVED_SUCCESSFULLY_MESSAGE:String = "Saved successfully";
		
		public static var PPT_SWF_NOT_FOUND_MESSAGE:String="Slides currently unavailable.";
		
		public static function init (flashvars : Object) : void
		{
			_flashvars = flashvars;
		}
		
		public static function getString(key:String):String
		{
			
			if (_flashvars.hasOwnProperty("strings") && _flashvars["strings"].hasOwnProperty(key))
				return _flashvars["strings"][key];
			
			return PPTWidgetStrings[key];
		}
	}
}