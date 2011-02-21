package com.kaltura.vo
{
	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaEntryDistribution extends BaseFlexVo
	{
		public var id : int = int.MIN_VALUE;

		public var createdAt : int = int.MIN_VALUE;

		public var updatedAt : int = int.MIN_VALUE;

		public var submittedAt : int = int.MIN_VALUE;

		public var entryId : String;

		public var partnerId : int = int.MIN_VALUE;

		public var distributionProfileId : int = int.MIN_VALUE;

		public var status : int = int.MIN_VALUE;

		public var dirtyStatus : int = int.MIN_VALUE;

		public var thumbAssetIds : String;

		public var flavorAssetIds : String;

		public var sunrise : int = int.MIN_VALUE;

		public var sunset : int = int.MIN_VALUE;

		public var remoteId : String;

		public var plays : int = int.MIN_VALUE;

		public var views : int = int.MIN_VALUE;

		public var validationErrors : Array = new Array();

		public var errorType : int = int.MIN_VALUE;

		public var errorNumber : int = int.MIN_VALUE;

		public var errorDescription : String;

		public var hasSubmitResultsLog : Boolean;

		public var hasSubmitSentDataLog : Boolean;

		public var hasUpdateResultsLog : Boolean;

		public var hasUpdateSentDataLog : Boolean;

		public var hasDeleteResultsLog : Boolean;

		public var hasDeleteSentDataLog : Boolean;

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
	}
}
