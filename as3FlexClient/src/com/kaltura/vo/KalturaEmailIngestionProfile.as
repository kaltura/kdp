package com.kaltura.vo
{
	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaEmailIngestionProfile extends BaseFlexVo
	{
		public var id : int = int.MIN_VALUE;
		public var name : String;
		public var description : String;
		public var emailAddress : String;
		public var mailboxId : String;
		public var partnerId : int = int.MIN_VALUE;
		public var conversionProfile2Id : int = int.MIN_VALUE;
		public var moderationStatus : int = int.MIN_VALUE;
		public var status : int = int.MIN_VALUE;
		public var createdAt : String;
		public var defaultCategory : String;
		public var defaultUserId : String;
		public var defaultTags : String;
		public var defaultAdminTags : String;
		public var maxAttachmentSizeKbytes : int = int.MIN_VALUE;
		public var maxAttachmentsPerMail : int = int.MIN_VALUE;
		override protected function setupPropertyList():void
		{
			super.setupPropertyList();
			propertyList.push('id');
			propertyList.push('name');
			propertyList.push('description');
			propertyList.push('emailAddress');
			propertyList.push('mailboxId');
			propertyList.push('partnerId');
			propertyList.push('conversionProfile2Id');
			propertyList.push('moderationStatus');
			propertyList.push('status');
			propertyList.push('createdAt');
			propertyList.push('defaultCategory');
			propertyList.push('defaultUserId');
			propertyList.push('defaultTags');
			propertyList.push('defaultAdminTags');
			propertyList.push('maxAttachmentSizeKbytes');
			propertyList.push('maxAttachmentsPerMail');
		}
		public function getParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('id');
			arr.push('name');
			arr.push('description');
			arr.push('emailAddress');
			arr.push('mailboxId');
			arr.push('partnerId');
			arr.push('conversionProfile2Id');
			arr.push('moderationStatus');
			arr.push('status');
			arr.push('createdAt');
			arr.push('defaultCategory');
			arr.push('defaultUserId');
			arr.push('defaultTags');
			arr.push('defaultAdminTags');
			arr.push('maxAttachmentSizeKbytes');
			arr.push('maxAttachmentsPerMail');
			return arr;
		}

		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('name');
			arr.push('description');
			arr.push('emailAddress');
			arr.push('mailboxId');
			arr.push('partnerId');
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

	}
}
