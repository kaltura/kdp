package com.kaltura
{
	import fl.core.UIComponent;
	
	public class CuePointContainer extends UIComponent
		
	{
		public function CuePointContainer()
		{
			super();
		}
		
		public function addCuePoints (cuePointArray:Array, duration : Number) : void
		{
			cleanCuePoints();
			for each (var time:Number in cuePointArray )
			{
				var cuePoint : CuePoint = new CuePoint(duration, time);
				addChild(cuePoint);
			}
		}
		
		public function cleanCuePoints () : void
		{
			while(numChildren > 0)
			{
				this.removeChildAt(0);
			}
		}
		
		override public function set width(value:Number):void
		{
			if (value != this.width)
			{
				super.width = value;
				for (var i:int=0; i<numChildren; i++)
				{
					(getChildAt(i) as CuePoint).drawNow();
				}
			}
			
		}
	}
}