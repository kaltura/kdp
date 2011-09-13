package com.kaltura.kdpfl.util
{
	public class ObjectUtils
	{
		public function ObjectUtils()
		{
		}
		
		public static function length(o:Object):int
		{
			var len:int = 0;
			for(var i:* in o)
			{
				//if (item != "mx_internal_uid")
				len++;
			}
			return len;
		}

	}
}