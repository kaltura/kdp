package com.kaltura.kdpfl.util
{
	import com.kaltura.kdpfl.view.controls.KTrace;
	
	import flash.net.SharedObject;

	/**
	 * This util class will be used to performed actions related to sharedObject 
	 * @author michalr
	 * 
	 */	
	public class SharedObjectUtil
	{
		/**
		 * If cookies are allowed, Will save to localName cookie the given value on the given property name
		 * @param localName name of local
		 * @param propertyName name of property to set
		 * @param value value to save on the property
		 * @param allowCookies determines whether to save or not
		 * 
		 */		
		public static function writeToCookie(localName:String, propertyName:String, value:Object, allowCookies:String): void 
		{
			if (allowCookies && allowCookies=="true")
			{
				var cookie : SharedObject;
				try
				{
					cookie= SharedObject.getLocal(localName);
					if (cookie)
					{
						cookie.data[propertyName] = value;
						cookie.flush();
					}
				}
				catch (e : Error)
				{
					KTrace.getInstance().log("No access to user's file system");
				}
				
			}
		}
		
		
	}
}