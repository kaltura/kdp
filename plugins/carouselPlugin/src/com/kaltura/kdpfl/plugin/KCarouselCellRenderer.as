package com.kaltura.kdpfl.plugin {

	import com.kaltura.kdpfl.model.LayoutProxy;
	import com.yahoo.astra.fl.controls.carouselClasses.CarouselCellRenderer;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import org.puremvc.as3.patterns.facade.Facade;


	public class KCarouselCellRenderer extends CarouselCellRenderer {

		private static var defaultStyles:Object = {imagePadding: 5,
				itemSize: 50,
				hoverPopupBackground: "galleryHover",
				upSkin: "Button_upSkin_galleryThumb",
				downSkin: "Button_downSkin_galleryThumb",
				overSkin: "Button_overSkin_galleryThumb",
				disabledSkin: "Button_disabledSkin_galleryThumb",
				selectedDisabledSkin: "Button_selectedDisabledSkin_galleryThumb",
				selectedUpSkin: "Button_selectedUpSkin_galleryThumb",
				selectedDownSkin: "Button_selectedDownSkin_galleryThumb",
				selectedOverSkin: "Button_selectedOverSkin_galleryThumb"}


		/**
		 * @copy fl.core.UIComponent#getStyleDefinition()
		 *
		 * @see fl.core.UIComponent#getStyle()
		 * @see fl.core.UIComponent#setStyle()
		 * @see fl.managers.StyleManager
		 */
		public static function getStyleDefinition():Object {
			return mergeStyles(defaultStyles, CarouselCellRenderer.getStyleDefinition());
		}


		public static function setDefaultStyle(styleName:String, styleValue:Object):void {
			defaultStyles[styleName] = styleValue;
		}

//		protected var _bitmap:Bitmap;
		protected var _overBitmap:MovieClip;
 
//		public static var thumbMC:MovieClip;
//		public static var updatedThumbMC:Boolean = true;
//		protected var _shouldReloadThumbMC:Boolean = true;
//		protected var _currentFrame:int;
		protected var _thumbLoader:Loader;

		protected var _popUpbackground:DisplayObject;
		protected var _foreground:Sprite;


		public function KCarouselCellRenderer() {
			this.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			this.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);

			var layoutProxy:LayoutProxy = Facade.getInstance().retrieveProxy(LayoutProxy.NAME) as LayoutProxy;
			_foreground = layoutProxy.vo.foreground;
		}


		override public function set data(arg0:Object):void {
			if (super.data == arg0) {
				return;
			}
			
			super.data = arg0;
			this.width = this.height = this.getStyleValue("itemSize") as Number;
			if (this.data && this.data.source && this.data.source.loaderInfo.bytes) {
				if (!_thumbLoader) {
					_thumbLoader = new Loader();
					this.addChild(_thumbLoader);
				}

				_thumbLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onThumbMCLoaded);
				_thumbLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onThumbMCError);
				_thumbLoader.addEventListener(IOErrorEvent.IO_ERROR, onThumbMCError);
				_thumbLoader.loadBytes(this.data.source.loaderInfo.bytes);
			}
		}


		override protected function configUI():void {
			super.configUI();
			this.removeChild(this.loader);
			this.removeChild(this.textField);
			if (!_thumbLoader) {
				_thumbLoader = new Loader();
				this.addChild(_thumbLoader);
			}
		}


		protected function onThumbMCLoaded(e:Event = null):void {
			if (e) {
				_thumbLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onThumbMCLoaded);
				_thumbLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onThumbMCError);
				_thumbLoader.removeEventListener(IOErrorEvent.IO_ERROR, onThumbMCError);
				(_thumbLoader.content as MovieClip).gotoAndStop(this.data.frameNum);

			}

			var imagePadding:Number = this.getStyleValue("imagePadding") as Number;
			_thumbLoader.width = this.width - 2 * imagePadding;
			_thumbLoader.height = this.height - 2 * imagePadding;
			_thumbLoader.x = imagePadding;
			_thumbLoader.y = imagePadding;


		}


		protected function onThumbMCError(e:IOErrorEvent):void {
			_thumbLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onThumbMCLoaded);
			_thumbLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onThumbMCError);
			_thumbLoader.removeEventListener(IOErrorEvent.IO_ERROR, onThumbMCError);
		}


		/**
		 * Handler for rolling the cursor over a carousel item
		 * @param event mouse roll-over event.
		 *
		 */
		protected function onMouseOver(event:MouseEvent):void {

			var imagePadding:Number = this.getStyleValue("imagePadding") as Number;
			var bitmapWidth:Number = this.width * 2;
			var bitmapHeight:Number = this.height * 2;

			_popUpbackground = this.getDisplayObjectInstance(this.getStyleValue("hoverPopupBackground"));
			var p:Point = new Point(width / 2, 0);
			p = this.localToGlobal(p);
			p = _foreground.globalToLocal(p);

			_overBitmap = this.data.source;
			_overBitmap.visible = false;

			_foreground.addChild(_popUpbackground);
			_foreground.addChild(_overBitmap);
			_overBitmap.gotoAndStop(this.data.frameNum);
			_overBitmap.width = bitmapWidth;
			_overBitmap.height = bitmapHeight;
			_overBitmap.x = (p.x - _overBitmap.width / 2);
			_overBitmap.y = p.y - _overBitmap.height - imagePadding * 2;
			var topPadding:Number = _popUpbackground.scale9Grid.x - _popUpbackground.x;
			var bottomPadding:Number = _popUpbackground.height - _popUpbackground.scale9Grid.height - topPadding;
			var rightPadding:Number = (_popUpbackground.width - _popUpbackground.scale9Grid.width) / 2;
			var leftPadding:Number = (_popUpbackground.width - _popUpbackground.scale9Grid.width) / 2;

			_popUpbackground.x = _overBitmap.x - rightPadding;
			_popUpbackground.y = _overBitmap.y - topPadding;

			_popUpbackground.width = _overBitmap.width + rightPadding + leftPadding;
			_popUpbackground.height = _overBitmap.height + topPadding + bottomPadding;
			_overBitmap.visible = true;




		/*function onOverThumbLoaded (e:Event) : void
		   {
		   if ( _overBitmap && _overBitmap.hasEventListener( Event.COMPLETE ) )
		   {
		   _overBitmap.contentLoaderInfo.removeEventListener(  Event.COMPLETE, onOverThumbLoaded );
		   _overBitmap.contentLoaderInfo.removeEventListener( IOErrorEvent.IO_ERROR, onOverThumbLoaded );
		   }
		   else
		   {
		   return;
		   }

		   var mc : MovieClip = _overBitmap.content as MovieClip;
		   mc.gotoAndStop( currentFrame );
		   (_overBitmap.content as MovieClip).gotoAndStop( currentFrame );

		   _overBitmap.width = bitmapWidth;
		   _overBitmap.height = bitmapHeight;
		   _overBitmap.x = (p.x - _overBitmap.width / 2);
		   _overBitmap.y = p.y - _overBitmap.height - imagePadding * 2;
		   var topPadding:Number = _popUpbackground.scale9Grid.x - _popUpbackground.x;
		   var bottomPadding:Number = _popUpbackground.height - _popUpbackground.scale9Grid.height - topPadding;
		   var rightPadding:Number = (_popUpbackground.width - _popUpbackground.scale9Grid.width) / 2;
		   var leftPadding:Number = (_popUpbackground.width - _popUpbackground.scale9Grid.width) / 2;



		   _popUpbackground.x = _overBitmap.x - rightPadding;
		   _popUpbackground.y = _overBitmap.y - topPadding;

		   _popUpbackground.width = _overBitmap.width + rightPadding + leftPadding;
		   _popUpbackground.height = _overBitmap.height + topPadding + bottomPadding;
		   _overBitmap.visible = true;

		   }

		   function onOverThumbError (e : Event) : void
		   {

		 }*/
		}


		/**
		 * Handler for rolling mouse cursor off a carousel item.
		 * @param event
		 *
		 */
		protected function onMouseOut(event:MouseEvent):void {
			_foreground.removeChild(_popUpbackground)
			_foreground.removeChild(_overBitmap)
			_overBitmap = null;
		}


	}
}