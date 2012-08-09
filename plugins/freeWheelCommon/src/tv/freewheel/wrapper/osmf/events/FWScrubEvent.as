package tv.freewheel.wrapper.osmf.events
{
	import flash.events.Event;
	
	public class FWScrubEvent extends Event
	{
		public static var SCRUB_END:String = "scrubEnd";
		
		private var _slot:Object;
		private var _timeline:Object;
		
		public function FWScrubEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, 
									 slot:Object=null, timeline:Object=null){
			super(type, bubbles, cancelable);
			this._slot = slot;
			this._timeline = timeline || new Object();
		}
		
		public function get slot():Object{
			return this._slot;
		}
		
		public function get timeline():Object{
			return this._timeline;
		}
	}
}