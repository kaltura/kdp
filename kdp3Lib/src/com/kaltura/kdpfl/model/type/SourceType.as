package com.kaltura.kdpfl.model.type
{
	/**
	 * Class <b>SourceType</b> holds the constants representing the different types of sources for the media played in the KDP.
	 * @author Hila
	 * 
	 */	
	public class SourceType
	{
		/**
		 * SourceType URL is used for media that is not a Kaltura-entry, but an .flv or .wmv file that the user has a path for.
		 */		
		public static const URL : String = "url";
		/**
		 * SourceType ENTRY_ID is used when the media playing within the KDP is a Kaltura entry.
		 */		
		public static const ENTRY_ID : String = "entryId";
		/**
		 * SourceType F4M is used when the user has a manifest file for a video, rather than the video itself.
		 */		
		public static const F4M : String = "f4m";
	}
}