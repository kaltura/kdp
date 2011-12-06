package com.kaltura.vo
{
	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaAsset extends BaseFlexVo
	{
		/** 
		* The ID of the Flavor Asset
		* */ 
		public var id : String = null;

		/** 
		* The entry ID of the Flavor Asset
		* */ 
		public var entryId : String = null;

		/** 
		* 		* */ 
		public var partnerId : int = int.MIN_VALUE;

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
		public var tags : String = null;

		/** 
		* The file extension
		* */ 
		public var fileExt : String = null;

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
		* System description, error message, warnings and failure cause.		* */ 
		public var description : String = null;

		/** 
		* Partner private data		* */ 
		public var partnerData : String = null;

		/** 
		* Partner friendly description		* */ 
		public var partnerDescription : String = null;

		/** 
		* a list of attributes which may be updated on this object 
		* */ 
		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('tags');
			arr.push('partnerData');
			arr.push('partnerDescription');
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
