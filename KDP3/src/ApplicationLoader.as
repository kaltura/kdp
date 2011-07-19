package {
	import fl.events.ComponentEvent;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.system.Security;
	import flash.utils.getDefinitionByName;
	
	
	/**
	 * @class ApplicationLoader
	 * This class is the preloader of the kdp3 application and its document class (root). </br>
	 * It delegates all calls to IKDP3 methods to the actual kdp3 instance, to enable
	 * communication with loading applications, etc.
	 * @author Atar
	 *
	 */
	public class ApplicationLoader extends MovieClip implements IKDP3 {
		
		/**
		 * an instance of the created application (kdp3)
		 */
		protected var _app:IKDP3;
		
		/**
		 * the loader instance that loads the external swf preloader.
		 */
		protected var _ldr:*;
		
		protected var _path:String;
		
		
		/**
		 * is the real app started yet
		 */
		protected var _isGoing:Boolean = false;
		
		
		/**
		 * temporarily save flashvars until _app is ready
		 */
		protected var _flashvars:Object;
		
		
		/**
		 * someone already asked to init the KDP
		 */
		protected var _shouldInit:Boolean;
		
		
		/**
		 * if someone asked to init with KML, save data here
		 */
		
		protected var _kml:XML;
		
		/**
		 * 
		 */		
		[Embed(source="assets/preloader.swf")]
		private var AssetClass:Class;

		
		private var _height:Number;
		private var _width:Number;
		
		
		
		/**
		 * Constructor.
		 */
		public function ApplicationLoader() {
			this.addEventListener(ComponentEvent.HIDE, stopImmediatePropagation);
			this.addEventListener(ComponentEvent.SHOW, stopImmediatePropagation);
			Security.allowDomain("*");
			super();
			stop();
			loaderInfo.addEventListener(Event.COMPLETE, go);
			if (stage) {
				loadPreloader(null);
			}
			else {
				addEventListener(Event.ADDED_TO_STAGE, loadPreloader);
			}
		}
		
		
		/**
		 * concatenate the host and most of the path up to the preloader's folder
		 * or return given path, if such exist.
		 * @return full url of preloader swf
		 */
		protected function getPath():String {
			if (parameters.preloaderPath) {
				return parameters.preloaderPath;
			}
			var s:String = this.loaderInfo.url;
			var i:int = s.indexOf("kdp3.swf");
			s = s.substring(0, i);
			s += _path;
			return s;
		}
		
		
		/**
		 * load the preloader only when we have root, and only if the app is not running yet.
		 * @param e
		 */
		protected function loadPreloader(e:Event):void {
			if (!_isGoing) {
				if (hasEventListener(Event.ADDED_TO_STAGE)) {
					removeEventListener(Event.ADDED_TO_STAGE, loadPreloader);
				}
				if (!parameters.preloaderPath)
				{
					_ldr = new AssetClass();
					addChild(_ldr);
					centerLoader(null);
				}
				else
				{
					_ldr = new Loader();
					centerLoader(null);
					addChild(_ldr);
					var rqst:URLRequest = new URLRequest(getPath());
					_ldr.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, clearListeners, false, 0, true);
					_ldr.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, clearListeners, false, 0, true);
					_ldr.contentLoaderInfo.addEventListener(Event.INIT, clearListeners, false, 0, true);
					_ldr.load(rqst);
				}	
				
				
				stage.addEventListener(Event.RESIZE, centerLoader);
			}
		}
		
		
		/**
		 * place the loader at the center of the stage
		 * @param e	stage resize event
		 */
		protected function centerLoader(e:Event):void {
			if (stage) {
				_ldr.x = stage.stageWidth / 2;
				_ldr.y = stage.stageHeight / 2;
			}
		}
		
		
		/**
		 * Catching the errors so they won't go uncaught.
		 * @param e error event
		 */
		protected function clearListeners(e:Event):void {
			_ldr.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, clearListeners, false);
			_ldr.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, clearListeners, false);
			_ldr.contentLoaderInfo.removeEventListener(Event.INIT, clearListeners, false);
		}
		
		
		/**
		 * Starts the real application by creating an instance of kdp3.
		 */
		protected function go(e:Event):void {
			_isGoing = true;
			loaderInfo.removeEventListener(Event.COMPLETE, go);
			nextFrame();
			
			var mainClass:Class = Class(getDefinitionByName("kdp3"));
			if (mainClass) {
				_app = new mainClass();
				(_app as DisplayObject).addEventListener(Event.ADDED_TO_STAGE, onAppAddedToStage);
				addChild(_app as DisplayObject);
								
				if (_flashvars) {
					_app.flashvars = _flashvars;
				}
				if (_shouldInit) {
					_app.init(_kml);
				}
			}
		}
		
		private function onAppAddedToStage (e : Event) : void
		{
			if (_width) {
				_app.width = _width;
			}
			if (_height) {
				_app.height = _height;
			}
		}
		
		protected function stopImmediatePropagation(event:Event):void {
			event.stopImmediatePropagation();
		}
		
		/* -----------------------------------------------------------------
		* ------------------------------------------------------------------
		*		  interface methods; delegated to the kdp3 instance
		* ------------------------------------------------------------------
		* ------------------------------------------------------------------ */
		
		public function set flashvars(obj:Object):void {
			if (_app) {
				_app.flashvars = obj;
			}
			else {
				_flashvars = obj;
			}
		}
		
		
		public function get flashvars():Object {
			if (_app) {
				return _app.flashvars;
			}
			else {
				return _flashvars;
			}
		}
		
		
		public function get preloader():DisplayObject {
			return _ldr;
		}
		
		
		override public function get height():Number {
			return _height;
		}
		
		
		override public function set height(value:Number):void {
			if (value == _height) return;
			//super.height = value;
			_height = value;
			if (_app) {
				_app.height = value;
			}
		}
		
		
		override public function get width():Number {
			return _width;
		}
		
		
		override public function set width(value:Number):void {
			if (value == _width) return;
			//super.width = value;
			_width = value;
			if (_app) {
				_app.width = value;
			}
		}
		
		
		/**
		 * a reference to application parameters
		 * */
		public function get parameters():Object {
			return loaderInfo.parameters;
		}
		
		
		public function init(kml:XML = null):void {
			if (_app) {
				_app.init(kml);
			}
			else {
				_kml = kml;
				_shouldInit = true;
			}
		}
		
		
		public function sendNotification(notificationName:String, body:Object = null, type:String = null):void {
			_app.sendNotification(notificationName, body, type);
		}
		
		
		public function evaluate(expression:String):Object {
			return _app.evaluate(expression);
		}
		
		
		public function setAttribute(componentName:String, prop:String, newValue:String):void {
			_app.setAttribute(componentName, prop, newValue);
		}
		
		
		public function dispose():void {
			_app.dispose();
		}
		
	}
}