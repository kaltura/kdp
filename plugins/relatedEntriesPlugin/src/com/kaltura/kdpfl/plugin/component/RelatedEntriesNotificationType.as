package com.kaltura.kdpfl.plugin.component
{
	public class RelatedEntriesNotificationType
	{
		/**
		 * notification will trigger loading of related entries 
		 */		
		public static const LOAD_RELATED_ENTRIES:String 			= "loadRelatedEntries";

		/**
		 * notification fired when related entries were loaded 
		 */		
		public static const RELATED_ENTRIES_LOADED:String 			= "relatedEntriesLoaded";
		
		/**
		 * notification will triger configured action on the clicked item 
		 */		
		public static const RELATED_ITEM_CLICKED:String 			= "relatedItemClicked";

		/**
		 * notification will triger configured action on the clicked item 
		 * Body: index:int = the index of the new next up item
		 */		
		public static const NEXT_UP_ITEM_CHANGED:String 			= "nextUpItemChanged";
		
		/**
		 * will pause/resume the "timeRemaining" timer 
		 */		
		public static const PAUSE_RESUME_RELATED_TIMER:String 		= "pauseResumeRelatedTimer";
	
	}
}