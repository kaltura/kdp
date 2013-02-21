package com.kaltura.kdpfl.plugin
{
	import flash.external.ExternalInterface;
	
	import org.osmf.media.MediaResourceBase;
	import org.osmf.traits.LoaderBase;
	
	public class WVLoader extends LoaderBase
	{
		public function WVLoader()
		{
			super();
		}
		
		override public function canHandleResource(resource:MediaResourceBase):Boolean
		{
			if (resource.hasOwnProperty("url") && resource["url"].toString().indexOf(".wvm") > -1 )
			{
				try
				{
					ExternalInterface.call("mediaURL" , resource["url"].toString());
				} 
				catch(error:Error) 
				{
					trace("Failed to call external interface");
				}
				return true;
			}
			return false;
		}
	}
}