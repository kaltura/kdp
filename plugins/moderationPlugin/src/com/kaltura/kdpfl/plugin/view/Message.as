package com.kaltura.kdpfl.plugin.view
{
	import com.kaltura.kdpfl.view.containers.KVBox;
	import com.kaltura.kdpfl.view.controls.KLabel;
	import com.kaltura.kdpfl.view.controls.KTextField;
	
	import flash.events.Event;
	import flash.utils.setTimeout;
	
	public class Message extends KVBox {
		
		public static const HIDE:String = "hide";
		
		private var _headerText:String = '';
		
		private var _windowText:String = '';
		
		private var _timeout:int = 0;
		
		
		public function Message(configuration:Array=null) {
			super(configuration);
			drawScreen();
		}
		
		/**
		 * create the screen ui
		 */
		private function drawScreen():void {
			var availableWidth:Number = 290;
			this.paddingLeft = 5;
			this.paddingRight = 5;
//			this.paddingTop = 5;
			this.paddingBottom = 5;
			
			var lbl:KLabel = new KLabel();
			lbl.name = "windowTitle";
			lbl.width = availableWidth;
			lbl.text = _headerText;
			addChild(lbl);
			
			var txt:KTextField = new KTextField();
			txt.name = "windowText";
			txt.truncateToFit = false;
			txt.width = availableWidth;
			txt.height = 70;
			txt.text = _windowText;
			addChild(txt);
			
			setSkin("aa");
		}
		
		
		/**
		 * hides the message 
		 * @param delay	time (in seconds) to keep the message on screen before closing
		 */		
		public function close(delay:int = undefined):void {
			if (delay) {
				_timeout = delay * 1000;
			}
			setTimeout(hideMessage, _timeout);
		}
		
		private function hideMessage():void {
			addEventListener(Event.ENTER_FRAME, hideHelper);
		}
		
		private function hideHelper(e:Event):void {
			if (this.alpha > 0) {
				this.alpha -= 0.1;
			}
			else {
				dispatchEvent(new Event(Message.HIDE));
				this.alpha = 1;
				removeEventListener(Event.ENTER_FRAME, hideHelper);
			}
		}
		
		/**
		 * we don't actually allow changing the skin. it's hardcoded.
		 * @param styleName		alleged style name, ignored.
		 * @param setSkinSize	something to do with button skin size, ignored.
		 */		
		override public function setSkin(styleName:String, setSkinSize:Boolean=false):void {
			super.setSkin("Mod_darkBg");
			(this.getChildByName("windowTitle") as KLabel).setSkin("Mod_title", setSkinSize);
			(this.getChildByName("windowText") as KTextField).setSkin("Mod_text", setSkinSize);
		}
		
		/**
		 * the title of the message window
		 */
		public function get headerText():String {
			return _headerText;
		}
		
		
		/**
		 * @private
		 */
		public function set headerText(value:String):void {
			(this.getChildByName("windowTitle") as KLabel).text = value;
			_headerText = value;
		}
		
		/**
		 * the text explaining what to do
		 */
		public function get windowText():String {
			return _windowText;
		}
		
		
		/**
		 * @private
		 */
		public function set windowText(value:String):void {
			(this.getChildByName("windowText") as KTextField).text = value;
			_windowText = value;
		}

	}
}