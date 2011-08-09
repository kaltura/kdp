package com.kaltura.vo
{
	import com.kaltura.vo.KalturaDistributionProfile;

	[Bindable]
	public dynamic class KalturaYoutubeApiDistributionProfile extends KalturaDistributionProfile
	{
		/** 
		* 		* */ 
		public var username : String;

		/** 
		* 		* */ 
		public var password : String;

		/** 
		* 		* */ 
		public var defaultCategory : String;

		/** 
		* 		* */ 
		public var allowComments : String;

		/** 
		* 		* */ 
		public var allowEmbedding : String;

		/** 
		* 		* */ 
		public var allowRatings : String;

		/** 
		* 		* */ 
		public var allowResponses : String;

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
