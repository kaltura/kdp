package com.kaltura.vo
{
	import com.kaltura.vo.KalturaConfigurableDistributionProfile;

	[Bindable]
	public dynamic class KalturaComcastMrssDistributionProfile extends KalturaConfigurableDistributionProfile
	{
		/** 
		* 		* */ 
		public var metadataProfileId : int = int.MIN_VALUE;

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

		/** 
		* 		* */ 
		public var feedLastBuildDate : String = null;

		/** 
		* 		* */ 
		public var itemLink : String = null;

		/** 
		* 		* */ 
		public var cPlatformTvSeries : Array = new Array();

		/** 
		* 		* */ 
		public var cPlatformTvSeriesField : String = null;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('metadataProfileId');
			arr.push('feedTitle');
			arr.push('feedLink');
			arr.push('feedDescription');
			arr.push('feedLastBuildDate');
			arr.push('itemLink');
			arr.push('cPlatformTvSeries');
			arr.push('cPlatformTvSeriesField');
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
