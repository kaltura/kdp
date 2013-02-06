package
{
	import fl.core.InvalidationType;
	import fl.core.UIComponent;
	import fl.managers.IFocusManagerComponent;
	import fl.managers.StyleManager;
	
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.utils.Dictionary;
	
	public class AnimatedUIComponent extends UIComponent
	{
		public function AnimatedUIComponent()
		{
			super();
			/*
			instanceStyles = {};
			sharedStyles = {};
			invalidHash = {};
			
			callLaterMethods = new Dictionary();
			
			StyleManager.registerInstance(this);
			
			configUI();
			invalidate(InvalidationType.ALL);
			// We are tab enabled by default if IFocusManagerComponent
			tabEnabled = (this is IFocusManagerComponent);
			// We do our own focus drawing.
			focusRect = false;
			
			// Register for focus and keyboard events.
			if (tabEnabled) {
				addEventListener(FocusEvent.FOCUS_IN, focusInHandler);
				addEventListener(FocusEvent.FOCUS_OUT, focusOutHandler);
				addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
				addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
			}
			addEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
			initializeFocusManager()
			addEventListener(Event.ENTER_FRAME, hookAccessibility, false, 0, true);
			*/
		}
		
		/**
		 * @private
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 */
		private function initializeFocusManager():void {
			// create root FocusManager
			if(stage == null) {
				// we don't have stage yet, wait for it
				addEventListener(Event.ADDED_TO_STAGE, addedHandler, false, 0, true);
			} else {
				// we have stage: if not already created, create FocusManager
				createFocusManager();
			}
		}
		
		/**
		 * @private
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 */
		private function addedHandler(evt:Event):void {
			removeEventListener("addedToStage", addedHandler);
			initializeFocusManager();
		}
	}
}