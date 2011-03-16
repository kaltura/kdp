package {
	import com.kaltura.kdpfl.ApplicationFacade;
	import com.kaltura.kdpfl.events.DynamicEvent;
	import com.kaltura.kdpfl.model.ExternalInterfaceProxy;
	import com.kaltura.kdpfl.model.LayoutProxy;
	import com.kaltura.kdpfl.model.type.NotificationType;
	import com.kaltura.kdpfl.view.controls.BufferAnimation;
	
	import fl.events.ComponentEvent;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	import flash.system.ApplicationDomain;
	import flash.system.Security;

	[SWF(backgroundColor=0xEEEEEE, frameRate=30)]
	[Frame(factoryClass="ApplicationLoader")]
	/**
	 * Main class of the KDP3 
	 * @author Hila
	 * 
	 */	
	public class kdp3 extends Sprite implements IKDP3 {

		/**
		 * One time reference to the Pure MVC facade
		 */
		private var _facade:ApplicationFacade = ApplicationFacade.getInstance();

		/**
		 * the flashvars that we recive from outside and from
		 */
		private var _flashvars:Object;


		/**
		 * _initialized is set to true by the init function
		 */
		private var _initialized:Boolean = false;


		/**
		 * KDP_3 Constructor
		 *
		 */
		public function kdp3() {

			Security.allowDomain("*");

			if (this.stage)
				onAddedToStage();
			else
				addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

			//var customContextMenu:ContextMenu = new ContextMenu();


			//when loaded into flex application there are some events that has the same name
			//in flex and in fl like ComponentEvent and Flex event when those events propagate 
			//to flex they explode because the eventdispatcher try to cast them to flex event
			//to work around this i stoped the propagation of some common events
			this.addEventListener(ComponentEvent.HIDE, stopImmediatePropagation);
			this.addEventListener(ComponentEvent.SHOW, stopImmediatePropagation);
		}


		private function stopImmediatePropagation(event:Event):void {
			event.stopImmediatePropagation();
		}



		//PUBLIC FLASH/FLEX WRAPPER API
		////////////////////////////////////////////////////////
		/**
		 * A way to set flashvars from Flex/Flash container
		 * @param obj
		 *
		 */
		public function set flashvars(obj:Object):void {
			_flashvars = obj;
		}


		/**
		 * after init the flashvars change to be the global flashvars and not only the flashvars that passed from the wrapper
		 * @return
		 *
		 */
		public function get flashvars():Object {
			return _flashvars;
		}


		/**
		 * Start the KDP sequence commands to build layout, load styles and set them, add add the main built view to
		 * the stage.
		 *
		 * this method is called automaticlly on stand alone KDP, but a KDP in a Flex/Flash wrapper should call init()
		 * by itself
		 */
		public function init(kml:XML = null):void {
			_initialized = true;


			//start the lifecycle of the 
			_facade.start(this.root);
			this.root.addEventListener("skinLoaded", onSkinLoaded);
			// pass the real root and not a kdp3 instance
		
		    
			if (_width) {
				width = _width;
			}
			if (_height) {
				height = _height;
			}

			//if other application want to inject the uiconf in runtime we use this with flashvar.kml=inject
			if (kml)
				(_facade.retrieveProxy(LayoutProxy.NAME) as LayoutProxy).vo.layoutXML = kml;
		}
		
		/**
		 * This function is activated after the skin is loaded and there is no further need for the preloader. 
		 * @param e - the event signifying that the skin has loaded.
		 * 
		 */		
		protected function onSkinLoaded (e : DynamicEvent) : void
		{
			var appLoader : ApplicationLoader = e.target as ApplicationLoader;
			if (appLoader && appLoader.getChildIndex(appLoader.preloader) != -1) {
				appLoader.removeChild(appLoader.preloader);
			}
		}

		/**
		 * Flex Application that load the KDP can use sendNotification to dispatch notifications
		 * @param notificationName
		 * @param body
		 * @param type
		 *
		 */
		public function sendNotification(notificationName:String, body:Object = null, type:String = null):void {
			_facade.sendNotification(notificationName, body, type);
		}


		/**
		 * KDP 3 Provide a way to set any data attribute using this function from any Flash/Flex Container
		 * @param componentName
		 * @param prop
		 * @param newValue
		 *
		 */
		public function evaluate(expression:String):Object {
			return (_facade.retrieveProxy(ExternalInterfaceProxy.NAME) as ExternalInterfaceProxy).evaluate(expression);
		}


		/**
		 * KDP 3 Provide a way to set any data attribute using this function from any Flash/Flex Container
		 * @param componentName
		 * @param prop
		 * @param newValue
		 *
		 */
		public function setAttribute(componentName:String, prop:String, newValue:String):void {
			(_facade.retrieveProxy(ExternalInterfaceProxy.NAME) as ExternalInterfaceProxy).setAttribute(componentName, prop, newValue);
		}


		/**
		 * Free memory and clean static vars that use to store KDP configuration
		 */
		public function dispose():void {
			_facade.dispose();
		}
		///////////////////////////////////////////////////////////

		/**
		 * width as requested by the loading application
		 */
		public var _width:Number = 0;

		/**
		 * height as requested by the loading application
		 */
		public var _height:Number = 0;


		/**
		 * returns the requested width instead of the current width which is initially set
		 * within the compiled swf
		 * @return the requested width
		 *
		 */
		override public function get width():Number {
			return _width;
		}


		/**
		 * returns the requested height instead of the current height which is initially set
		 * within the compiled swf
		 * @return the requested height
		 *
		 */
		override public function get height():Number {
			return _height;
		}


		/**
		 * save the requested width.
		 * if the application has been initialized set the sprite width and send a resize notification
		 * @param value the requested width
		 *
		 */
		override public function set width(value:Number):void {
			_width = value;

			if (_initialized) {
				super.width = _width;
				_facade.sendNotification(NotificationType.ROOT_RESIZE, {width: _width, height: _height});
			}
		}


		/**
		 * save the requested height.
		 * if the application has been initialized set the sprite height and send a resize notification
		 * @param value the requested height
		 *
		 */
		override public function set height(value:Number):void {
			_height = value;

			if (_initialized) {
				super.height = _height;
				_facade.sendNotification(NotificationType.ROOT_RESIZE, {width: _width, height: _height});
			}
		}


		/**
		 * Override addChild to make sure that the loader is always on top
		 * @param child
		 * @return
		 *
		 */
		override public function addChild(child:DisplayObject):DisplayObject {
			super.addChild(child);

			//search if there is a preloader and move it on top
			if (!(child is BufferAnimation)) {
				for (var i:int = 0; i < this.numChildren; i++) {
					if (this.getChildAt(i) is BufferAnimation) {
						super.addChild(this.getChildAt(i));
						break;
					}
				}
			}
			return child;
		}


		/**
		 * When added to Stage tha application fire it's init process
		 * @param event
		 *
		 */
		private function onAddedToStage(event:Event = null):void {
			this.stage.addEventListener(FullScreenEvent.FULL_SCREEN, onFullScreenEvt);

			//if this is standalone application the root parent is the stage so start loading sequence
			try {
				if (root.stage && root.parent && root.stage == root.parent) {
					stage.scaleMode = StageScaleMode.NO_SCALE;
					stage.align = StageAlign.TOP_LEFT;
	
					init();
				}
			}
			catch (e : SecurityError )
			{
				stage.scaleMode = StageScaleMode.NO_SCALE;
				stage.align = StageAlign.TOP_LEFT;
				
				init();
			}
		}


		/**
		 * If the fullscreen mode was changed notify to all
		 */
		private function onFullScreenEvt(event:FullScreenEvent):void {
			if (event.fullScreen)
				sendNotification(NotificationType.HAS_OPENED_FULL_SCREEN);
			else
				sendNotification(NotificationType.HAS_CLOSED_FULL_SCREEN);
		}
	}
}
