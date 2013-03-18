/**
 WvEvent
 version 1.0
 03/22/2010
 Widevine DRM event class
**/

package com.widevine
{
 	import flash.events.Event;
	
	public class WvEvent extends Event
	{
		public static const DRM_STATUS:String = "DRM_STATUS";
		public var code:String;
		public var description:String;
		public var details:String;
		
		public function WvEvent(code:String, desc:String, details:String="") {
			super(DRM_STATUS);
			this.code = code;
			this.description = desc;
			this.details = details;
  		}
	}  // class
} // package
