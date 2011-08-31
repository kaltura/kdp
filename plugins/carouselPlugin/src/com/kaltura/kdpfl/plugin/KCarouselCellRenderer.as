package com.kaltura.kdpfl.plugin
{
	
	import com.kaltura.kdpfl.model.LayoutProxy;
	import com.yahoo.astra.fl.controls.carouselClasses.CarouselCellRenderer;
	import com.yahoo.astra.fl.controls.carouselClasses.CarouselListData;
	
	import fl.core.InvalidationType;
	import fl.core.UIComponent;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import jac.image.ImageUtils;
	import jac.image.ResizeStyle;
	
	import org.puremvc.as3.patterns.facade.Facade;
	
	
	public class KCarouselCellRenderer extends CarouselCellRenderer 
	{
		
		private static var defaultStyles:Object = 
		{
			imagePadding: 5,
			itemSize: 50,
			hoverPopupBackground: "galleryHover",
			upSkin:"Button_upSkin_galleryThumb",
			downSkin:"Button_downSkin_galleryThumb",
			overSkin:"Button_overSkin_galleryThumb",
			disabledSkin:"Button_disabledSkin_galleryThumb",
			selectedDisabledSkin:"Button_selectedDisabledSkin_galleryThumb",
			selectedUpSkin:"Button_selectedUpSkin_galleryThumb",
			selectedDownSkin:"Button_selectedDownSkin_galleryThumb",
			selectedOverSkin:"Button_selectedOverSkin_galleryThumb"
		}
			
		/**
		 * @copy fl.core.UIComponent#getStyleDefinition()
		 *
		 * @see fl.core.UIComponent#getStyle()
		 * @see fl.core.UIComponent#setStyle()
		 * @see fl.managers.StyleManager
		 */
		public static function getStyleDefinition():Object
		{
			return mergeStyles(defaultStyles, CarouselCellRenderer.getStyleDefinition());
		}
		
		public static function setDefaultStyle(styleName:String, styleValue:Object):void
		{
			defaultStyles[styleName] = styleValue;
		}
		
		protected var _bitmap:Bitmap;
		protected var _overBitmap:Bitmap;
		protected var _popUpbackground:DisplayObject;
		protected var _foreground:Sprite;
		
		public function KCarouselCellRenderer()
		{
			this.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			this.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			
			var layoutProxy:LayoutProxy = Facade.getInstance().retrieveProxy(LayoutProxy.NAME) as LayoutProxy;
			_foreground = layoutProxy.vo.foreground;
		}
		
		override protected function configUI():void
		{
			super.configUI();
			this.removeChild(this.loader);
			this.removeChild(this.textField);
			
			if (!this._bitmap)
			{
				this._bitmap = new Bitmap();
				this.addChild(this._bitmap);
			}
		}
		/**
		 * 
		 * 
		 */		
		override protected function draw():void
		{
			if (this.isInvalid(InvalidationType.ALL))
			{
				this.width = this.height = this.getStyleValue("itemSize") as Number;
				
				var imagePadding:Number = this.getStyleValue("imagePadding") as Number;
			
				var bitmapWidth:Number = this.width - 2 * imagePadding;
				var bitmapHeight:Number = this.height - 2 * imagePadding;
				
				var bitmap:Bitmap = CarouselListData(this.listData).source as Bitmap;
				var bitmapDataSnapshot:BitmapData = ImageUtils.snapshot(bitmap.bitmapData, bitmapWidth, bitmapHeight, ResizeStyle.CROP, new Rectangle(0, 0, bitmap.width, bitmap.height));
				
				this._bitmap.bitmapData = bitmapDataSnapshot;
				
				this._bitmap.x = this._bitmap.y = imagePadding;
				this._bitmap.width = bitmapWidth;
				this._bitmap.height = bitmapHeight;
			}
			
			super.draw();
		}
		/**
		 * Handler for rolling the cursor over a carousel item 
		 * @param event mouse roll-over event.
		 * 
		 */		
		protected function onMouseOver(event:MouseEvent):void
		{
			var imagePadding:Number = this.getStyleValue("imagePadding") as Number;
			var bitmapWidth:Number = this.width * 2;
			var bitmapHeight:Number = this.height * 2;
			var bitmap:Bitmap = CarouselListData(this.listData).source as Bitmap;
			var bitmapDataSnapshot:BitmapData = ImageUtils.snapshot(bitmap.bitmapData, bitmapWidth, bitmapHeight, ResizeStyle.CONSTRAIN_PROPORTIONS, new Rectangle(0, 0, bitmap.width, bitmap.height));
			
			var p:Point = new Point(width / 2, 0);
			p = this.localToGlobal(p);
			p = _foreground.globalToLocal(p);
			
			_overBitmap = new Bitmap();
			_overBitmap.bitmapData = bitmapDataSnapshot;
			_overBitmap.x = (p.x - _overBitmap.width / 2);
			_overBitmap.y = p.y - _overBitmap.height - imagePadding * 2;
			
			_popUpbackground = this.getDisplayObjectInstance(this.getStyleValue("hoverPopupBackground"));
			
			var topPadding:Number = _popUpbackground.scale9Grid.x - _popUpbackground.x;
			var bottomPadding:Number = _popUpbackground.height - _popUpbackground.scale9Grid.height - topPadding;
			var rightPadding:Number = (_popUpbackground.width - _popUpbackground.scale9Grid.width) / 2;
			var leftPadding:Number = (_popUpbackground.width - _popUpbackground.scale9Grid.width) / 2;
			
			_overBitmap.y = _overBitmap.y - bottomPadding;
			
			_popUpbackground.x = _overBitmap.x - rightPadding;
			_popUpbackground.y = _overBitmap.y - topPadding;
			
			_popUpbackground.width = _overBitmap.width + rightPadding + leftPadding;
			_popUpbackground.height = _overBitmap.height + topPadding + bottomPadding;
			_foreground.addChild(_popUpbackground);
			_foreground.addChild(_overBitmap);
		}
		/**
		 * Handler for rolling mouse cursor off a carousel item.
		 * @param event
		 * 
		 */		
		protected function onMouseOut(event:MouseEvent):void
		{
			_foreground.removeChild(_popUpbackground)
			_foreground.removeChild(_overBitmap)
			_overBitmap = null;
		}
		
		
	}
}