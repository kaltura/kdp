package tv.freewheel.wrapper.osmf.slot
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.osmf.events.TimeEvent;
	import org.osmf.traits.TimeTrait;
	
	import tv.freewheel.ad.behavior.IAdManager;
	import tv.freewheel.ad.behavior.IEvent;
	import tv.freewheel.ad.behavior.ISlot;
	
	public class FWSlotTimeTrait extends TimeTrait
	{
		private var slot:ISlot;
		private var timer:Timer;
		
		public function FWSlotTimeTrait(am:IAdManager, slot:ISlot)
		{
			super(convertMinusToNaN(slot.getTotalDuration(true)));
			this.slot = slot;
			this.timer = new Timer(1000);
			this.timer.addEventListener(TimerEvent.TIMER, this.onTimer, false, 0, true);
			this.timer.start();
			am.addEventListener(am.getConstants().EVENT_SLOT_ENDED, onSlotEnd);
		}
		
		private function onSlotEnd(e:IEvent):void {
			if(e.slotCustomId == this.slot.getCustomId()) {
				signalComplete();
			}
		}
		
		protected override function signalComplete():void {
			this.timer.stop();
			super.signalComplete();
		}
		
		public function stop():void{
			this.signalComplete();
		}
		
		protected override function currentTimeChangeEnd(oldCurrentTime:Number):void {
			dispatchEvent(new TimeEvent(TimeEvent.CURRENT_TIME_CHANGE, false, false, this.currentTime));
		}
		
		private function onTimer(e:TimerEvent):void {
			var time:Number = convertMinusToNaN(this.slot.getPlayheadTime());
			// Change duration first if current time exceeds old duration, 
			// because TimeTrait doesn't allow that and we don't want to trigger "signalComplete" event by that.
			if(time > 0 && time >= duration) this.setDuration(time + 0.001);
			this.setCurrentTime(time);
		}
		
		private function convertMinusToNaN(num:Number):Number {
			if(num < 0) return NaN;
			else return num;
		}
		
	}
}