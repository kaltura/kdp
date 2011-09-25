package com.kaltura.vo
{
	import com.kaltura.vo.KalturaDistributionProfile;

	[Bindable]
	public dynamic class KalturaYoutubeApiDistributionProfile extends KalturaDistributionProfile
	{
		/** 
		* 		* */ 
		public var username : String = null;

		/** 
		* 		* */ 
		public var password : String = null;

		/** 
		* 		* */ 
		public var defaultCategory : String = null;

		/** 
		* 		* */ 
		public var allowComments : String = null;

		/** 
		* 		* */ 
		public var allowEmbedding : String = null;

		/** 
		* 		* */ 
		public var allowRatings : String = null;

		/** 
		* 		* */ 
		public var allowResponses : String = null;

		/** 
		* 		* */ 
		public var metadataProfileId : int = int.MIN_VALUE;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('username');
			arr.push('password');
			arr.push('defaultCategory');
			arr.push('allowComments');
			arr.push('allowEmbedding');
			arr.push('allowRatings');
			arr.push('allowResponses');
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
