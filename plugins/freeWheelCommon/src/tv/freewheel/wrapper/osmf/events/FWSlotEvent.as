package tv.freewheel.wrapper.osmf.events
{
	import flash.events.Event;
	
	import tv.freewheel.wrapper.osmf.slot.FWSlotElement;
	
	/**
	 * An FWSlotEvent is dispatched when a FreeWheel ad slot starts or ends.
	 */
	public class FWSlotEvent extends Event
	{	
		/**
		 * The FWSlotEvent.SLOT_START constant defines the value
		 * of the type property of the event object for a FWSlotEvent
		 * event.
		 * 
		 * @eventType SLOT_START 
		 */	
		public static const SLOT_START:String = "slotStart";

		/**
		 * The FWSlotEvent.SLOT_END constant defines the value
		 * of the type property of the event object for a FWSlotEvent
		 * event.
		 * 
		 * @eventType SLOT_END 
		 */	
		public static const SLOT_END:String = "slotEnd";
		
		private var _slotElement:FWSlotElement;
		
		public function FWSlotEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false,
			slotElement:FWSlotElement = null)
		{
			super(type, bubbles, cancelable);
			this._slotElement = slotElement;
		}
		
		/**
		 * Get the IFWSlotElement for the ad slot corresponding to this event.
		 *
		 * @see tv.freewheel.wrapper.osmf.slot.IFWSlotElement
		 */
		public function get slotElement():FWSlotElement {
			return this._slotElement;
		}
		
		/**
		 * @inheritDoc
		 */
		public override function clone():Event { 
			return new FWSlotEvent(type, bubbles, cancelable, slotElement); 
		} 
	}
}
