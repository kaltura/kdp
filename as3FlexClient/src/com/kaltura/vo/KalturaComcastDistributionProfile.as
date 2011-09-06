package com.kaltura.vo
{
	import com.kaltura.vo.KalturaDistributionProfile;

	[Bindable]
	public dynamic class KalturaComcastDistributionProfile extends KalturaDistributionProfile
	{
		/** 
		* 		* */ 
		public var email : String;

		/** 
		* 		* */ 
		public var password : String;

		/** 
		* 		* */ 
		public var account : String;

		/** 
		* 		* */ 
		public var metadataProfileId : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var keywords : String;

		/** 
		* 		* */ 
		public var category : String;

		/** 
		* 		* */ 
		public var author : String;

		/** 
		* 		* */ 
		public var album : String;

		/** 
		* 		* */ 
		public var copyright : String;

		/** 
		* 		* */ 
		public var linkHref : String;

		/** 
		* 		* */ 
		public var linkText : String;

		/** 
		* 		* */ 
		public var notesToComcast : String;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('email');
			arr.push('password');
			arr.push('account');
			arr.push('metadataProfileId');
			arr.push('keywords');
			arr.push('category');
			arr.push('author');
			arr.push('album');
			arr.push('copyright');
			arr.push('linkHref');
			arr.push('linkText');
			arr.push('notesToComcast');
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
