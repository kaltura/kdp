package com.kaltura.kdpfl.view
{
	import com.kaltura.kdpfl.view.events.AnnotationEvent;
	import com.kaltura.kdpfl.view.strings.AnnotationStrings;
	import com.kaltura.vo.KalturaAnnotation;
	
	import fl.core.UIComponent;
	import fl.events.ComponentEvent;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class Annotation extends UIComponent
	{
		protected var _viewMode : String;
		/*protected var _annotationText : String;
		protected var _inTime : Number;
		protected var _entryId : String;*/
		
		private var _kalturaAnnotation : KalturaAnnotation;
		
		public static var userMode : String;
		
		public static const ANNOTATION_PROMPT : String = "Enter your annotation text here...";
		
		private var annotationTextField : TextField = new TextField();
		
		private var annotationTextFormat : TextFormat = new TextFormat("Arial", 11);
		
		public static var maxChars : int = 0;
		
		
		public function Annotation(n_viewMode:String, n_inTime : Number=-1, n_annotationText : String= ANNOTATION_PROMPT, n_entryId : String = "" ,n_kalturaAnnotation : KalturaAnnotation = null)
		{
			//annotationTextField.setTextFormat(annotationTextFormat);
			annotationTextField.defaultTextFormat = annotationTextFormat;
			annotationTextField.maxChars = maxChars;
			if (maxChars)
			{
				annotationTextField.addEventListener(KeyboardEvent.KEY_DOWN, onUserTypeAttempt);
			}
			if (! n_kalturaAnnotation)
			{
				_kalturaAnnotation = new KalturaAnnotation();
				_kalturaAnnotation.text = n_annotationText;
				_kalturaAnnotation.startTime = n_inTime;
				_kalturaAnnotation.entryId = n_entryId;
			}
			else
			{
				_kalturaAnnotation = n_kalturaAnnotation;
			}
			this.viewMode= n_viewMode;
			annotationTextField.autoSize = TextFieldAutoSize.LEFT;
			annotationTextField.wordWrap = true;
			annotationTextField.mouseWheelEnabled = false;
			//annotationTextField.textColor = 0x000000;
			
			annotationTextField.addEventListener(TextEvent.LINK, onLinkActivate );
			annotationTextField.addEventListener(Event.CHANGE, onTextFieldEdit);
			
			if (_kalturaAnnotation.text == Annotation.ANNOTATION_PROMPT)
			{
				annotationTextField.addEventListener(MouseEvent.CLICK, onAnnotationClick);
			}
		}

		public function get viewMode():String 
		{
			return _viewMode;
		}
		public function set viewMode(value:String):void 
		{
			_viewMode = value;
			if (_viewMode == AnnotationStrings.VIEW_MODE)
			{
				gotoViewMode();
			}
			if (_viewMode == AnnotationStrings.EDIT_MODE)
			{
				gotoEditMode();
			}
		}

		public function get annotationText():String {return _kalturaAnnotation.text;}
		public function set annotationText(value:String):void {_kalturaAnnotation.text = value;}

		public function get inTime():Number {return _kalturaAnnotation.startTime;}
		public function set inTime(value:Number):void {_kalturaAnnotation.startTime = value;}
		
		public function set entryId (n_entryId : String) : void {_kalturaAnnotation.entryId = n_entryId; }
		public function get entryId () : String {return _kalturaAnnotation.entryId;} 

		
		protected function gotoEditMode () : void 
		{
			removeAllChildren();
			annotationTextField.type = "input";
			
			annotationTextField.text = annotationText;
			annotationTextField.selectable = true;
			this.addChild(annotationTextField);
			annotationTextField.setTextFormat(annotationTextFormat);
		}
		
		
		protected function gotoViewMode () : void
		{
			removeAllChildren();
			annotationTextField.selectable = false;
			annotationTextField.htmlText = this.annotationText;
			var intime : String = "<B><font color='#0051DE'><a href='event:intime'>" + parseInTimeString() + "</a></font></B>";
			var edit : String = "";
			var deleteAnnotation : String = "";//0051DE
			if (userMode == AnnotationStrings.REVIEWER)
			{
				edit = "<B><a href='event:edit'><font color='#0051DE'>Edit</font></a></B>";
				deleteAnnotation = "<B><font color='#0051DE'><a href='event:delete'>Delete</a></font></B>";
			}
			annotationTextField.htmlText = intime + " " + annotationTextField.htmlText + " " + edit + " " +deleteAnnotation;
			annotationTextField.setTextFormat(annotationTextFormat);
			addChild(annotationTextField);
		}
		
		private function removeAllChildren () : void
		{
			while (this.numChildren > 0)
			{
				this.removeChildAt(0);
			}
		}
		
		
		private function onTextFieldEdit (e : Event) : void
		{

			if (annotationTextField.textHeight != this.height)
			{
				this.height = this.annotationTextField.textHeight;
			}
		}
		
		private function onUserTypeAttempt (e : KeyboardEvent) : void
		{
			if (annotationTextField.length >= maxChars)
			{
				dispatchEvent( new AnnotationEvent (AnnotationEvent.MAX_LENGTH_REACHED , this ) );
			}
		}
		
		private function parseInTimeString () : String
		{
			var hrs : Number = Math.floor(_kalturaAnnotation.startTime / 3600);
			var mins : Number = Math.floor((_kalturaAnnotation.startTime - hrs*3600)/60);
			var secs : Number = Math.round((_kalturaAnnotation.startTime - hrs*3600 - mins*60));
			var hrsString : String = hrs.toString();
			var minsString : String = mins.toString();
			var secsString : String = secs.toString();
			
			if (hrsString.length < 2)
			{
				hrsString = "0" + hrsString;
			}
			if (minsString.length < 2)
			{
				minsString = "0" + minsString;
			}
			if (secsString.length < 2)
			{
				secsString = "0" + secsString;
			}
			
			return hrsString +":" + minsString + ":" + secsString;
		}
		
		private function onAnnotationClick (e : MouseEvent) : void
		{
			annotationTextField.text = "";
			annotationTextField.removeEventListener(MouseEvent.CLICK, onAnnotationClick );
		}

		
		protected function onLinkActivate (e : TextEvent) : void
		{
			switch (e.text)
			{
				case "edit":
					viewMode = "edit";
					dispatchEvent ( new AnnotationEvent(AnnotationEvent.EDIT_ANNOTATION,this) );
					break;
				case "delete":
					dispatchEvent (new AnnotationEvent (AnnotationEvent.DELETE_ANNOTATION, this) );
					break;
				case "intime":
					dispatchEvent(new AnnotationEvent (AnnotationEvent.SEEK_TO_ANNOTATION, this) );
					break;
			}
		}

		
		override public function set width(value:Number):void
		{
			super.width = value;
			this.annotationTextField.width = value;
		}
		
		override public function set height(value:Number):void
		{
			super.height = this.annotationTextField.textHeight;
		}
		
		public function saveText () : void
		{
			this.annotationText = this.annotationTextField.text;
		}

		public function get kalturaAnnotation():KalturaAnnotation
		{
			return _kalturaAnnotation;
		}


		

	}
}