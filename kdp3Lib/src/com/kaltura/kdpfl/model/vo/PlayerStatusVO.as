package com.kaltura.kdpfl.model.vo
{
	/**
	 * This class contains information related to the player in general. 
	 * @author Hila
	 * 
	 */	
	public class PlayerStatusVO
	{
		/**
		 *  Status of the player - "ready", "empty" or null.
		 */		
		public var kdpStatus : String;
		/**
		 * Version of the player.
		 */		
		public var kdpVersion : String;
		/**
		 * Player load time(sec).
		 */		
		public var loadTime : String;
		
		
		
		
		/**
		 *  Constructor
		 * @param version - current swf version
		 * 
		 */		
		public function PlayerStatusVO(version : String)
		{
			kdpVersion  = version;
		}
	}
}