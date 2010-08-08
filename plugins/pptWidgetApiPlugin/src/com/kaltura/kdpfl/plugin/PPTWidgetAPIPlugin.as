package com.kaltura.kdpfl.plugin 
{
	import fl.data.DataProvider;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	import org.puremvc.as3.interfaces.IFacade;

	public dynamic class PPTWidgetAPIPlugin extends Sprite implements IPlugin
	{
		public var nextButtonId:DisplayObject;
		public var prevButtonId:DisplayObject;
		
		protected var _facade:IFacade;
		protected var _mediator:PPTWidgetAPIMediator;
		protected var _bitmapData:BitmapData;
		protected var _dataProvider:DataProvider;
		protected var _shouldSave:Boolean;
		protected var _displayPrevButton:Boolean = false;
		protected var _displayNextButton:Boolean = false;
		protected var _enablePPTControls:Boolean = false;
		protected var _adminMode:Boolean = false;
		
		public function PPTWidgetAPIPlugin()
		{
		}
		
		public function setSkin(styleName:String, setSkinSize:Boolean=false):void { }
		
		public function initializePlugin(facade:IFacade):void
		{
			_dataProvider = new DataProvider();
			_facade = facade;
			_mediator = new PPTWidgetAPIMediator(this);
			_facade.registerMediator(_mediator);
		}
		
		[Bindable]
		public function set bitmapDataProvider(bitmapData:BitmapData):void { _bitmapData = bitmapData; }
		public function get bitmapDataProvider():BitmapData { return _bitmapData; }
		
		[Bindable]
		public function set carouselPicturesDataProvider(v:DataProvider):void { _dataProvider = v; }
		public function get carouselPicturesDataProvider():DataProvider { return _dataProvider; }
		
		[Bindable]
		public function set shouldSave(v:Boolean):void { _shouldSave = v; }
		public function get shouldSave():Boolean { return _shouldSave; }
		
		[Bindable]
		public function set displayPrevButton(v:Boolean):void { _displayPrevButton = v; }
		public function get displayPrevButton():Boolean { return _displayPrevButton; }
		
		[Bindable]
		public function set displayNextButton(v:Boolean):void { _displayNextButton = v; }
		public function get displayNextButton():Boolean { return _displayNextButton; }
		
		[Bindable]
		public function set adminMode(v:Boolean):void { _adminMode = v; }
		public function get adminMode():Boolean { return _adminMode; }
		
		[Bindable]
		public function set enablePPTControls(enable:Boolean):void { _enablePPTControls=enable; }
		public function get enablePPTControls():Boolean { return _enablePPTControls; }
	}
}
