package com.kaltura.vo
{
	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaAccessControl extends BaseFlexVo
	{
		/** 
		* The id of the Access Control Profile
		* */ 
		public var id : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var partnerId : int = int.MIN_VALUE;

		/** 
		* The name of the Access Control Profile
		* */ 
		public var name : String;

		/** 
		* System name of the Access Control Profile
		* */ 
		public var systemName : String;

		/** 
		* The description of the Access Control Profile
		* */ 
		public var description : String;

		/** 
		* Creation date as Unix timestamp (In seconds) 
		* */ 
		public var createdAt : int = int.MIN_VALUE;

		/** 
		* True if this Conversion Profile is the default
		* */ 
		public var isDefault : int = int.MIN_VALUE;

		/** 
		* Array of Access Control Restrictions
		* */ 
		public var restrictions : Array = new Array();

		/** 
		* a list of attributes which may be updated on this object 
		* */ 
		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('name');
			arr.push('systemName');
			arr.push('description');
			arr.push('isDefault');
			arr.push('restrictions');
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
