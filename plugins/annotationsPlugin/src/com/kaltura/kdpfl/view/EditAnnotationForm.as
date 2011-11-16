package com.kaltura.kdpfl.view
{
	import com.kaltura.kdpfl.util.KAstraAdvancedLayoutUtil;
	import com.kaltura.kdpfl.view.containers.KVBox;
	import com.kaltura.kdpfl.view.strings.AnnotationStrings;
	
	import fl.controls.ScrollPolicy;
	
	import flash.events.Event;
	
	public class EditAnnotationForm extends KVBox
	{
		
		private var prevText : String = "";
		//will be used to display the bottom line in editing mode
		private var _prevMaxScroll:Number = 0;
		
		public function EditAnnotationForm(configuration:Array=null)
		{
			super(configuration);
			addEventListener(Event.CHANGE, onChange);
			this.configuration = new Array();
			this.horizontalScrollPolicy = ScrollPolicy.OFF;
			this.setSkin("input_bg");
		}
		
		public function openAnnotationForEditing (n_annotation : Annotation) : void
		{
			//this.configuration = new Array();
			var n_config :Object = new Object();
			n_config.target = n_annotation;
			n_config.percentWidth = 100;
			n_config.percentHeight = 100;
			var a : Array = this.configuration.concat();
			a.push(n_config);
			this.configuration = a;
			
			prevText = n_annotation.annotationText;
			_prevMaxScroll = this.maxVerticalScrollPosition;
		}
		
		private function onChange(evt:Event):void {
			//if more text was added, will scroll to the bottom to see the end of the text
			if (this.maxVerticalScrollPosition != _prevMaxScroll) {
				_prevMaxScroll = this.maxVerticalScrollPosition;
				this.verticalScrollPosition = _prevMaxScroll;
			}
		}
	
		
		public function returnValidAnnotation (currentTime : Number) : Annotation
		{
			if (annotation.inTime == -1)
			{
				annotation.inTime = currentTime;
			}
			annotation.saveText();
			if (!validateAnnotation(annotation.annotationText) )
			{
				dispatchEvent (new Event( AnnotationStrings.INVALID_ANNOTATION_TEXT_EVENT, true) );
				return null;
			}
			else
			{
				var currAnnotation : Annotation = annotation;
				KAstraAdvancedLayoutUtil.removeFromLayout(this, annotation);
				currAnnotation.viewMode = AnnotationStrings.VIEW_MODE;
				prevText = "";
				return currAnnotation;
			}
			
		}
		
		public function canceledAnnotation () : Annotation
		{
			var currAnnotation : Annotation = annotation;
			currAnnotation.annotationText = prevText;
			prevText = "";
			KAstraAdvancedLayoutUtil.removeFromLayout(this, annotation);
			currAnnotation.viewMode = AnnotationStrings.VIEW_MODE;
			return currAnnotation;
		}
		
		public function get annotation () : Annotation
		{
			var currAnnotation : Annotation = this.getChildAt(0) as Annotation;
			
			return currAnnotation;
		}
		
		private function validateAnnotation (text : String) : Boolean
		{
			if (text == Annotation.ANNOTATION_PROMPT)
			{
				return false;
			}
			if (text == "")
			{
				return false;
			}
			if (text.replace(/ /gi, "") == "" )
			{
				return false;
			}
			return true;
		}
		
		
	}
}