package com.kaltura.kdpfl.plugin.component
{
	/**
	 * Class represents Related Item possible actions 
	 * @author michalr
	 * 
	 */	
	public class RelatedItemActionType
	{
		/**
		 * load entry in player 
		 */		
		public static const LOAD_IN_PLAYER:String 				= "loadInPlayer";
		/**
		 * navigate to URL
		 */
		public static const GO_TO_URL:String					= "goToUrl";
		/**
		 * call js function 
		 */		
		public static const CALL_JS_FUNC:String					= "callJsFunc";
	}
}