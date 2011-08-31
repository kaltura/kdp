package com.kaltura.vo
{
	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaAssetParams extends BaseFlexVo
	{
		/** 
		* The id of the Flavor Params
		* */ 
		public var id : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var partnerId : int = int.MIN_VALUE;

		/** 
		* The name of the Flavor Params
		* */ 
		public var name : String = null;

		/** 
		* System name of the Flavor Params
		* */ 
		public var systemName : String = null;

		/** 
		* The description of the Flavor Params
		* */ 
		public var description : String = null;

		/** 
		* Creation date as Unix timestamp (In seconds)
		* */ 
		public var createdAt : int = int.MIN_VALUE;

		/** 
		* True if those Flavor Params are part of system defaults
		* */ 
		public var isSystemDefault : int = int.MIN_VALUE;

		/** 
		* The Flavor Params tags are used to identify the flavor for different usage (e.g. web, hd, mobile)
		* */ 
		public var tags : String = null;

		/** 
		* Array of partner permisison names that required for using this asset params
		* */ 
		public var requiredPermissions : Array = new Array();

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
			arr.push('tags');
			arr.push('requiredPermissions');
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
