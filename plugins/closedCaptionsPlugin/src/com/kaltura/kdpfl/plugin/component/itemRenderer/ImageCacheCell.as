package com.kaltura.kdpfl.plugin.component.itemRenderer
{
	import fl.containers.UILoader;
	import fl.controls.listClasses.ICellRenderer;
	import fl.controls.listClasses.ImageCell;
	
	import flash.display.Bitmap;
	import flash.events.*;
	import flash.text.*;
	
	public class ImageCacheCell extends ImageCell implements ICellRenderer
	{  
		public function ImageCacheCell() 
		{
			super();
			loader.addEventListener(Event.COMPLETE, completeHandler);
    	}
		
		private function completeHandler(event:Event):void 
		{
			var uiLdr:UILoader = event.currentTarget as UILoader;
            var image:Bitmap = Bitmap(uiLdr.content);
			// inject the loaded bitmap into the dataProvider
			data._$cachedImage = image;
		}
		
		override public function set source(value:Object):void
		{
			var image : Object = data._$cachedImage;
			// either load image from supplied value 
			if (image == null)
			{
				loader.source = value;
			}
			// or load from store reference to bitmap
			else
			{
				loader.source = image;
			}
		}
	}
}