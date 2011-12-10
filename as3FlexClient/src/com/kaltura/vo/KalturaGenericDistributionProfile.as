package com.kaltura.vo
{
	import com.kaltura.vo.KalturaGenericDistributionProfileAction;

	import com.kaltura.vo.KalturaGenericDistributionProfileAction;

	import com.kaltura.vo.KalturaGenericDistributionProfileAction;

	import com.kaltura.vo.KalturaGenericDistributionProfileAction;

	import com.kaltura.vo.KalturaDistributionProfile;

	[Bindable]
	public dynamic class KalturaGenericDistributionProfile extends KalturaDistributionProfile
	{
		/** 
		* 		* */ 
		public var genericProviderId : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var submitAction : KalturaGenericDistributionProfileAction;

		/** 
		* 		* */ 
		public var updateAction : KalturaGenericDistributionProfileAction;

		/** 
		* 		* */ 
		public var deleteAction : KalturaGenericDistributionProfileAction;

		/** 
		* 		* */ 
		public var fetchReportAction : KalturaGenericDistributionProfileAction;

		/** 
		* 		* */ 
		public var updateRequiredEntryFields : String = null;

		/** 
		* 		* */ 
		public var updateRequiredMetadataXPaths : String = null;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('submitAction');
			arr.push('updateAction');
			arr.push('deleteAction');
			arr.push('fetchReportAction');
			arr.push('updateRequiredEntryFields');
			arr.push('updateRequiredMetadataXPaths');
			return arr;
		}

		override public function getInsertableParamKeys():Array
		{
			var arr : Array;
			arr = super.getInsertableParamKeys();
			arr.push('genericProviderId');
			return arr;
		}

	}
}
