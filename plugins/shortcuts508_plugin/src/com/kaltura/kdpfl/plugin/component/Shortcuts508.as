package com.kaltura.kdpfl.plugin.component
{
	//import com.kaltura.kdpfl.component.IComponent;
	
	import com.kaltura.kdpfl.view.controls.KButton;
	
	import fl.core.UIComponent;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.getQualifiedClassName;
	import flash.utils.setTimeout;
	
	import org.puremvc.as3.interfaces.IFacade;

 
	public class Shortcuts508 extends Sprite //implements IComponent
	{
		private var _btnMap:Array;
		private var facade:IFacade;
		private var _btnPlay:KButton;
		private var _disableShortcuts : Boolean = false;
		
		private const RELEASE_INTERVAL:int = 200;

		public function Shortcuts508()
		{	
		}

		public function setButtons(playBtn:KButton, backBtn:KButton, fwdBtn:KButton, muteBtn:KButton, volDownBtn:KButton, volUpBtn:KButton, fsBtn:KButton, ccBtn:KButton, adBtn:KButton):void
		{
			_btnMap = new Array ();
			_btnMap.push(new ShortcutBtn (playBtn, "shortcutPlay",null, 80, false, false, false, onFocusIn, onFocusOut));
			_btnMap.push(new ShortcutBtn (backBtn, "seekBackwards",5 , 82, false, false, false, onFocusIn, onFocusOut));
			_btnMap.push(new ShortcutBtn (fwdBtn, "seekForward", 5 ,70, false, false, false, onFocusIn, onFocusOut));
			_btnMap.push(new ShortcutBtn (muteBtn, "volume508mute",null, 77, false, false, false, onFocusIn, onFocusOut));
			_btnMap.push(new ShortcutBtn (volDownBtn, "volume508down",null, 68, false, false, false, onFocusIn, onFocusOut));
			_btnMap.push(new ShortcutBtn (volUpBtn, "volume508up",null,  85, false, false, false, onFocusIn, onFocusOut));
			_btnMap.push(new ShortcutBtn (fsBtn, "shortcutFullScreen", null, 13, false, false, false, onFocusIn, onFocusOut));
			_btnMap.push(new ShortcutBtn (ccBtn, "showHideClosedCaptions",null, 67, false, false, false, onFocusIn, onFocusOut));
			_btnMap.push(new ShortcutBtn (adBtn, "audioDescriptionClicked", null, 65, false, false, false, onFocusIn, onFocusOut));
			
			_btnPlay = playBtn;
			
			playBtn.setFocus();
		}
		
		public function setClosedCaptionsToOff ():void
		{
			var event:KeyboardEvent = new KeyboardEvent ("");
			event.keyCode = 67;
			event.ctrlKey = false;
			event.shiftKey = false;
			event.altKey = false;
			
			onKeyDown (event);
			_btnPlay.setFocus();
		}
		
		public function setAudioDescriptionToOff ():void
		{
			var event:KeyboardEvent = new KeyboardEvent ("");
			event.keyCode = 65;
			event.ctrlKey = false;
			event.shiftKey = false;
			event.altKey = false;
			
			onKeyDown (event);
			_btnPlay.setFocus();
		}

		private function onFocusIn(event:FocusEvent):void
		{
			var btn:KButton = event.target as KButton;
			btn.emphasized = true;
		}

		private function onFocusOut(event:FocusEvent):void
		{
			var btn:KButton = event.target as KButton;
			btn.emphasized = false;
		}

		public function onKeyDown (event:KeyboardEvent):void
		{
			
				
			for (var i:int = 0; i < _btnMap.length; i++)
			{
				var btn:ShortcutBtn  = _btnMap [i] as ShortcutBtn;
				
				if (btn.keyCode == event.keyCode && btn.isCtrl == event.ctrlKey && btn.isShift == event.shiftKey && btn.isAlt == event.altKey && !disableShortcuts)
				{
					btn.button.setFocus();
					
					
					btn.button.dispatchEvent(new MouseEvent(MouseEvent.CLICK) );
					
				}
			}
		}
				
		public function initialize():void
		{
		}
				
		public function added(facade:IFacade):void
		{
			this.facade = facade;
			
			var stage:DisplayObject = this;
			while (stage != null)
			{
				if (flash.utils.getQualifiedClassName (stage) == "flash.display::Stage")
				{
					break;
				}
				
				stage = stage.parent;
			}
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}
		
		private function onPlayerFocus (e : FocusEvent) : void
		{
			trace("hila");
		}
		
		public function setSize(width:Number, height:Number):void
		{
			this.width = width;
			this.height = height;
		}

		public function get disableShortcuts():Boolean
		{
			return _disableShortcuts;
		}

		public function set disableShortcuts(value:Boolean):void
		{
			_disableShortcuts = value;
		}

	}
}