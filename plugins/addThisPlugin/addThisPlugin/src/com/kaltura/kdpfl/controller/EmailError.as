package com.kaltura.kdpfl.controller
{
	public class EmailError extends Error
	{
		public static const CAPTCHA_RESPONSE:String	= "captchaResponse";
		
		
		public var componentId:Array	= new Array();
		public var type:String			= new String();
		public var data:Object			= new Object();
		
		public function EmailError()
		{
			super();
		}
		
	}
}