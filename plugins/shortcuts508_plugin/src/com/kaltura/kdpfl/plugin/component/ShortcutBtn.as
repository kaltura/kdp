package com.kaltura.kdpfl.plugin.component
{
	import com.kaltura.kdpfl.view.controls.KButton;
	import flash.events.FocusEvent;
 
	public class ShortcutBtn
	{
		public var button:KButton;
		public var action:String;
		public var params : *;
		public var keyCode:int;
		public var isCtrl:Boolean;
		public var isShift:Boolean;
		public var isAlt:Boolean;
		
		public function ShortcutBtn (button:KButton = null, action:String = "",  params : * =null, keyCode:int = 0,
									isCtrl:Boolean = false, isShift:Boolean = false, isAlt:Boolean = false,
									onFocusIn:Function = null, onFocusOut:Function = null)
		{
			this.button = button;
			this.action = action;
			this.params = params;
			this.keyCode = keyCode;
			this.isCtrl = isCtrl;
			this.isShift = isShift;
			this.isAlt = isAlt;

			button.addEventListener(FocusEvent.FOCUS_IN, onFocusIn);
			button.addEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
		}
	}
}