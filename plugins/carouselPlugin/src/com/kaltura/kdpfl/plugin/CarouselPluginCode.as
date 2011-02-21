package com.kaltura.kdpfl.plugin
{
	import com.yahoo.astra.fl.controls.carouselClasses.SlidingCarouselRenderer;
	import com.yahoo.astra.fl.controls.carouselClasses.astra_carousel_internal;
	
	import fl.core.UIComponent;
	import fl.data.DataProvider;
	import fl.events.ListEvent;
	
	import flash.display.Shape;
	import flash.events.Event;
	
	import org.puremvc.as3.interfaces.IFacade;
	
	public class CarouselPluginCode extends UIComponent implements IPlugin
	{ 
		protected var _facade:IFacade;
		protected var _carousel:KCarousel;
		protected var _dataProvider:DataProvider;
		protected var _itemSize:Number;
		protected var _horizontalGap:Number;
		
		public function CarouselPluginCode()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		public function initializePlugin(facade : IFacade) : void
		{
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

			this.addChild(_carousel);
		}
		
		public function setSkin(styleName: String, setSkinSize: Boolean = false):void
		{
			
		}
		
		protected function onAddedToStage(event:Event):void
		{
			
		}
		
		[Bindable]
		public function set dataProvider(v:DataProvider):void { if (v) _carousel.dataProvider = v; }
		public function get dataProvider():DataProvider { return _carousel.dataProvider; }
		
		public function set itemSize(value:Number):void { KCarouselCellRenderer.setDefaultStyle("itemSize", value); }
		public function set imagePadding(value:Number):void { KCarouselCellRenderer.setDefaultStyle("imagePadding", value); }
		public function set horizontalGap(value:Number):void { _horizontalGap = value; }
		
		public function get carousel():KCarousel { return _carousel; }
		
		override public function set width(value:Number):void
		{
			super.width = value;
			carousel.setSize(value,carousel.height);
		}
		
		override public function set height(value:Number):void
		{
			super.height = value;
			carousel.setSize(carousel.width, value);
		}
	}
}