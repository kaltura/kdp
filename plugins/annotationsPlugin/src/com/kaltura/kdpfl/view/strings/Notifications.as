package com.kaltura.kdpfl.view.strings
{
	public class Notifications
	{
		/**
		 * Notification fired when the "Add Annotation" button is clicked.
		 */		
		public static const ADD_ANNOTATION : String = "addAnnotation";
		/**
		 * Notification fired when the "edit" link next to the annotation is clicked.
		 */		
		public static const EDIT_ANNOTATION : String = "editAnnotation";
		/**
		 * Notification fired when an annotation was deleted. 
		 * Body - {annotation: {deleted annotation}}
		 */		
		public static const ANNOTATION_DELETED : String = "annotationDeleted";
		/**
		 * Notification fired when user clicks "save" button.
		 */		
		public static const SAVE_ANNOTATION : String = "saveAnnotation";
		/**
		 * Notification fired when user clicks "Cancel" button.
		 */		
		public static const CANCEL_ANNOTATION : String = "cancelAnnotation";
		/**
		 * Notification fired when the user loads an existing feedback session into the tool. 
		 * Body- {sessionId: ""} 
		 */		
		public static const LOAD_FEEDBACK_SESSION : String = "loadFeedbackSession";
		/**
		 * Notification fired when the annotations tool loads a user's editable feendback session from the SharedObject. 
		 */		
		public static const LOAD_LOCAL_SAVED_ANNOTATIONS : String = "loadLocalSavedAnnotations";
		/**
		 * Notification fired when the user clicks the in-time link of an annotation.
		 * Body- {time : annotation in-time} 
		 */		
		public static const SKIP_TO_ANNOTATION_TIME : String = "skipToAnnotationTime";
		/**
		 * Notification fired when the "Submit" button is clicked.
		 */		
		public static const SUBMIT_FEEDBACK_SESSION : String = "submitFeedbackSession";
		/**
		 * Notification fired to trigger the emptying of the annotations box and the SharedObject.
		 */		
		public static const RESET_ANNOTATIONS_COMPONENT : String = "resetAnnotationsComponent";
		/**
		 * Notification which is triggered when 
		 */		
		public static const FEEDBACK_SESSION_SUBMITTED : String = "feedbackSessionSubmitted";
		/**
		 * Notification fired when an annotation is saved. 
		 */		
		public static const ANNOTATION_SAVED : String = "annotationSaved";
		
		public static const SAVE_AS_DRAFT : String = "saveAsDraft";
			
		public function Notifications()
		{
		}
	}
}