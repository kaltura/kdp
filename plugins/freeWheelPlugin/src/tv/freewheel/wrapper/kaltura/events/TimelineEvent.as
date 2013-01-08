package tv.freewheel.wrapper.kaltura.events
{
	import flash.events.Event;
	
	public class TimelineEvent extends Event
	{
		public static const RESET:String = "resetTimeline";
		public var data:Object;
		
		public function TimelineEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}