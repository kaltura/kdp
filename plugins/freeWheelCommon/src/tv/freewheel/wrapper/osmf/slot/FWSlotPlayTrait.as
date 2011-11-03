package tv.freewheel.wrapper.osmf.slot
{
	import flash.display.DisplayObject;
	import flash.utils.setTimeout;
	
	import org.osmf.media.MediaElement;
	import org.osmf.traits.DisplayObjectTrait;
	import org.osmf.traits.MediaTraitType;
	import org.osmf.traits.PlayState;
	import org.osmf.traits.PlayTrait;
	
	import tv.freewheel.ad.behavior.IAdManager;
	import tv.freewheel.ad.behavior.IEvent;
	import tv.freewheel.ad.behavior.ISlot;
	
	public class FWSlotPlayTrait extends PlayTrait
	{
		private var am:IAdManager;
		private var slot:ISlot;
		
		public function FWSlotPlayTrait(am:IAdManager, slot:ISlot)
		{
			super();
			this.am = am;
			this.slot = slot;
			am.addEventListener(am.getConstants().EVENT_SLOT_ENDED, onSlotEnd);
		}
		
		protected override function playStateChangeStart(newPlayState:String):void
		{	
			switch(newPlayState) {
				case PlayState.PLAYING:
					slot.play();
					break;
				case PlayState.PAUSED:
					slot.pause();
					break;
				case PlayState.STOPPED:
					slot.stop();
					break;
			}
		}
		
		public override function get canPause():Boolean
		{
			return true; 
		}
		
		private function onSlotEnd(e:IEvent):void {
			if(e.slotCustomId == this.slot.getCustomId()) {
				setTimeout(this.stop, 0);
			}
		}
		
	}
}
