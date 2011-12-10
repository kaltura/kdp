package com.kaltura.vo
{
	import com.kaltura.vo.KalturaConfigurableDistributionProfile;

	[Bindable]
	public dynamic class KalturaDoubleClickDistributionProfile extends KalturaConfigurableDistributionProfile
	{
		/** 
		* 		* */ 
		public var channelTitle : String = null;

		/** 
		* 		* */ 
		public var channelLink : String = null;

		/** 
		* 		* */ 
		public var channelDescription : String = null;

		/** 
		* 		* */ 
		public var feedUrl : String = null;

		/** 
		* 		* */ 
		public var cuePointsProvider : String = null;

		/** 
		* 		* */ 
		public var itemsPerPage : String = null;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('channelTitle');
			arr.push('channelLink');
			arr.push('channelDescription');
			arr.push('cuePointsProvider');
			arr.push('itemsPerPage');
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
