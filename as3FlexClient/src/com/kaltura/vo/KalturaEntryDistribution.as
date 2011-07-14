package com.kaltura.vo
{
	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaEntryDistribution extends BaseFlexVo
	{
		/** 
		* Auto generated unique id
		* */ 
		public var id : int = int.MIN_VALUE;

		/** 
		* Entry distribution creation date as Unix timestamp (In seconds)
		* */ 
		public var createdAt : int = int.MIN_VALUE;

		/** 
		* Entry distribution last update date as Unix timestamp (In seconds)
		* */ 
		public var updatedAt : int = int.MIN_VALUE;

		/** 
		* Entry distribution submission date as Unix timestamp (In seconds)
		* */ 
		public var submittedAt : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var entryId : String;

		/** 
		* 		* */ 
		public var partnerId : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var distributionProfileId : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var status : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var sunStatus : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var dirtyStatus : int = int.MIN_VALUE;

		/** 
		* Comma separated thumbnail asset ids		* */ 
		public var thumbAssetIds : String;

		/** 
		* Comma separated flavor asset ids		* */ 
		public var flavorAssetIds : String;

		/** 
		* Entry distribution publish time as Unix timestamp (In seconds)
		* */ 
		public var sunrise : int = int.MIN_VALUE;

		/** 
		* Entry distribution un-publish time as Unix timestamp (In seconds)
		* */ 
		public var sunset : int = int.MIN_VALUE;

		/** 
		* The id as returned from the distributed destination		* */ 
		public var remoteId : String;

		/** 
		* The plays as retrieved from the remote destination reports		* */ 
		public var plays : int = int.MIN_VALUE;

		/** 
		* The views as retrieved from the remote destination reports		* */ 
		public var views : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var validationErrors : Array = new Array();

		/** 
		* 		* */ 
		public var errorType : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var errorNumber : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var errorDescription : String;

		/** 
		* 		* */ 
		public var hasSubmitResultsLog : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var hasSubmitSentDataLog : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var hasUpdateResultsLog : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var hasUpdateSentDataLog : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var hasDeleteResultsLog : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var hasDeleteSentDataLog : int = int.MIN_VALUE;

		/** 
		* a list of attributes which may be updated on this object 
		* */ 
		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('thumbAssetIds');
			arr.push('flavorAssetIds');
			arr.push('sunrise');
			arr.push('sunset');
			return arr;
		}

		/** 
		* a list of attributes which may only be inserted when initializing this object 
		* */ 
		public function getInsertableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('entryId');
			arr.push('distributionProfileId');
			return arr;
		}

	}
}
