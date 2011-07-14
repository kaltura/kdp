package com.kaltura.vo
{
	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaAsset extends BaseFlexVo
	{
		/** 
		* The ID of the Flavor Asset
		* */ 
		public var id : String;

		/** 
		* The entry ID of the Flavor Asset
		* */ 
		public var entryId : String;

		/** 
		* 		* */ 
		public var partnerId : int = int.MIN_VALUE;

		/** 
		* The status of the Flavor Asset
		* */ 
		public var status : int = int.MIN_VALUE;

		/** 
		* The version of the Flavor Asset
		* */ 
		public var version : int = int.MIN_VALUE;

		/** 
		* The size (in KBytes) of the Flavor Asset
		* */ 
		public var size : int = int.MIN_VALUE;

		/** 
		* Tags used to identify the Flavor Asset in various scenarios
		* */ 
		public var tags : String;

		/** 
		* The file extension
		* */ 
		public var fileExt : String;

		/** 
		* 		* */ 
		public var createdAt : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var updatedAt : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var deletedAt : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var description : String;

		/** 
		* 		* */ 
		public var partnerData : String;

		/** 
		* a list of attributes which may be updated on this object 
		* */ 
		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('tags');
			arr.push('partnerData');
			return arr;
		}

		/** 
		* a list of attributes which may only be inserted when initializing this object 
		* */ 
		public function getInsertableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('fileExt');
			return arr;
		}

	}
}
