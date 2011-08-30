package com.kaltura.vo
{
	import com.kaltura.vo.KalturaDistributionProfile;

	[Bindable]
	public dynamic class KalturaPodcastDistributionProfile extends KalturaDistributionProfile
	{
		/** 
		* 		* */ 
		public var xsl : String = null;

		/** 
		* 		* */ 
		public var feedId : String = null;

		/** 
		* 		* */ 
		public var metadataProfileId : int = int.MIN_VALUE;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('xsl');
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
