package com.kaltura.vo
{
	import com.kaltura.vo.KalturaGenericSyndicationFeed;

	[Bindable]
	public dynamic class KalturaGenericXsltSyndicationFeed extends KalturaGenericSyndicationFeed
	{
		/** 
		* 		* */ 
		public var xslt : String = null;

		/** 
		* This parameter determines which custom metadata fields of type related-entry should be
expanded to contain the kaltura MRSS feed of the related entry. Related-entry fields not
included in this list will contain only the related entry id.
This property contains a list xPaths in the Kaltura MRSS.
		* */ 
		public var itemXpathsToExtend : Array = new Array();

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('xslt');
			arr.push('itemXpathsToExtend');
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
