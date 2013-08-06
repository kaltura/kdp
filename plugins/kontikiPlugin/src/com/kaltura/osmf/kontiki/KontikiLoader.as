package com.kaltura.osmf.kontiki
{
	import org.osmf.traits.LoaderBase;
	import org.osmf.media.MediaResourceBase;
	
	public class KontikiLoader extends LoaderBase
	{
		public function KontikiLoader()
		{
			super();
		}
		
		
		override public function canHandleResource(resource:MediaResourceBase):Boolean
		{
			return (resource && resource.hasOwnProperty("url") && resource["url"].toString().indexOf("urn:") != -1);
		}
	}
}