package com.kaltura.vo
{
	import com.kaltura.vo.KalturaConfigurableDistributionProfile;

	[Bindable]
	public dynamic class KalturaHuluDistributionProfile extends KalturaConfigurableDistributionProfile
	{
		/** 
		* 		* */ 
		public var sftpHost : String = null;

		/** 
		* 		* */ 
		public var sftpLogin : String = null;

		/** 
		* 		* */ 
		public var sftpPass : String = null;

		/** 
		* 		* */ 
		public var seriesChannel : String = null;

		/** 
		* 		* */ 
		public var seriesPrimaryCategory : String = null;

		/** 
		* 		* */ 
		public var seriesAdditionalCategories : Array = new Array();

		/** 
		* 		* */ 
		public var seasonNumber : String = null;

		/** 
		* 		* */ 
		public var seasonSynopsis : String = null;

		/** 
		* 		* */ 
		public var seasonTuneInInformation : String = null;

		/** 
		* 		* */ 
		public var videoMediaType : String = null;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('sftpHost');
			arr.push('sftpLogin');
			arr.push('sftpPass');
			arr.push('seriesChannel');
			arr.push('seriesPrimaryCategory');
			arr.push('seriesAdditionalCategories');
			arr.push('seasonNumber');
			arr.push('seasonSynopsis');
			arr.push('seasonTuneInInformation');
			arr.push('videoMediaType');
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
