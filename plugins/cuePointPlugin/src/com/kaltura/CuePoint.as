package com.kaltura
{
	import fl.controls.Button;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class CuePoint extends Button
	{
		private var _totalTime : Number;
		private var _cuePointTime : Number;
		protected static var defaultStyles:Object =
			{
				cuePointIcon_Up: "cuePointIcon_Up",	
				cuePointIcon_Over: "cuePointIcon_Over",
				cuePointIcon_Selected: "cuePointIcon_Selected"
			};
		
		
		public function CuePoint(totalTime:Number, cuePointTime:Number)
		{
			buttonMode = false;
			_totalTime = totalTime;
			_cuePointTime = cuePointTime;
			this.setStyle("upSkin", defaultStyles["cuePointIcon_Up"]);
			this.setStyle("downSkin", defaultStyles["cuePointIcon_Selected"]);
			this.setStyle("overSkin", defaultStyles["cuePointIcon_Over"]);
			this.setStyle("disabledSkin", defaultStyles["cuePointIcon_Up"]);
			this.setStyle("selectedDisabledSkin", defaultStyles["cuePointIcon_Up"]);
			this.setStyle("selectedUpSkin", defaultStyles["cuePointIcon_Selected"]); 
			this.setStyle("selectedDownSkin", defaultStyles["cuePointIcon_Selected"]);
			this.setStyle("selectedOverSkin", defaultStyles["cuePointIcon_Selected"]);
			width = (getDisplayObjectInstance(getStyleValue("upSkin")) as Sprite).width;
			height = (getDisplayObjectInstance(getStyleValue("upSkin")) as Sprite).height;

		}
		
		
		
		override protected function draw():void 
		{
			super.draw();
			
			if (parent) 
			{
				// Check the limits (Dont cut in the edges)
				var newXValue:Number = ( _cuePointTime / (_totalTime*1000)) * (parent.width);
				
				// Update the new x value
					this.x = newXValue;
				//trace("x:",this.x);
			}
		}

		public function get cuePointTime():Number
		{
			return _cuePointTime;
		}

		public function set cuePointTime(value:Number):void
		{
			_cuePointTime = value;
		}

	}
}