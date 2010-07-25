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
		public var createdAt : String;
		public var adminName : String;
		public var adminEmail : String;
		public var description : String;
		public var commercialUse : String;
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
		override protected function setupPropertyList():void
		{
			super.setupPropertyList();
			propertyList.push('id');
			propertyList.push('name');
			propertyList.push('website');
			propertyList.push('notificationUrl');
			propertyList.push('appearInSearch');
			propertyList.push('createdAt');
			propertyList.push('adminName');
			propertyList.push('adminEmail');
			propertyList.push('description');
			propertyList.push('commercialUse');
			propertyList.push('landingPage');
			propertyList.push('userLandingPage');
			propertyList.push('contentCategories');
			propertyList.push('type');
			propertyList.push('phone');
			propertyList.push('describeYourself');
			propertyList.push('adultContent');
			propertyList.push('defConversionProfileType');
			propertyList.push('notify');
			propertyList.push('status');
			propertyList.push('allowQuickEdit');
			propertyList.push('mergeEntryLists');
			propertyList.push('notificationsConfig');
			propertyList.push('maxUploadSize');
			propertyList.push('partnerPackage');
			propertyList.push('secret');
			propertyList.push('adminSecret');
			propertyList.push('cmsPassword');
			propertyList.push('allowMultiNotification');
		}
		public function getParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('id');
			arr.push('name');
			arr.push('website');
			arr.push('notificationUrl');
			arr.push('appearInSearch');
			arr.push('createdAt');
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
			arr.push('status');
			arr.push('allowQuickEdit');
			arr.push('mergeEntryLists');
			arr.push('notificationsConfig');
			arr.push('maxUploadSize');
			arr.push('partnerPackage');
			arr.push('secret');
			arr.push('adminSecret');
			arr.push('cmsPassword');
			arr.push('allowMultiNotification');
			return arr;
		}

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
			return arr;
		}

	}
}
