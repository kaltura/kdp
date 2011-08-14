package com.kaltura.kdpfl.view.strings
{
	public class AnnotationStrings
	{
		//Event strings
		public static const INVALID_ANNOTATION_TEXT_EVENT : String = "invalidAnnotationText";
		
		public static const INVALID_ANNOTATION_INTIME_EVENT : String = "invalidAnnotationInTime";
		
		public static const ANNOTATIONS_LIST_CHANGED_EVENT : String = "annotationsListChanged";
		
		//Annotation widget title strings
		
		public static const ANNOTATION_BOX_TITLE : String = "<b>Feedback</b>";
		
		public static const ADD_ANNOTATION_TITLE : String  = "<b>Add Annotation</b>";
		
		public static const EDIT_ANNOTATION_TITLE : String = "<b>Edit Annotation</b>";
		
		public static const INVALID_FEEDBACK_SESSION_TITLE : String = "Could not load the specified feedback session";
		
		
		//Viewer type strings
		public static const REVIEWER : String = "editable";
		
		public static const CANDIDATE : String = "readOnly";
		
		//View type strings
		public static const VIEW_MODE : String = "view";
		
		public static const EDIT_MODE : String = "edit";
		
		//Annotation edit form messages
		
		public static const INVALID_ANNOTATION_INTIME_MESSAGE : String = "It is not possible to add more than one annotation for the same in-time."
		
		public static const INVALID_ANNOTATION_TEXT_MESSAGE : String = "Please enter an annotation before saving";
			
		public static const INVALID_FEEDBACK_SESSION_MESSAGE : String = "Please ensure that the feedback session id is correct.";
		
		//Annotation submission locations:
		
		public static const KALTURA :String = "kaltura";
		
		public static const LOCAL_DB : String = "localDB";
		
		//Annotation save mode
		
		public static const DRAFT : String = "draft";
		
		public static const FINAL : String = "final";
		
		public function AnnotationStrings()
		{
		}
	}
}