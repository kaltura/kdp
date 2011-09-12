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
		public var feedLanguage : String = null;

		/** 
		* 		* */ 
		public var feedCopyright : String = null;

		/** 
		* 		* */ 
		public var feedImageTitle : String = null;

		/** 
		* 		* */ 
		public var feedImageUrl : String = null;

		/** 
		* 		* */ 
		public var feedImageLink : String = null;

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
