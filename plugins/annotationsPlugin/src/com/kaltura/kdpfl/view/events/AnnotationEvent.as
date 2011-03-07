package com.kaltura.kdpfl.view.events
{
	import com.kaltura.kdpfl.view.Annotation;
	
	import flash.events.Event;
	
	/**
	 * Class AnnotationEvent is the class for the custom events fired by annotations. 
	 * @author Hila
	 * 
	 */	
	public class AnnotationEvent extends Event
	{
		public var annotation : Annotation;
		
		//Annotation Event types constants
		
		/**
		 * String of the event fired when an annotation entered "edit" mode
		 */		
		public static const EDIT_ANNOTATION : String = "editAnnotation";
		/**
		 * String of the event fired when an annotation is deleted by the user.
		 */		
		public static const DELETE_ANNOTATION : String = "deleteAnnotation";
		/**
		 * String of the event fired when an annotation in-time was clicked
		 */		
		public static const SEEK_TO_ANNOTATION : String = "seekToAnnotation"
		/**
		 * Constructor of the AnnotationEvent 
		 * @param type - inherited
		 * @param n_annotation - the annotation in relation to which the event was fired.
		 * @param bubbles - inherited
		 * @param cancelable - inherited
		 * 
		 */		
		public function AnnotationEvent(type:String, n_annotation:Annotation, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			annotation = n_annotation;
		}
	}
}