package com.kaltura.vo
{
	import com.kaltura.vo.KalturaConfigurableDistributionProfile;

	[Bindable]
	public dynamic class KalturaYouTubeDistributionProfile extends KalturaConfigurableDistributionProfile
	{
		/** 
		* 		* */ 
		public var username : String = null;

		/** 
		* 		* */ 
		public var notificationEmail : String = null;

		/** 
		* 		* */ 
		public var sftpHost : String = null;

		/** 
		* 		* */ 
		public var sftpLogin : String = null;

		/** 
		* 		* */ 
		public var sftpPublicKey : String = null;

		/** 
		* 		* */ 
		public var sftpPrivateKey : String = null;

		/** 
		* 		* */ 
		public var sftpBaseDir : String = null;

		/** 
		* 		* */ 
		public var ownerName : String = null;

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
		public var commercialPolicy : String = null;

		/** 
		* 		* */ 
		public var ugcPolicy : String = null;

		/** 
		* 		* */ 
		public var target : String = null;

		/** 
		* 		* */ 
		public var adServerPartnerId : String = null;

		/** 
		* 		* */ 
		public var enableAdServer : Boolean;

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
			arr.push('adServerPartnerId');
			arr.push('enableAdServer');
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
