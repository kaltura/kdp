package com.kaltura.kdpfl.view.controls
{
	import com.kaltura.kdpfl.component.IComponent;
	
	import fl.containers.BaseScrollPane;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.utils.getDefinitionByName;

	/**
	 * This view loads an image and places it in one of the 4 corners of it. 
	 * if the image gets a landing url parameter it will become clickable
	 * @author Eitan Avgil
	 * 
	 */
	public class Watermark extends BaseScrollPane implements IComponent
	{
		private var _loader:Loader;
		private var _loaderContainer:Sprite;
		
		public var padding:String = "0";
		public var _paddingNumber:Number;
		public var path:String = "";
		public var position:String = "topLeft";
		public var clickPath:String = "";
		public var excludeMe : Boolean = true;
		
		public function Watermark()
		{		
			_loader = new Loader();
			_loaderContainer = new Sprite();
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR , onIOError );
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE , onLoaderAdded);
			if(path)
			{			
				var urlRequest:URLRequest = new URLRequest(path);
				_loader.load(urlRequest);
			}
			_paddingNumber = Number(padding);

			_loaderContainer.addChild(_loader);
			addChild(_loaderContainer);
			setStyle("skin","ScrollPane_upSkin");
		}
		
		//We must implement IO Eroor to any case somwone is closing the browser in the middle of
		//Loading, if not it might crash the browser.
		private function onIOError( event : IOErrorEvent ) :void { }

		/**
		 * The image was loaded - position it and add the click behavior if needed
		 */
		private function onLoaderAdded(evt:Event):void
		{
			repositionWatermark(position);
			if (clickPath)
			{
				_loaderContainer.useHandCursor = true;
				_loaderContainer.buttonMode = true;
				_loader.addEventListener(MouseEvent.CLICK,onWatermarkClick);
			}
		}
		override public function setStyle(type:String, name:Object):void
		{
 			try{
				var cls:Class = getDefinitionByName(name.toString()) as Class;
				super.setStyle(type, cls);
			}catch(e:Error){
				//trace("Canvas setStyle:",name);
			} 
		}
		
		public function initialize():void{
			_paddingNumber = Number(padding);
		}
		public function setSkin( styleName : String , setSkinSize : Boolean = false) : void{}		
		
		/**
		 * The image was clicked
		 */ 
		public function onWatermarkClick(evt:MouseEvent):void
		{
			var request:URLRequest = new URLRequest(clickPath);
            navigateToURL(request);
		}

		public function get watermarkPath () : String
		{
			return path;
		}
		
		/**
		 * URL of the watermark image. needs a full URL (IE 'http://www.domain/file.gif')  
		 */
		public function set watermarkPath (value:String):void
		{
			path = value;
			_loader.load(new URLRequest(path));
		}
		
		public function get watermarkPosition () : String
		{
			return position;
		}
		
		/**
		 * Corner position of the watermark. topLeft/topRight/bottomLeft/bottomRight 
		 */
		public function set watermarkPosition (value:String):void
		{
			position = value;
			repositionWatermark(value);
		}
		
		public function get watermarkClickPath () : String
		{
			return clickPath ;
		}
		
		/**
		 * Getter for the watermark landing page. if this parameter exist a hand
		 * cursor will apear on the loader graphics and a click on it will open 
		 * this URL
		 */
		public function set watermarkClickPath (value:String):void
		{
			clickPath  = value;
		}
		
		/**
		 * External watermark update. The callLater is for the fullscreen 
		 * 
		 */
		public function updateWaterMarkPosition(newPosition:String = ""):void
		{
			if (newPosition)
				position = newPosition;
			
			callLater(repositionWatermark1);
		}
		
		public function repositionWatermark1():void
		{
			repositionWatermark(position);
		}
		
		/**
		 * Get a string of the location and place the image according to it
		 */
		public function repositionWatermark(position:String="topLeft"):void
		{
			var verticalPosition:String;
			var horizontalPosition:String;
			_loaderContainer.x = _paddingNumber;
			_loaderContainer.y = _paddingNumber;
			switch(position)
			{
   				case "topLeft":
					_loaderContainer.x = _paddingNumber;
					_loaderContainer.y = _paddingNumber;
				break;
				case "topRight":
					_loaderContainer.x = width-_loaderContainer.width-_paddingNumber;
					_loaderContainer.y = _paddingNumber;
				break;
				case "bottomRight":
					_loaderContainer.x = width-_loaderContainer.width;
					_loaderContainer.y = height-_loaderContainer.height-_paddingNumber;
				break;
				case "bottomLeft":
					_loaderContainer.x = _paddingNumber;
					_loaderContainer.y = height-_loaderContainer.height-_paddingNumber;
				break;   
				
			}
		}
	}
}