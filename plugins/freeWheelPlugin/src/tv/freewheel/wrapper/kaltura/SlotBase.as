package tv.freewheel.wrapper.kaltura
{
	import flash.display.Sprite;
	import tv.freewheel.logging.Logger;
	
	public class SlotBase extends Sprite
	{
		public function SlotBase()
		{
			super();
			this.mouseEnabled = false;
		}
		
		public override function set x(x:Number):void{
			Logger.current.debug('Attempted to set x=' + x + ' on slotBase, blocked.');
		}
		
		public override function set y(y:Number):void{
			Logger.current.debug('Attempted to set y=' + y + ' on slotBase, blocked.');
		}
		
		public override function set width(w:Number):void{
			Logger.current.debug('Attempted to set width=' + width + ' on slotBase, blocked.');
		}
		
		public override function set height(h:Number):void{
			Logger.current.debug('Attempted to set height=' + height + ' on slotBase, blocked.');
		}
	}
}
