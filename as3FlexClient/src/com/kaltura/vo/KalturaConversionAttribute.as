package com.kaltura.vo
{
	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaConversionAttribute extends BaseFlexVo
	{
		/** 
		* The id of the flavor params, set to null for source flavor
		* */ 
		public var flavorParamsId : int = int.MIN_VALUE;

		/** 
		* Attribute name  
		* */ 
		public var name : String = null;

		/** 
		* Attribute value  
		* */ 
		public var value : String = null;

		/** 
		* a list of attributes which may be updated on this object 
		* */ 
		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('flavorParamsId');
			arr.push('name');
			arr.push('value');
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
