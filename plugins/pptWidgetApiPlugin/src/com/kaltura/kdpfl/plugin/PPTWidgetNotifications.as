package com.kaltura.kdpfl.plugin
{
	public class PPTWidgetNotifications
	{
		
		public static const SLIDES_LOADED:String = "slidesLoaded";
		
		public static const VIDEO_MARKS_RECEIVED:String = "videoMarksReceived";
		
		public static const VIDEO_MARK_ADDED:String = "videoMarkAdded";
		
		public static const VIDEO_MARK_REMOVED:String = "videoMarkRemoved";
		
		public static const PPT_WIDGET_CLOSE:String = "pptWidgetClose";
		
		/**
		 * dispatched when error loading slide 
		 */		
		public static const PPT_SWF_NOT_FOUND:String = "pptSwfNotFound";
		
		/**
		 * dispatched when the entry loaded is not a data entry 
		 * (and therefore the widget cannot work) 
		 */		
		public static const NOT_DATA_ENTRY:String = "pptNotDataEntry";
		
		public static const VIDEO_MARKS_REMOVE_HIGHLIGHTS:String = "videoMarksRemoveHighlights";
		
		public static const VIDEO_MARK_HIGHLIGHT:String = "videoMarkHighlight";
		
		public static const PPT_WIDGET_VIDEO_SLIDE_NOT_FOUND:String = "pptVideoSlideNotFound";
	}
}