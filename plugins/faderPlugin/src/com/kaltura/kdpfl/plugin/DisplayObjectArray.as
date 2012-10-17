package com.kaltura.kdpfl.plugin
{
	import flash.display.DisplayObject;

	public class DisplayObjectArray 
	{
		private var _visible : Boolean = true;
		
		private var _alpha : Number = 1;
		
		protected var _array : Array;
		
		
		public function DisplayObjectArray()
		{
			super();
			_array = new Array();
		}
		
		
		
		public function get array():Array
		{
			return _array;
		}

		public function set array(value:Array):void
		{
			_array = value;
		}

		public function get visible():Boolean
		{
			return _visible;
		}

		public function set visible(value:Boolean):void
		{
			_visible = value;
			
			for each(var displayObject : DisplayObject in array)
			{
				if (displayObject)
				{
					displayObject.visible = _visible;
				}
			}
		}

		public function get alpha():Number
		{
			return _alpha;
		}

		public function set alpha(value:Number):void
		{
			_alpha = value;
			
			for each(var displayObject : DisplayObject in array)
			{
				if (displayObject)
				{
					displayObject.alpha = _alpha;
				}
			}
		}
		
		public function removeDisplayObject (dispObj : DisplayObject) : void
		{
			var deleteIndex : int = array.indexOf(dispObj);
			array.splice(deleteIndex, 1);
		}


	}
}