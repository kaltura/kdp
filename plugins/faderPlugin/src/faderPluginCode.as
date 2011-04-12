package {
	import com.kaltura.kdpfl.model.LayoutProxy;
	import com.kaltura.kdpfl.plugin.DisplayObjectArray;
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.util.KTextParser;
	
	import fl.core.UIComponent;
	import fl.events.ComponentEvent;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import flash.utils.Timer;
	import flash.utils.setTimeout;
	
	import org.puremvc.as3.interfaces.IFacade;

	public class faderPluginCode extends Sprite implements IPlugin {
		protected var _target:Object;
		
		protected var targetDisplayObjects : DisplayObjectArray = new DisplayObjectArray();
		
		
		protected var _disregardForegroundLayer : Boolean = true;
		/**
		 * The DispalyObject that controls visibility
		 */		
		public var hoverTarget:DisplayObject;
		
		/**
		 * Fade effect duration
		 */		
		public var duration:Number = 1;
		
		/**
		 * Delay before fade in effect 
		 */		
		public var fadeInDelay:Number = 0;
		
		/**
		 * Delay before fade out effect
		 */		
		public var fadeOutDelay:Number = 1;
		
		
		//
		private var alpha_dir:Number = 0;
		private var alpha_dis:Number = 0;


		public var delay:Number = 1500;
		public var autoHide:String = "false";

		private var delayFlag:Boolean = true;
		private var hideTargetTimer:Timer;
		private var foreground : UIComponent;
		
		private var _isTimerOut : Boolean = false;
		
		public function faderPluginCode() 
		{
		}


		public function initializePlugin(facade:IFacade):void {
			if (_target && hoverTarget != null) {
				alpha_dis = 1 / (duration * 30);
				
				if (_target is Array)
					parseDisplayObjectArray(facade);
				else
					targetDisplayObjects.push(_target);
				//
				hoverTarget.addEventListener(MouseEvent.ROLL_OVER, onHoverOver);
				hoverTarget.addEventListener(MouseEvent.ROLL_OUT, onHoverOut);
			}
			if(autoHide=="true")
			{
				hideTargetTimer = new Timer (delay);
				hideTargetTimer.addEventListener(TimerEvent.TIMER,onTimerEnd);
				hoverTarget.addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
			}
			
			foreground = (facade.retrieveProxy(LayoutProxy.NAME) as LayoutProxy).vo.foreground;
			targetDisplayObjects.push(foreground);
		}
		/**
		 * If we got to this function - it means that we need to hide the target
		 */
		public function onTimerEnd(evt:TimerEvent) : void
		{
			_isTimerOut = true;
			hideTargetTimer.stop();
			onHoverOut();
		}

		/**
		 * Interface Method. since this plugin is not a visual one, 
		 * no implementation is required. 
		 * @param styleName
		 * @param setSkinSize
		 */		
		public function setSkin(styleName:String, setSkinSize:Boolean = false):void {

		}
 

		////////////////////////////////////////
		// hover
		private function onHoverOver(event:MouseEvent=null):void {
			
			if(!_isTimerOut)
			{
				alpha_dir = 1;
				//
				if (fadeInDelay > 0) {
					setTimeout(startHoverAnim, fadeInDelay * 1000);
				}
				else {
					startHoverAnim();
				}
			}
		}
		public function onMouseMove(evt:MouseEvent) : void
		{
			_isTimerOut = false;
			onHoverOver();
			hideTargetTimer.stop();
			hideTargetTimer.start();
		}		


		private function onHoverOut(event:MouseEvent=null):void {

			var isMouseXInLimit : Boolean = false;
			var isMouseYInLimit : Boolean = false;
			if (event)
			{
				isMouseXInLimit = (event.stageX > 0) && (event.stageX < hoverTarget.width);
				isMouseYInLimit = (event.stageY > 0) && (event.stageY < hoverTarget.height);
			}

			
			if (!isMouseXInLimit || !isMouseYInLimit)
			{
				alpha_dir = -1;
				//
				if (fadeOutDelay > 0) {
					setTimeout(startHoverAnim, fadeOutDelay * 1000);
				}
				else {
					startHoverAnim();
				}
			}
		}
		

		private function startHoverAnim():void {
			removeEventListener(Event.ENTER_FRAME, onFade);
			addEventListener(Event.ENTER_FRAME, onFade);
			targetDisplayObjects.visible =  true;
			
		}


		private function onFade(event:Event):void {
			targetDisplayObjects.alpha += alpha_dir * alpha_dis;
			
			if (targetDisplayObjects.alpha <= 0) {
				targetDisplayObjects.alpha = 0;
				
				targetDisplayObjects.visible = false;
				removeEventListener(Event.ENTER_FRAME, onFade);
			}
			else if (targetDisplayObjects.alpha >= 1) {
				targetDisplayObjects.alpha = 1;
				
				removeEventListener(Event.ENTER_FRAME, onFade);
			}
		}
		
		private function parseDisplayObjectArray (facade : IFacade) : void
		{
			for (var index:int =0; index < _target.length; index++)
			{
				targetDisplayObjects.push(facade["bindObject"][_target[index]]);
			}
		}

		[Bindable]
		public function get target():Object
		{
			return _target;
		}

		public function set target(value:Object):void
		{
			if (value is DisplayObject)
			{
				_target = value;
			}
			else
			{
				var displayObjectIdArray : Array = value.split(",");
				_target = displayObjectIdArray;
			}
		}

	}
}