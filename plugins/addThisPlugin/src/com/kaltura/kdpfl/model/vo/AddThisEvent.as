package com.kaltura.kdpfl.model.vo
{
	import flash.events.Event;
	
	public class AddThisEvent extends Event
	{
		public static const RADIO_BUTTON_EVENT:String	= "radioButtonEvent";
		public static const ADD_THIS_MANAGER:String		= "addThisManager";
		public static const CAPTCHA_RESPONSE:String		= "captchaResponse";
		public static const EMAIL_SENT:String			= "emailSent";
		public static const EMAIL_SEND_FAIL:String		= "emailSendFail";
		public static const EMBED_CODE_UPDATED:String	= "embedCodeUpdated";
		
		public var data:Object;
		public var codeType:String;
		
		public function AddThisEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}