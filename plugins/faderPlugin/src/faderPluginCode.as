package {
	import com.kaltura.kdpfl.plugin.IPlugin;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.setTimeout;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	import org.puremvc.as3.interfaces.IFacade;

	public class faderPluginCode extends Sprite implements IPlugin {
		/**
		 * The DisplayObject to show/hide 
		 */		
		public var target:DisplayObject;
		
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
		
		public function faderPluginCode() 
		{
		}


		public function initializePlugin(facade:IFacade):void {
			if (target != null && hoverTarget != null) {
				alpha_dis = 1 / (duration * 30);
				//
				hoverTarget.addEventListener(MouseEvent.MOUSE_OVER, onHoverOver);
				hoverTarget.addEventListener(MouseEvent.MOUSE_OUT, onHoverOut);
			}
			if(autoHide=="true")
			{
				hideTargetTimer = new Timer (delay);
				hideTargetTimer.addEventListener(TimerEvent.TIMER,onTimerEnd);
				hoverTarget.addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
			}
		}
		/**
		 * If we got to this function - it means that we need to hide the target
		 */
		public function onTimerEnd(evt:TimerEvent) : void
		{
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
			alpha_dir = 1;
			//
			if (fadeInDelay > 0) {
				setTimeout(startHoverAnim, fadeInDelay * 1000);
			}
			else {
				startHoverAnim();
			}
		}
		public function onMouseMove(evt:MouseEvent) : void
		{
			onHoverOver();
			hideTargetTimer.stop();
			hideTargetTimer.start();
		}		


		private function onHoverOut(event:MouseEvent=null):void {
			alpha_dir = -1;
			//
			if (fadeOutDelay > 0) {
				setTimeout(startHoverAnim, fadeOutDelay * 1000);
			}
			else {
				startHoverAnim();
			}
		}


		private function startHoverAnim():void {
			removeEventListener(Event.ENTER_FRAME, onFade);
			addEventListener(Event.ENTER_FRAME, onFade);
			target.visible = true;
		}


		private function onFade(event:Event):void {
			target.alpha += alpha_dir * alpha_dis;
			if (target.alpha <= 0) {
				target.alpha = 0;
				target.visible = false;
				removeEventListener(Event.ENTER_FRAME, onFade);
			}
			else if (target.alpha >= 1) {
				target.alpha = 1;
				removeEventListener(Event.ENTER_FRAME, onFade);
			}
		}
	}
}