package com.kaltura.kdpfl.plugin.component
{
	/**
	 * possible types for related entries list 
	 * @author michalr
	 * 
	 */	
	public class RelatedEntriesSourceType
	{
		/**
		 * automatic playlist will be the source type 
		 */		
		public static const AUTOMATIC:String 				= "automatic";
		/**
		 * list of reference IDs 
		 */	
		public static const REFERENCE_IDS:String 			= "referenceIds";
		/**
		 * specific playlist 
		 */		
		public static const GLOBAL_PLAYLIST:String 			= "globalPlaylist";
		/**
		 * list of entry IDs
		 */		
		public static const ENTRY_IDS:String	 			= "entryIds";
	}
}