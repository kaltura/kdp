package com.kaltura.kdpfl.plugin
{
	import flash.events.Event;

	public class PPTWidgetVideoMarkUpdateEvent extends Event
	{
		public static const EVENT_VIDEO_MARK_UPDATE:String = "videoMarkUpdate";
		
		public var oldTime:Number;
		public var newTime:Number;
		public var slideIndex:uint;
		
		public function PPTWidgetVideoMarkUpdateEvent(oldTime:Number, newTime:Number, slideIndex:uint, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(EVENT_VIDEO_MARK_UPDATE, bubbles, cancelable);
			
			this.oldTime = oldTime;
			this.newTime = newTime;
			this.slideIndex = slideIndex;
		}
		
	}
}