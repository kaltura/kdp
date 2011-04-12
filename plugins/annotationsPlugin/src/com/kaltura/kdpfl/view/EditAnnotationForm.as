package com.kaltura.kdpfl.view
{
	import com.kaltura.kdpfl.util.KAstraAdvancedLayoutUtil;
	import com.kaltura.kdpfl.view.containers.KVBox;
	import com.kaltura.kdpfl.view.strings.AnnotationStrings;
	import com.yahoo.astra.utils.TextUtil;
	
	import fl.controls.ScrollPolicy;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.utils.StringUtil;
	import mx.validators.StringValidator;
	
	public class EditAnnotationForm extends KVBox
	{
		
		public function EditAnnotationForm(configuration:Array=null)
		{
			super(configuration);
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
			
			var a : Array = this.configuration.concat();
			a.push(n_config);
			this.configuration = a;
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
				return currAnnotation;
			}
			
		}
		
		public function canceledAnnotation () : Annotation
		{
			var currAnnotation : Annotation = annotation;
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