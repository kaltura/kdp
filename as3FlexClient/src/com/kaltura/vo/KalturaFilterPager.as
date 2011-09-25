package com.kaltura.vo
{
	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaFilterPager extends BaseFlexVo
	{
		/** 
		* The number of objects to retrieve. (Default is 30, maximum page size is 500).
		* */ 
		public var pageSize : int = int.MIN_VALUE;

		/** 
		* The page number for which {pageSize} of objects should be retrieved (Default is 1).
		* */ 
		public var pageIndex : int = int.MIN_VALUE;

		/** 
		* a list of attributes which may be updated on this object 
		* */ 
		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('pageSize');
			arr.push('pageIndex');
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
