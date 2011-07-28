package com.kaltura.vo
{
	import com.kaltura.vo.KalturaDropFolderFileHandlerConfig;

	[Bindable]
	public dynamic class KalturaDropFolderContentFileHandlerConfig extends KalturaDropFolderFileHandlerConfig
	{
		/** 
		* 		* */ 
		public var contentMatchPolicy : int = int.MIN_VALUE;

		/** 
		* Regular expression that defines valid file names to be handled.
The following might be extracted from the file name and used if defined:
- (?P<referenceId>\w+) - will be used as the drop folder file's parsed slug.
- (?P<flavorName>\w+)  - will be used as the drop folder file's parsed flavor.
		* */ 
		public var slugRegex : String;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('contentMatchPolicy');
			arr.push('slugRegex');
			return arr;
		}

		override public function getInsertableParamKeys():Array
		{
			var arr : Array;
			arr = super.getInsertableParamKeys();
			return arr;
		}

	}
}
