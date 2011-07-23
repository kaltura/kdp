package com.kaltura.vo
{
	import com.kaltura.vo.KalturaDistributionProfile;

	[Bindable]
	public dynamic class KalturaExampleDistributionProfile extends KalturaDistributionProfile
	{
		/** 
		* 		* */ 
		public var username : String;

		/** 
		* 		* */ 
		public var password : String;

		/** 
		* 		* */ 
		public var accountId : String;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('username');
			arr.push('password');
			arr.push('accountId');
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
