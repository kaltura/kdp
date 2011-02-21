package com.kaltura.kdpfl.plugin
{
	import com.yahoo.astra.fl.controls.Carousel;
	
	import fl.controls.ScrollPolicy;
	
	import flash.events.Event;

	public class KCarousel extends Carousel
	{
		public function KCarousel()
		{
			super();
		}
		
		/**
		 * Our source is a bitmap data and we are using the item itself to store it
		 */
		override public function itemToSource(item:Object):Object
		{
			return item;
		}
		
		override public function set width(value:Number):void
		{
			super.width = value;
			trace("new carousel width: ", value);
		}
	}
}