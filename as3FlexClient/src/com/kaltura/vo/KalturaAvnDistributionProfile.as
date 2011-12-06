package com.kaltura.vo
{
	import com.kaltura.vo.KalturaConfigurableDistributionProfile;

	[Bindable]
	public dynamic class KalturaAvnDistributionProfile extends KalturaConfigurableDistributionProfile
	{
		/** 
		* 		* */ 
		public var feedUrl : String = null;

		/** 
		* 		* */ 
		public var feedTitle : String = null;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('feedTitle');
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
