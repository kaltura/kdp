package com.kaltura.kdpfl.model.vo
{
	import com.kaltura.vo.KalturaUiConf;
	import com.kaltura.vo.KalturaWidget;
	
	/**
	 * Class ConfigVO holds parameters related to the general configuration of the KDP. 
	 * 
	 */	
	public class ConfigVO
	{
		/**
		 * Parameter holds the flashvars passed to the KDP.
		 */		
		public var flashvars:Object;
		/**
		 * Parameter holds the information on the current KalturaWidget
		 */		
		public var kw : KalturaWidget; 
		/**
		 * Parameter to hold the Uiconf object of the player.
		 */		
		public var kuiConf : KalturaUiConf;
		/**
		 * A unique ID for the loaded instance of the KDP. 
		 */		
		public var sessionId : String;
	}
}