package tv.freewheel.wrapper.osmf.slot
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import org.osmf.traits.DisplayObjectTrait;
	
	import tv.freewheel.ad.behavior.ISlot;

	public class FWSlotDisplayObjectTrait extends DisplayObjectTrait
	{	
		private var slot:ISlot;
		private var slotBounds:Object;

		private static var sharedSlotBase:Sprite = new Sprite();
		
		public function FWSlotDisplayObjectTrait(slot:ISlot, slotBounds:Object)
		{
			var slotBase:Sprite = slot.getBase();
			if(slotBase == null) {
				slotBase = sharedSlotBase;
				slot.setBase(slotBase);
			}
			this.slot = slot;
			this.slotBounds = (slotBounds || new Rectangle(0, 0, 320, 240));
			
			super(slotBase, this.slotBounds.width, this.slotBounds.height);
			slotBase.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		protected function onAddedToStage(e:Event):void {
			var slotBase:Sprite = (e.target as Sprite);
			if(this.mediaWidth > 0) {
				slotBase.visible = true;
				slotBase.width = this.mediaWidth;
				slotBase.height = this.mediaHeight;
				
				// Have to draw something here or the slot base won't show, not clear why
				slotBase.graphics.beginFill(0x000000, 0);
				slotBase.graphics.drawRect(0, 0, this.mediaWidth, this.mediaHeight);
				slotBase.graphics.endFill();
			}
			slotBase.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		protected override function mediaSizeChangeEnd(oldMediaWidth:Number, oldMediaHeight:Number):void {
			if(this.slotBounds) {
				slot.setBounds(this.slotBounds.x, this.slotBounds.y, this.slotBounds.width, this.slotBounds.height);
			} 
		}
		
	}
}
