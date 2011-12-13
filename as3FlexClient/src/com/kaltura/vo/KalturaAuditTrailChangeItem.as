package com.kaltura.vo
{
	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaAuditTrailChangeItem extends BaseFlexVo
	{
		/** 
		* 		* */ 
		public var descriptor : String = null;

		/** 
		* 		* */ 
		public var oldValue : String = null;

		/** 
		* 		* */ 
		public var newValue : String = null;

		/** 
		* a list of attributes which may be updated on this object 
		* */ 
		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('descriptor');
			arr.push('oldValue');
			arr.push('newValue');
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
