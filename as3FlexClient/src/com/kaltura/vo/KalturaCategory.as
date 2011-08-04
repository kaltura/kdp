package com.kaltura.vo
{
	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaCategory extends BaseFlexVo
	{
		/** 
		* The id of the Category
		* */ 
		public var id : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var parentId : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var depth : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var partnerId : int = int.MIN_VALUE;

		/** 
		* The name of the Category. 
The following characters are not allowed: '<', '>', ','
		* */ 
		public var name : String;

		/** 
		* The full name of the Category
		* */ 
		public var fullName : String;

		/** 
		* Number of entries in this Category (including child categories)
		* */ 
		public var entriesCount : int = int.MIN_VALUE;

		/** 
		* Creation date as Unix timestamp (In seconds)
		* */ 
		public var createdAt : int = int.MIN_VALUE;

		/** 
		* a list of attributes which may be updated on this object 
		* */ 
		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('parentId');
			arr.push('name');
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
