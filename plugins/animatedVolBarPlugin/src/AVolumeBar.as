package
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class AVolumeBar extends Sprite
	{
		private var _inactiveState:DisplayObject;
		private var _overState:DisplayObject;
		private var _activeState:DisplayObject;
		
		private var _view:MovieClip;
		public static const VOLUME_BAR_OVER:String		= "volumeBarOver";
		public static const VOLUME_BAR_SELECTED:String	= "volumeBarSelected";
		public static const VOLUME_BAR_OUT:String	= "volumeBarOut";
		public function AVolumeBar(view:MovieClip)
		{
			_view			= view;
			_view.gotoAndStop("activeState");
			buttonMode		= true;
			addChild(_view);
			this.addEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
			this.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			this.addEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
			
			super();
		}
	
		private function onMouseOut(e:MouseEvent):void{
			this.dispatchEvent(new Event(VOLUME_BAR_OUT));
		}
		
		private function onMouseDown(e:MouseEvent):void{
			this.dispatchEvent(new Event(VOLUME_BAR_SELECTED));
		}
		
		private function onMouseOver(e:MouseEvent):void{
			this.dispatchEvent(new Event(VOLUME_BAR_OVER));
		}
		
		public function set isActive(bool:Boolean):void{
			(bool)?_view.gotoAndStop("activeState"):_view.gotoAndStop("inactiveState");
		}
		
		
		public function set overState(bool:Boolean):void{
			_view.gotoAndStop("overState");
		}
		
	}
}