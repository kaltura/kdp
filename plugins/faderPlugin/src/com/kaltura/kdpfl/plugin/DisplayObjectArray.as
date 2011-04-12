package com.kaltura.kdpfl.plugin
{
	import flash.display.DisplayObject;

	public class DisplayObjectArray extends Array
	{
		private var _visible : Boolean = true;
		
		private var _alpha : Number = 1;
		
		
		public function DisplayObjectArray()
		{
			super();
		}
		
		
		
		public function get visible():Boolean
		{
			return _visible;
		}

		public function set visible(value:Boolean):void
		{
			_visible = value;
			
			for each(var displayObject : DisplayObject in this)
			{
				displayObject.visible = _visible;
			}
		}

		public function get alpha():Number
		{
			return _alpha;
		}

		public function set alpha(value:Number):void
		{
			_alpha = value;
			
			for each(var displayObject : DisplayObject in this)
			{
				displayObject.alpha = _alpha;
			}
		}


	}
}