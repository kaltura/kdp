package com.kaltura.vo
{
	import com.kaltura.vo.KalturaDistributionProfile;

	[Bindable]
	public dynamic class KalturaExampleDistributionProfile extends KalturaDistributionProfile
	{
		/** 
		* 		* */ 
		public var username : String = null;

		/** 
		* 		* */ 
		public var password : String = null;

		/** 
		* 		* */ 
		public var accountId : String = null;

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
