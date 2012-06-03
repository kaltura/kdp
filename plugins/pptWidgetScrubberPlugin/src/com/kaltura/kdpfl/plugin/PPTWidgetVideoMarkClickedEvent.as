package com.kaltura.kdpfl.plugin
{
	import flash.events.Event;

	public class PPTWidgetVideoMarkClickedEvent extends Event
	{
		public static const EVENT_VIDEO_MARK_CLICKED:String = "videoMarkClicked";
		
		public var videoMarkTime:Number;
		public var slideIndex:uint;
		
		public function PPTWidgetVideoMarkClickedEvent(videoMarkTime:Number, slideIndex:uint, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(EVENT_VIDEO_MARK_CLICKED, bubbles, cancelable);
			
			this.videoMarkTime = videoMarkTime;
			this.slideIndex = slideIndex;
		}
		
	}
}