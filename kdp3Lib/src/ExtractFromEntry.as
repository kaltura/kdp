package
{
	import com.kaltura.vo.KalturaBaseEntry;

	public class ExtractFromEntry
	{
		public function ExtractFromEntry()
		{
		}
		
		public static function retrieveThumbnailUrl (entry : KalturaBaseEntry) : String
		{
			var thumbnailUrl : String = entry.thumbnailUrl;	
			return thumbnailUrl;
		}
		
		public static function retrieveVideoUrl ( entry: KalturaBaseEntry ) : String
		{
			var videoUrl : String = entry.dataUrl;
			return videoUrl;
		}
	}
}