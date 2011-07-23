package com.kaltura.vo
{
	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaSyndicationFeedEntryCount extends BaseFlexVo
	{
		/** 
		* the total count of entries that should appear in the feed without flavor filtering		* */ 
		public var totalEntryCount : int = int.MIN_VALUE;

		/** 
		* count of entries that will appear in the feed (including all relevant filters)		* */ 
		public var actualEntryCount : int = int.MIN_VALUE;

		/** 
		* count of entries that requires transcoding in order to be included in feed		* */ 
		public var requireTranscodingCount : int = int.MIN_VALUE;

		/** 
		* a list of attributes which may be updated on this object 
		* */ 
		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('totalEntryCount');
			arr.push('actualEntryCount');
			arr.push('requireTranscodingCount');
			return arr;
		}

		/** 
		* a list of attributes which may only be inserted when initializing this object 
		* */ 
		public function getInsertableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			return arr;
		}

	}
}
