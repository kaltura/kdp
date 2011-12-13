package com.kaltura.vo
{
	import com.kaltura.vo.KalturaConfigurableDistributionProfile;

	[Bindable]
	public dynamic class KalturaVisoDistributionProfile extends KalturaConfigurableDistributionProfile
	{
		/** 
		* 		* */ 
		public var feedUrl : String = null;

		/** 
		* 		* */ 
		public var feedTitle : String = null;

		/** 
		* 		* */ 
		public var feedLink : String = null;

		/** 
		* 		* */ 
		public var feedDescription : String = null;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('feedTitle');
			arr.push('feedLink');
			arr.push('feedDescription');
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
