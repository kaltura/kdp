package com.kaltura.kdpfl.plugin.view {
	import com.kaltura.kdpfl.view.containers.KHBox;
	import com.kaltura.kdpfl.view.containers.KVBox;
	import com.kaltura.kdpfl.view.controls.KButton;
	import com.kaltura.kdpfl.view.controls.KComboBox;
	import com.kaltura.kdpfl.view.controls.KLabel;
	import com.kaltura.kdpfl.view.controls.KTextField;
	
	import fl.data.DataProvider;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.setTimeout;

	public class ModerationScreen extends KVBox {

		
		private var _headerText:String = 	'Report this content as inappropriate';
		private var _windowText:String = 	"Please describe your concern about " +
											"the video, so that we can review it and determine whether it " +
											"isn't appropriate for all viewers.";

		private var _reasonsDataProvider:Array = [];
		private var btnSubmit:KButton;


		public function ModerationScreen() {
			super();
			drawScreen();
		}


		/**
		 * create the screen ui
		 */
		private function drawScreen():void {
			this.paddingLeft = 5;
			this.paddingRight = 5;
//			this.paddingTop = 5;
//			this.paddingBottom = 5;
			this.verticalGap = 3;
			var availableWidth:Number = 290; 

			var lbl:KLabel = new KLabel();
			lbl.width = availableWidth;
			lbl.name = "windowTitle";
			lbl.text = _headerText;
			addChild(lbl);

			var txt:KTextField = new KTextField();
			txt.name = "windowText";
			txt.truncateToFit = false;
			txt.width = availableWidth;
			txt.height = 50;
			txt.text = _windowText;
			addChild(txt);

			var cb:KComboBox = new KComboBox();
			cb.name = "cbReasons";
			cb.width = 150;
			cb.dataProvider = new DataProvider(_reasonsDataProvider);
			addChild(cb);

			var ti:KTextField = new KTextField();
			ti.name = "tiDescription";
			ti.editable = true;
			ti.truncateToFit = false;
			ti.borderColor = 0x4D4D4D;
			ti.border = true;
//			ti.background = true;
//			ti.backgroundColor = 0xff00ff;//TODO bring from outside.
			ti.width = availableWidth;
			ti.height = 100;
			addChild(ti);

			var hbox:KHBox = new KHBox();
			hbox.name = "controlBar";
			hbox.width = availableWidth;
			hbox.horizontalGap = 3;
			hbox.paddingLeft = 1;
			hbox.paddingRight = 1;
			hbox.paddingTop = 3;
			hbox.paddingBottom = 3;
//			hbox.horizontalAlign = "right"; 
			addChild(hbox);

			btnSubmit = new KButton();
			btnSubmit.name = "btnSubmit";
			btnSubmit.label = "submit";
			btnSubmit.addEventListener(MouseEvent.CLICK, notifyClick);
			btnSubmit.maxHeight = 20;
			hbox.addChild(btnSubmit);

			var btn:KButton = new KButton();
			btn.name = "btnCancel";
			btn.label = "cancel";
			btn.addEventListener(MouseEvent.CLICK, notifyClick);
			btn.maxHeight = 20;
			hbox.addChild(btn);
			
			setSkin("some name");
		}

		
		
		/**
		 * dispatch a relevant event
		 * @param e
		 */
		private function notifyClick(e:MouseEvent):void {
			if (e.target.name == "btnSubmit") {
				delayMultiPosting();
				dispatchEvent(new Event(ModerationPlugin.SUBMIT));
			}
			else if (e.target.name == "btnCancel") {
				dispatchEvent(new Event(ModerationPlugin.CANCEL));
			}
		}
		
		/**
		 * Delayed submit button for 5 sec to prevent multiple sending 
		 */		
		private function delayMultiPosting():void
		{
			btnSubmit.enabled = false;
			setTimeout(reEnableSubmitButton,5000);
		}
		/**
		 * Re Enable the button
		 */
		private function reEnableSubmitButton():void
		{
			btnSubmit.enabled = true;
		}
		
		
		/**
		 * we don't actually allow changing the skin. it's hardcoded.
		 * @param styleName		alleged style name, ignored.
		 * @param setSkinSize	something to do with button skin size, ignored.
		 */		
		override public function setSkin(styleName:String, setSkinSize:Boolean=false):void {
			super.setSkin( "Mod_darkBg");
			(this.getChildByName("windowTitle") as KLabel).setSkin("Mod_title", setSkinSize);
			(this.getChildByName("windowText") as KTextField).setSkin( "Mod_text", setSkinSize);
			(this.getChildByName("cbReasons") as KComboBox).setSkin("_mod", setSkinSize);
			(this.getChildByName("tiDescription") as KTextField).setSkin("Mod_text", setSkinSize);
			var hbox:KHBox = this.getChildByName("controlBar") as KHBox;
			(hbox.getChildByName("btnSubmit") as KButton).setSkin("mod", setSkinSize);
			(hbox.getChildByName("btnCancel") as KButton).setSkin("mod", setSkinSize);
		}


		/**
		 * clears the data entered in the form
		 * */
		public function clearData():void {
			(this.getChildByName("cbReasons") as KComboBox).selectedIndex = -1;
			(this.getChildByName("tiDescription") as KTextField).text = "";
		}


		/**
		 * data entered in the form,
		 * {reason, description}
		 */
		public function get data():Object {
			var reason:Object = (this.getChildByName("cbReasons") as KComboBox).selectedItem.type;
			var description:String = (this.getChildByName("tiDescription") as KTextField).text;
			return {reason: reason, comments: description};
		}


		/**
		 * the title of the flagging window
		 */
		public function get headerText():String {
			return _headerText;
		}


		/**
		 * @private
		 */
		public function set buttonsPosition(value:String):void {
			(this.getChildByName("controlBar") as KHBox).horizontalAlign = value;
		}


		/**
		 * alignment of submit and cancel buttons
		 */
		public function get buttonsPosition():String {
			return (this.getChildByName("controlBar") as KHBox).horizontalAlign;
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


		public function get reasonsDataProvider():Array {
			return _reasonsDataProvider;
		}


		public function set reasonsDataProvider(value:Array):void {
			(this.getChildByName("cbReasons") as KComboBox).dataProvider = new DataProvider(value);
			_reasonsDataProvider = value;
		}

	}
}