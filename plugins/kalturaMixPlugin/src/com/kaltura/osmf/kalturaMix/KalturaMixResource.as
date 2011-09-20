package com.kaltura.osmf.kalturaMix
{
	import com.kaltura.vo.KalturaMixEntry;
	
	import org.osmf.media.IMediaResource;
	import org.osmf.metadata.Metadata;

	public class KalturaMixResource implements IMediaResource
	{
		public var entry:KalturaMixEntry;
		
		public function KalturaMixResource(_entry:KalturaMixEntry)
		{
			entry = _entry;
		}

		public function get metadata():Metadata
		{
			return null;
		}
		
	}
}