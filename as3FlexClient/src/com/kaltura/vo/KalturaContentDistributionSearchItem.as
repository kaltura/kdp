package com.kaltura.vo
{
	import com.kaltura.vo.KalturaSearchItem;

	[Bindable]
	public dynamic class KalturaContentDistributionSearchItem extends KalturaSearchItem
	{
		/** 
		* 		* */ 
		public var noDistributionProfiles : Boolean;

		/** 
		* 		* */ 
		public var distributionProfileId : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var distributionSunStatus : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var entryDistributionFlag : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var entryDistributionStatus : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var hasEntryDistributionValidationErrors : Boolean;

		/** 
		* Comma seperated validation error types		* */ 
		public var entryDistributionValidationErrors : String;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('noDistributionProfiles');
			arr.push('distributionProfileId');
			arr.push('distributionSunStatus');
			arr.push('entryDistributionFlag');
			arr.push('entryDistributionStatus');
			arr.push('hasEntryDistributionValidationErrors');
			arr.push('entryDistributionValidationErrors');
			return arr;
		}

		override public function getInsertableParamKeys():Array
		{
			var arr : Array;
			arr = super.getInsertableParamKeys();
			return arr;
		}

	}
}
