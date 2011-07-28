package com.kaltura.vo
{
	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaSystemPartnerLimit extends BaseFlexVo
	{
		/** 
		* 		* */ 
		public var type : String;

		/** 
		* 		* */ 
		public var max : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var overagePrice : Number = NaN;

		/** 
		* a list of attributes which may be updated on this object 
		* */ 
		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('type');
			arr.push('max');
			arr.push('overagePrice');
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
