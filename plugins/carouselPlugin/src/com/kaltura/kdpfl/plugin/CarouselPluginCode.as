package com.kaltura.kdpfl.plugin {
	import com.yahoo.astra.fl.controls.carouselClasses.SlidingCarouselRenderer;
	
	import fl.core.UIComponent;
	import fl.data.DataProvider;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.SecurityDomain;
	
	import org.puremvc.as3.interfaces.IFacade;

	public class CarouselPluginCode extends UIComponent implements IPlugin {
		protected var _facade:IFacade;
		protected var _carousel:KCarousel;
		protected var _dataProvider:DataProvider;
		protected var _itemSize:Number;
		protected var _horizontalGap:Number;

		protected var _presentationPath:String;
		protected var _loader:Loader = new Loader();
		protected var _framesList:Array;


		public function CarouselPluginCode() {

		}


		public function initializePlugin(facade:IFacade):void {
			_facade = facade;
			_carousel = new KCarousel();

			_facade.registerMediator(new CarouselMediator(this));

			_carousel.labelField = "title";
			_carousel.sourceField = "imageURL";
			_carousel.setStyle("cellRenderer", KCarouselCellRenderer);
			_carousel.setStyle("skin", Shape);
			var layout:SlidingCarouselRenderer = new KSlidingCarouselRenderer();
			layout.horizontalAlign = "center";
			layout.horizontalGap = _horizontalGap;

			_carousel.layoutRenderer = layout;

			_carousel.width = this.parent.width;
			_carousel.height = this.parent.height;

		}


		/**
		 * remove load listeners and construct the carousel data provider 
		 * @param e
		 */		
		protected function onPresentationLoaded(e:Event):void {
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onPresentationLoaded);
			_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onPresentationLoaded);
			_loader.removeEventListener(IOErrorEvent.IO_ERROR, onPresentationLoaded);
			if (e.type == Event.COMPLETE) {
				constructDataProvider();
			}
		}


		/**
		 * create the carousel's data provider according to parameters.
		 * if items are not provided, the DP will be created from a
		 * previously loaded clip.
		 *   
		 * @param list optional list of items to be used as DP
		 */		
		protected function constructDataProvider(list:Array = null):void {
			if (!list || !list.length) {
				for (var index:int = 1; index <= (_loader.content as MovieClip).totalFrames; index++) {
					var dataProviderEntry:Object = {source: _loader.content, frameNum: index};
					_carousel.addItem(dataProviderEntry);
				}
			}
			else {
				_carousel.dataProvider = new DataProvider(list);
			}
			this.addChild(_carousel);
		}


		public function setSkin(styleName:String, setSkinSize:Boolean = false):void {

		}



		[Bindable]
		public function set dataProvider(v:DataProvider):void {
			constructDataProvider(v.toArray());
		}


		public function get dataProvider():DataProvider {
			return _carousel.dataProvider;
		}


		public function set itemSize(value:Number):void {
			if (value) {
				_itemSize = value;
				KCarouselCellRenderer.setDefaultStyle("itemSize", value);
			}
		}


		public function set imagePadding(value:Number):void {
			KCarouselCellRenderer.setDefaultStyle("imagePadding", value);
		}


		public function set horizontalGap(value:Number):void {
			_horizontalGap = value;
		}


		public function get carousel():KCarousel {
			return _carousel;
		}


		override public function set width(value:Number):void {
			super.width = value;
			carousel.setSize(value, carousel.height);
		}


		override public function set height(value:Number):void {
			super.height = value;
			carousel.setSize(carousel.width, value);
		}


		[Bindable]
		public function set numOfSlidesPerScreen(value:int):void {
		}


		public function get numOfSlidesPerScreen():int {
			if (width && _itemSize) {
				return Math.round(width / _itemSize);
			}
			return 20;
		}


		[Bindable]
		/**
		 * uri of the swf containing the slides of this presentation.
		 * setting this attribute will trigger loading the file, and
		 * the use of its frames as carousel's content. 
		 */		
		public function get presentationPath():String {
			return _presentationPath;
		}

		public function set presentationPath(value:String):void {
			_presentationPath = value;
			if (_presentationPath && _presentationPath != "") {
				_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onPresentationLoaded);
				_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onPresentationLoaded);
				_loader.addEventListener(IOErrorEvent.IO_ERROR, onPresentationLoaded);
				_loader.load(new URLRequest(_presentationPath), new LoaderContext(true, ApplicationDomain.currentDomain, SecurityDomain.currentDomain));
			}
		}


		[Bindable]
		public function get framesList():Array {
			return _framesList;
		}


		public function set framesList(value:Array):void {
			_framesList = value;
		}
		
		override public function set enabled(value:Boolean):void
		{
			if (_carousel)
				_carousel.enabled = value;
			super.enabled = value;
		}


	}
}