package tv.freewheel.wrapper.osmf.events
{
	import flash.events.Event;
	
	public class FWCuePointEvent extends Event
	{
		public static var CUE_POINT_REACHED:String = "cuePointReached";
		
		private var _customId:String;
		private var _time:Number;
		
		public function FWCuePointEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, customId:String = null, time:Number=0)
		{
			super(type, bubbles, cancelable);
			this._customId = customId;
			this._time = time;
		}
		
		public function get customId():String{
			return this._customId;
		}
		
		public function get time():Number{
			return this._time;
		}
		
		public override function clone():Event{
			return new FWCuePointEvent(type, bubbles, cancelable, customId, time);
		}
	}
}