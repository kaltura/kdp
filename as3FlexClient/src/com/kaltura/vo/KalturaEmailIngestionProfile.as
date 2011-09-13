package com.kaltura.vo
{
	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaEmailIngestionProfile extends BaseFlexVo
	{
		/** 
		* 		* */ 
		public var id : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var name : String = null;

		/** 
		* 		* */ 
		public var description : String = null;

		/** 
		* 		* */ 
		public var emailAddress : String = null;

		/** 
		* 		* */ 
		public var mailboxId : String = null;

		/** 
		* 		* */ 
		public var partnerId : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var conversionProfile2Id : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var moderationStatus : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var status : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var createdAt : String = null;

		/** 
		* 		* */ 
		public var defaultCategory : String = null;

		/** 
		* 		* */ 
		public var defaultUserId : String = null;

		/** 
		* 		* */ 
		public var defaultTags : String = null;

		/** 
		* 		* */ 
		public var defaultAdminTags : String = null;

		/** 
		* 		* */ 
		public var maxAttachmentSizeKbytes : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var maxAttachmentsPerMail : int = int.MIN_VALUE;

		/** 
		* a list of attributes which may be updated on this object 
		* */ 
		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('name');
			arr.push('description');
			arr.push('emailAddress');
			arr.push('mailboxId');
			arr.push('conversionProfile2Id');
			arr.push('moderationStatus');
			arr.push('defaultCategory');
			arr.push('defaultUserId');
			arr.push('defaultTags');
			arr.push('defaultAdminTags');
			arr.push('maxAttachmentSizeKbytes');
			arr.push('maxAttachmentsPerMail');
			return arr;
		}

		/** 
		* a list of attributes which may only be inserted when initializing this object 
		* */ 
		public function getInsertableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			return arr;
		}

	}
}
