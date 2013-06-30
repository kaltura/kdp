package com.kaltura.kdpfl.view {
	import com.kaltura.kdpfl.view.containers.KHBox;
	import com.kaltura.kdpfl.view.controls.KButton;
	import com.kaltura.kdpfl.view.events.AnnotationEvent;
	import com.kaltura.kdpfl.view.strings.AnnotationStrings;
	import com.kaltura.vo.KalturaAnnotation;
	
	import fl.core.UIComponent;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.xml.XMLNode;
	import flash.xml.XMLNodeType;
	import flash.display.DisplayObject
	
	/**
	 * Visual rperesentation of a single annotation in the annotations box.
	 */
	public class Annotation extends UIComponent {
		protected var _viewMode:String;
		
		private var _kalturaAnnotation:KalturaAnnotation;
		
		public static var userMode:String;
		public static const ANNOTATION_HEIGHT:int = 40;
		
		public static const ANNOTATION_PROMPT:String = "Enter your annotation text here...";
		
		private var annotationTextField:TextField = new TextField();
		private var _annotaionBox:KHBox = new KHBox();
		
		private var annotationTextFormat:TextFormat = new TextFormat("Arial", 11);
		
		//visual seperator between annotations
		private var _seperator:Sprite;
		
		private var _initialTabIndex:int;
		
		/**
		 * max characters for a single annotation 
		 */		
		public static var maxChars:int = 0;
		
		/**
		 * is text longer than maxChars defined
		 */
		private var _textExceedsLength:Boolean = false;
		
		
		public function Annotation(n_viewMode:String, n_inTime:Number = -1, n_annotationText:String = ANNOTATION_PROMPT, n_entryId:String = "", n_kalturaAnnotation:KalturaAnnotation = null, tabIndex:int = 0) {
			annotationTextField.defaultTextFormat = annotationTextFormat;
			_annotaionBox.horizontalScrollPolicy = "off";
			_annotaionBox.verticalAlign = "middle";
			_annotaionBox.paddingTop = 0;
			_annotaionBox.height = ANNOTATION_HEIGHT;
			_initialTabIndex = tabIndex;
			if (!n_kalturaAnnotation) {
				_kalturaAnnotation = new KalturaAnnotation();
				_kalturaAnnotation.text = n_annotationText;
				_kalturaAnnotation.startTime = n_inTime;
				_kalturaAnnotation.entryId = n_entryId;
			}
			else {
				_kalturaAnnotation = n_kalturaAnnotation;
			}
			this.viewMode = n_viewMode;
			annotationTextField.autoSize = TextFieldAutoSize.LEFT;
			annotationTextField.wordWrap = true;
			annotationTextField.mouseWheelEnabled = false;		

			annotationTextField.addEventListener(Event.CHANGE, onTextFieldEdit);
			
			if (_kalturaAnnotation.text == Annotation.ANNOTATION_PROMPT) {
				annotationTextField.addEventListener(MouseEvent.CLICK, onAnnotationClick);
				annotationTextField.addEventListener(KeyboardEvent.KEY_DOWN, onAnnotationClick);
			}
		}
		
		
		public function get viewMode():String {
			return _viewMode;
		}
		
		
		public function set viewMode(value:String):void {
			_viewMode = value;
			if (_viewMode == AnnotationStrings.VIEW_MODE) {
				gotoViewMode();
			}
			if (_viewMode == AnnotationStrings.EDIT_MODE) {
				gotoEditMode();
			}
		}
		
		
		public function get annotationText():String {
			return _kalturaAnnotation.text;
		}
		
		
		public function set annotationText(value:String):void {
			_kalturaAnnotation.text = value;
		}
		
		
		public function get inTime():Number {
			return _kalturaAnnotation.startTime;
		}
		
		
		public function set inTime(value:Number):void {
			_kalturaAnnotation.startTime = value;
		}
		
		
		public function set entryId(n_entryId:String):void {
			_kalturaAnnotation.entryId = n_entryId;
		}
		
		
		public function get entryId():String {
			return _kalturaAnnotation.entryId;
		}
		
		
		protected function gotoEditMode():void {
			removeAllChildren();
			annotationTextField.type = "input";
			
			annotationTextField.text = annotationText ? annotationText : "";
			annotationTextField.selectable = true;
			
			_annotaionBox.addChild(annotationTextField);
			addChild(_annotaionBox);
			annotationTextField.setTextFormat(annotationTextFormat);
		}
		
		
		protected function gotoViewMode():void {
			removeAllChildren();
			addKButton ("intime", parseInTimeString(), _initialTabIndex);
			//add annotation text
			annotationTextField.selectable = false;
			annotationTextField.setTextFormat(annotationTextFormat);
			annotationTextField.htmlText = annotationText ? htmlEscape(annotationText) : "";
			_annotaionBox.addChild(annotationTextField);

			if (userMode == AnnotationStrings.REVIEWER) {
				addKButton("edit", "Edit", _initialTabIndex + 1);
				addKButton("delete", "Delete", _initialTabIndex + 2);
			}
			addChild(_annotaionBox);
		}
		
		/**
		 * 
		 * Create a new KButton with the given attributes and add it to _annotationBox container
		 * */
		private function addKButton(btnId:String, btnLabel:String, tabIndx:int) : void {
			var btn:KButton = new KButton();
			btn.id = btnId;
			btn.buttonType = KButton.LABEL_BUTTON;
			btn.label = btnLabel;
			btn.buttonMode = true;
			btn.tabIndex = tabIndex;
			btn.color1= 0x0051DE;
			btn.addEventListener(MouseEvent.CLICK, onLinkActivate);
			_annotaionBox.addChild(btn);
		}
		
		private function htmlEscape(str:String):String
		{
			return XML( new XMLNode( XMLNodeType.TEXT_NODE, str ) ).toXMLString();
		}
		
		private function removeAllChildren():void {
			while (_annotaionBox.numChildren > 0) {
				_annotaionBox.removeChildAt(0);
			}
			while (this.numChildren > 0) {
				this.removeChildAt(0);
			}
		}
		
		
		/**
		 * scroll to bottom and truncate text if needed 
		 * @param e
		 */		
		private function onTextFieldEdit(e:Event):void {
			// truncate
			if (Annotation.maxChars) {
				if (annotationTextField.length >= Annotation.maxChars) {
					_textExceedsLength = true;
					annotationTextField.text = annotationTextField.text.substr(0, Annotation.maxChars);
					dispatchEvent(new AnnotationEvent(AnnotationEvent.MAX_LENGTH_REACHED, this));
				}
					
				else if (_textExceedsLength) {
					_textExceedsLength = false;
					dispatchEvent(new AnnotationEvent(AnnotationEvent.MAX_LENGTH_FIXED, this));
				}
			}
			// scroll to bottom
			if (annotationTextField.textHeight != this.height) {
				this.height = _annotaionBox.height = this.annotationTextField.textHeight;
			}
		}
		
		
		private function parseInTimeString():String {
			var hrs:Number = Math.floor(_kalturaAnnotation.startTime / 3600);
			var mins:Number = Math.floor((_kalturaAnnotation.startTime - hrs * 3600) / 60);
			var secs:Number = Math.round((_kalturaAnnotation.startTime - hrs * 3600 - mins * 60));
			var hrsString:String = hrs.toString();
			var minsString:String = mins.toString();
			var secsString:String = secs.toString();
			
			if (hrsString.length < 2) {
				hrsString = "0" + hrsString;
			}
			if (minsString.length < 2) {
				minsString = "0" + minsString;
			}
			if (secsString.length < 2) {
				secsString = "0" + secsString;
			}
			
			return hrsString + ":" + minsString + ":" + secsString;
		}
		
		
		private function onAnnotationClick(e:Event):void {
			//ignore tabs
			if (e is KeyboardEvent && (e as KeyboardEvent).keyCode == 9)
				return;
			annotationTextField.text = "";
			annotationTextField.removeEventListener(MouseEvent.CLICK, onAnnotationClick);
			annotationTextField.removeEventListener(KeyboardEvent.KEY_DOWN, onAnnotationClick);
		}
		
		
		protected function onLinkActivate(e:MouseEvent):void {
			switch (e.target.id) {
				case "edit":
					viewMode = "edit";
					dispatchEvent(new AnnotationEvent(AnnotationEvent.EDIT_ANNOTATION, this));
					break;
				case "delete":
					dispatchEvent(new AnnotationEvent(AnnotationEvent.DELETE_ANNOTATION, this));
					break;
				case "intime":
					dispatchEvent(new AnnotationEvent(AnnotationEvent.SEEK_TO_ANNOTATION, this));
					break;
			}
		}
		
		
		override public function set width(value:Number):void {
			super.width = value;
			
			_annotaionBox.width = value;
			if (_viewMode == AnnotationStrings.VIEW_MODE) {
				if (_seperator && _seperator.parent)
					removeChild(_seperator);
				//draw seperator
				_seperator = new Sprite;
				_seperator.graphics.lineStyle(1,0xCCCCCC);
				_seperator.graphics.moveTo(-10 , _annotaionBox.height);
				_seperator.graphics.lineTo(value, _annotaionBox.height);
				addChild(_seperator);
			}
			
			annotationTextField.width = value * 0.7;
		}
		
		
		override public function set height(value:Number):void {
			super.height = _annotaionBox.height = Math.max(this.annotationTextField.textHeight + 10, ANNOTATION_HEIGHT);
		}
		
		
		public function saveText():void {
			this.annotationText = this.annotationTextField.text;
		}
		
		
		public function get kalturaAnnotation():KalturaAnnotation {
			return _kalturaAnnotation;
		}

	}
}