package com.kaltura.vo
{
	import com.kaltura.vo.KalturaConfigurableDistributionProfile;

	[Bindable]
	public dynamic class KalturaYouTubeDistributionProfile extends KalturaConfigurableDistributionProfile
	{
		/** 
		* 		* */ 
		public var username : String;

		/** 
		* 		* */ 
		public var notificationEmail : String;

		/** 
		* 		* */ 
		public var sftpHost : String;

		/** 
		* 		* */ 
		public var sftpLogin : String;

		/** 
		* 		* */ 
		public var sftpPublicKey : String;

		/** 
		* 		* */ 
		public var sftpPrivateKey : String;

		/** 
		* 		* */ 
		public var sftpBaseDir : String;

		/** 
		* 		* */ 
		public var ownerName : String;

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
		public var commercialPolicy : String;

		/** 
		* 		* */ 
		public var ugcPolicy : String;

		/** 
		* 		* */ 
		public var target : String;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('username');
			arr.push('notificationEmail');
			arr.push('sftpHost');
			arr.push('sftpLogin');
			arr.push('sftpPublicKey');
			arr.push('sftpPrivateKey');
			arr.push('sftpBaseDir');
			arr.push('ownerName');
			arr.push('defaultCategory');
			arr.push('allowComments');
			arr.push('allowEmbedding');
			arr.push('allowRatings');
			arr.push('allowResponses');
			arr.push('commercialPolicy');
			arr.push('ugcPolicy');
			arr.push('target');
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
