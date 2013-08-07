package com.kaltura.osmf.kontiki
{
	
	import flash.events.NetStatusEvent;
	import flash.external.ExternalInterface;
	import flash.media.Video;
	import flash.net.NetStream;
	
	import org.osmf.elements.LightweightVideoElement;
	import org.osmf.events.TimeEvent;
	import org.osmf.media.LoadableElementBase;
	import org.osmf.media.MediaResourceBase;
	import org.osmf.net.NetClient;
	import org.osmf.net.NetStreamBufferTrait;
	import org.osmf.net.NetStreamCodes;
	import org.osmf.net.NetStreamDisplayObjectTrait;
	import org.osmf.net.StreamingURLResource;
	import org.osmf.traits.LoadTrait;
	import org.osmf.traits.LoaderBase;
	import org.osmf.traits.MediaTraitType;
	
	public class KontikiElement extends LightweightVideoElement
	{
		public var jsToCall:String;
		
		public function KontikiElement()
		{
			super();
		}
		
		/**
		 * if kontiki resource will override given URL with httpUrl with kontiki js API 
		 * */
		override public function set resource(value:MediaResourceBase):void
		{
			var transformedResource:MediaResourceBase = value;
		
			if (value && value.hasOwnProperty("url") && value["url"])
			{
				var origUrl:String = value["url"];
				var params:Array = origUrl.split(";");
				if (params && params.length == 3) {
					var urn:String = params[0].substr(params[0].indexOf("urn:kid"));
					var paramsObj:Object = {};
					for (var i:int = 1; i < params.length; i++) {
						addKontikiVar (paramsObj, params[i]);
					}
					
					var realUrl:String;
					try {
						realUrl = ExternalInterface.call(jsToCall, urn, paramsObj);
					}
					catch (e:Error) {
						trace ("KontikiElement:: Failed to create streaming resource, invalid URL");
					}
					if (realUrl && realUrl!="")
						transformedResource = new StreamingURLResource(realUrl); 		
				}
				else {
					trace ("KontikiElement:: Failed to create streaming resource, invalid URL");
				}
			}

			super.resource = transformedResource;
		}
		
		/**
		 * Will parse given apramString and add as parameter to given paramsObject
		 * */
		private function addKontikiVar (paramsObj:Object, paramString:String) : void
		{
			var vals:Array = paramString.split(":");
			if (vals && vals.length == 2) {
				paramsObj[vals[0]] = vals[1];
			}
		}
	}
}