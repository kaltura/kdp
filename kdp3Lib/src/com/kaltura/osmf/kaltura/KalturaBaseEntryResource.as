package com.kaltura.osmf.kaltura
{
	import com.kaltura.vo.KalturaBaseEntry;
	
	import org.osmf.media.MediaResourceBase;

	public class KalturaBaseEntryResource extends MediaResourceBase
	{
		public var entry:KalturaBaseEntry;
		
		public function KalturaBaseEntryResource(_entry:KalturaBaseEntry)
		{
			entry = _entry;
		}

	}
}
