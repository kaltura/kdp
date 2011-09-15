package com.kaltura.vo
{
	import com.kaltura.vo.KalturaDistributionProfile;

	[Bindable]
	public dynamic class KalturaFreewheelDistributionProfile extends KalturaDistributionProfile
	{
		/** 
		* 		* */ 
		public var apikey : String = null;

		/** 
		* 		* */ 
		public var email : String = null;

		/** 
		* 		* */ 
		public var sftpPass : String = null;

		/** 
		* 		* */ 
		public var sftpLogin : String = null;

		/** 
		* 		* */ 
		public var accountId : String = null;

		/** 
		* 		* */ 
		public var metadataProfileId : int = int.MIN_VALUE;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('apikey');
			arr.push('email');
			arr.push('sftpPass');
			arr.push('sftpLogin');
			arr.push('accountId');
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
