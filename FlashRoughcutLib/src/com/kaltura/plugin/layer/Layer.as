/*
This file is part of the Kaltura Collaborative Media Suite which allows users 
to do with audio, video, and animation what Wiki platfroms allow them to do with 
text.

Copyright (C) 2006-2008  Kaltura Inc.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as
published by the Free Software Foundation, either version 3 of the
License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

@ignore
*/
package com.kaltura.plugin.layer
{
	import flash.display.Shape;
	import flash.display.Sprite;

	public class Layer extends DisposableBase
	{
		private var _display:Sprite;
		protected var _background:Shape = new Shape();
		protected var explicitLayerWidth:Number;
		protected var explicitLayerHeight:Number; 
		
		public function Layer(drawBackground:Boolean = false, LayerW:Number = 0, LayerH:Number = 0):void
		{
			explicitLayerWidth = LayerW;
			explicitLayerHeight = LayerH;
			display = new Sprite();
			display.name = "myDisplay";
			if (drawBackground) 
				drawBackgroung ();
		}
		
		protected function drawBackgroung():void
		{
			_background.graphics.beginFill(0x000000);
			_background.graphics.drawRect(0, 0, explicitLayerWidth, explicitLayerHeight);
			_background.graphics.endFill();
			display.addChildAt (_background, 0);
		}
		public function set display(display:Sprite):void
		{
			if (_display != null)
				if (contains(_display))
					removeChild(_display);
			_display = display;
			//display.alpha = 0.5; //xxx
			addChildSafely(display);
		}
		public function get display():Sprite
		{
			return _display;
		}
		/**
		 * A value from the LayerRegistration class that specifies the x axe registration point of the Layer.
		 * @param sRegistrationX
		 * 
		 */		
		public function set registrationX(sRegistrationX:String):void
		{
			var nXOffset:Number = 0;
			switch (sRegistrationX)
			{
				case LayerRegistration.LEFT:
					nXOffset = 0;
					break;
				case LayerRegistration.CENTER:
					nXOffset = _display.width / 2;
					break;
				case LayerRegistration.RIGHT:
					nXOffset = _display.width;
					break;
			}
			_display.x = - nXOffset;
			x = nXOffset;
		}

		/**
		 * A value from the LayerRegistration class that specifies the y axe registration point of the Layer.
		 * @param sRegistrationY
		 * 
		 */		
		public function set registrationY(sRegistrationY:String):void
		{
			var nYOffset:Number = 0;
			switch (sRegistrationY)
			{
				case LayerRegistration.TOP:
					nYOffset = 0;
					break;
				case LayerRegistration.MIDDLE:
					nYOffset = _display.height/2;
					break;
				case LayerRegistration.BOTTOM:
					nYOffset = _display.height
					break;
			}
			_display.y = - nYOffset;
			y = nYOffset;
			//xxx invalidateDisplayList();
		}
		public override function resetProperties():void
		{
			super.resetProperties();
			_display.width = width;
			_display.height = height;
			_display.x = _display.y = 0;
			display = _display;
		}
	}
}