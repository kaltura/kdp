package com.kaltura.vo
{
	import com.kaltura.vo.KalturaSearchItem;

	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaFilter extends BaseFlexVo
	{
		/** 
		* 		* */ 
		public var orderBy : String = null;

		/** 
		* 		* */ 
		public var advancedSearch : KalturaSearchItem;

		/** 
		* a list of attributes which may be updated on this object 
		* */ 
		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('orderBy');
			arr.push('advancedSearch');
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
