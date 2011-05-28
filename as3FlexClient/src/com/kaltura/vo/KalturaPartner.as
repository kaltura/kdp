package com.kaltura.vo
{
	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaPartner extends BaseFlexVo
	{
		public var id : int = int.MIN_VALUE;

		public var name : String;

		public var website : String;

		public var notificationUrl : String;

		public var appearInSearch : int = int.MIN_VALUE;

		public var createdAt : int = int.MIN_VALUE;

		public var adminName : String;

		public var adminEmail : String;

		public var description : String;

		public var commercialUse : int = int.MIN_VALUE;

		public var landingPage : String;

		public var userLandingPage : String;

		public var contentCategories : String;

		public var type : int = int.MIN_VALUE;

		public var phone : String;

		public var describeYourself : String;

		public var adultContent : Boolean;

		public var defConversionProfileType : String;

		public var notify : int = int.MIN_VALUE;

		public var status : int = int.MIN_VALUE;

		public var allowQuickEdit : int = int.MIN_VALUE;

		public var mergeEntryLists : int = int.MIN_VALUE;

		public var notificationsConfig : String;

		public var maxUploadSize : int = int.MIN_VALUE;

		public var partnerPackage : int = int.MIN_VALUE;

		public var secret : String;

		public var adminSecret : String;

		public var cmsPassword : String;

		public var allowMultiNotification : int = int.MIN_VALUE;

		public var adminLoginUsersQuota : int = int.MIN_VALUE;

		public var adminUserId : String;

		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('name');
			arr.push('website');
			arr.push('notificationUrl');
			arr.push('appearInSearch');
			arr.push('adminName');
			arr.push('adminEmail');
			arr.push('description');
			arr.push('commercialUse');
			arr.push('landingPage');
			arr.push('userLandingPage');
			arr.push('contentCategories');
			arr.push('type');
			arr.push('phone');
			arr.push('describeYourself');
			arr.push('adultContent');
			arr.push('defConversionProfileType');
			arr.push('notify');
			arr.push('allowQuickEdit');
			arr.push('mergeEntryLists');
			arr.push('notificationsConfig');
			arr.push('maxUploadSize');
			arr.push('allowMultiNotification');
			arr.push('adminUserId');
			return arr;
		}
	}
}
