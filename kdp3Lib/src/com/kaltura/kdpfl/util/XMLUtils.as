package com.kaltura.kdpfl.util
{
	import fl.transitions.Fade;
	
	public class XMLUtils
	{
		public static function hasAttribute(list:XMLList, attr:String):Boolean
		{
			var ret : Boolean = false;
			for each(var x:XML in list)
			{
				if(x.name().toString() == attr)
				{
					ret = true;
					break;
				}
			}
			return ret;
		}

	}
}