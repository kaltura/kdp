package com.kaltura.vo
{
	import com.kaltura.vo.KalturaConfigurableDistributionProfile;

	[Bindable]
	public dynamic class KalturaTVComDistributionProfile extends KalturaConfigurableDistributionProfile
	{
		/** 
		* 		* */ 
		public var metadataProfileId : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var feedUrl : String;

		/** 
		* 		* */ 
		public var feedTitle : String;

		/** 
		* 		* */ 
		public var feedLink : String;

		/** 
		* 		* */ 
		public var feedDescription : String;

		/** 
		* 		* */ 
		public var feedLanguage : String;

		/** 
		* 		* */ 
		public var feedCopyright : String;

		/** 
		* 		* */ 
		public var feedImageTitle : String;

		/** 
		* 		* */ 
		public var feedImageUrl : String;

		/** 
		* 		* */ 
		public var feedImageLink : String;

		/** 
		* 		* */ 
		public var feedImageWidth : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var feedImageHeight : int = int.MIN_VALUE;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('metadataProfileId');
			arr.push('feedTitle');
			arr.push('feedLink');
			arr.push('feedDescription');
			arr.push('feedLanguage');
			arr.push('feedCopyright');
			arr.push('feedImageTitle');
			arr.push('feedImageUrl');
			arr.push('feedImageLink');
			arr.push('feedImageWidth');
			arr.push('feedImageHeight');
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
