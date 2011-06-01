package com.kaltura.kdpfl.plugin 
{
	import com.kaltura.KalturaClient;
	import com.kaltura.commands.baseEntry.BaseEntryGet;
	import com.kaltura.events.KalturaEvent;
	import com.kaltura.kdpfl.model.ServicesProxy;
	import com.kaltura.vo.KalturaBaseEntry;
	import com.kaltura.vo.KalturaDocumentEntry;
	import com.kaltura.vo.KalturaMediaEntry;
	import com.yahoo.astra.fl.charts.axes.NumericAxis;
	
	import fl.controls.Button;
	import fl.core.UIComponent;
	import fl.data.DataProvider;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.system.Security;
	
	import org.puremvc.as3.interfaces.IFacade;
	/**
	 * Class PPTWidgetScreenPlugin manages the ppt page to the right of the video.
	 * @author Hila
	 * 
	 */	
	public dynamic class PPTWidgetScreenPlugin extends UIComponent implements IPlugin
	{
		protected var _facade:IFacade;
		protected var _loader:Loader;
		protected var _bitmap:Bitmap = new Bitmap();
				
		public function PPTWidgetScreenPlugin():void
		{
		}
	
		public function setSkin(styleName:String, setSkinSize:Boolean=false):void { }
		/**
		 * Initialize process of the plugin. Sets the facade and ads the ppt bitmap image to the stage. 
		 * @param facade the facade of the application.
		 * 
		 */		
		public function initializePlugin(facade:IFacade):void
		{
			_facade = facade;
			addChild(_bitmap);
		}
		
		[Bindable]
		/**
		 * When a new bitmap is set through the API, the previous bitmap image is removed and the new one 
		 * is resized to the same scale and set in its place. 
		 * @param bitmapData
		 * 
		 */		
		public function set bitmapDataProvider(bitmapData:BitmapData):void
		{
			removeChild(_bitmap);
			_bitmap = new Bitmap(bitmapData, "auto", true);
			_bitmap.scaleX = _bitmap.scaleY = getScaleForBitmap(bitmapData.width, bitmapData.height);
			repositionBitmap();
			addChild(_bitmap);
		}
		
		public function get bitmapDataProvider():BitmapData
		{
			return _bitmap.bitmapData;
		}
		/**
		 * Function sets the scale for the bitmap. 
		 * @param bitmapWidth
		 * @param bitmapHeight
		 * @return 
		 * 
		 */		
		protected function getScaleForBitmap(bitmapWidth:Number, bitmapHeight:Number):Number
		{
			var widthRatio:Number = bitmapWidth / parent.width;
			var heightRatio:Number = bitmapHeight / parent.height;
			if (parent.width >= bitmapWidth / heightRatio)
				return parent.height / bitmapHeight;
			else
				return parent.width / bitmapWidth;
		}
		/**
		 * Function to reposition the bitmap image when its width or height are changed. 
		 * 
		 */		
		private function repositionBitmap() : void
		{
			_bitmap.x = (parent.width - _bitmap.width) / 2;
			_bitmap.y = (parent.height - _bitmap.height) / 2;
		}
		/**
		 * The override of the width setter also sets the size of the bitmap image. 
		 * @param value new width of the plugin.
		 * 
		 */		
		override public function set width(value:Number):void
		{
			super.width = value;
			if (_bitmap.width != parent.width)
			{
				_bitmap.width = parent.width;
			}
			repositionBitmap();
		}
		/**
		 * The override of the height setter also sets the height of the bitmap image. 
		 * @param value the new height of the plugin.
		 * 
		 */		
		override public function set height(value:Number):void
		{
			super.height = value;
			if (_bitmap.height != parent.height)
			{
				_bitmap.height = parent.height;
			}
			repositionBitmap();
		}

	}
}