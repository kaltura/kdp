package com.kaltura.vo
{
	import com.kaltura.vo.KalturaDistributionProfile;

	[Bindable]
	public dynamic class KalturaDailymotionDistributionProfile extends KalturaDistributionProfile
	{
		/** 
		* 		* */ 
		public var user : String = null;

		/** 
		* 		* */ 
		public var password : String = null;

		/** 
		* 		* */ 
		public var metadataProfileId : int = int.MIN_VALUE;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('user');
			arr.push('password');
			arr.push('metadataProfileId');
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
