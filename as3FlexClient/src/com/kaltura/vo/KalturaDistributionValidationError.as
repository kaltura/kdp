package com.kaltura.vo
{
	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaDistributionValidationError extends BaseFlexVo
	{
		/** 
		* 		* */ 
		public var action : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var errorType : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var description : String = null;

		/** 
		* a list of attributes which may be updated on this object 
		* */ 
		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('action');
			arr.push('errorType');
			arr.push('description');
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
