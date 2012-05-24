package tv.freewheel.wrapper.kaltura.events
{
	import flash.events.Event;
	
	public class SeekEvent extends Event
	{
		public static const SEEK_START:String = 'playerSeekStart';
		public static const SEEK_END:String = 'playerSeekEnd';
		
		public var data:Object;
		
		public function SeekEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}