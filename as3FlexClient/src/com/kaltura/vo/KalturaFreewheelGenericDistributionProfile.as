package com.kaltura.vo
{
	import com.kaltura.vo.KalturaConfigurableDistributionProfile;

	[Bindable]
	public dynamic class KalturaFreewheelGenericDistributionProfile extends KalturaConfigurableDistributionProfile
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
		public var contentOwner : String = null;

		/** 
		* 		* */ 
		public var upstreamVideoId : String = null;

		/** 
		* 		* */ 
		public var upstreamNetworkName : String = null;

		/** 
		* 		* */ 
		public var upstreamNetworkId : String = null;

		/** 
		* 		* */ 
		public var categoryId : String = null;

		/** 
		* 		* */ 
		public var replaceGroup : Boolean;

		/** 
		* 		* */ 
		public var replaceAirDates : Boolean;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('apikey');
			arr.push('email');
			arr.push('sftpPass');
			arr.push('sftpLogin');
			arr.push('contentOwner');
			arr.push('upstreamVideoId');
			arr.push('upstreamNetworkName');
			arr.push('upstreamNetworkId');
			arr.push('categoryId');
			arr.push('replaceGroup');
			arr.push('replaceAirDates');
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
