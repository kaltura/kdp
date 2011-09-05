package com.kaltura.vo
{
	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaPartner extends BaseFlexVo
	{
		/** 
		* 		* */ 
		public var id : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var name : String = null;

		/** 
		* 		* */ 
		public var website : String = null;

		/** 
		* 		* */ 
		public var notificationUrl : String = null;

		/** 
		* 		* */ 
		public var appearInSearch : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var createdAt : int = int.MIN_VALUE;

		/** 
		* deprecated - lastName and firstName replaces this field		* */ 
		public var adminName : String = null;

		/** 
		* 		* */ 
		public var adminEmail : String = null;

		/** 
		* 		* */ 
		public var description : String = null;

		/** 
		* 		* */ 
		public var commercialUse : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var landingPage : String = null;

		/** 
		* 		* */ 
		public var userLandingPage : String = null;

		/** 
		* 		* */ 
		public var contentCategories : String = null;

		/** 
		* 		* */ 
		public var type : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var phone : String = null;

		/** 
		* 		* */ 
		public var describeYourself : String = null;

		/** 
		* 		* */ 
		public var adultContent : Boolean;

		/** 
		* 		* */ 
		public var defConversionProfileType : String = null;

		/** 
		* 		* */ 
		public var notify : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var status : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var allowQuickEdit : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var mergeEntryLists : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var notificationsConfig : String = null;

		/** 
		* 		* */ 
		public var maxUploadSize : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var partnerPackage : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var secret : String = null;

		/** 
		* 		* */ 
		public var adminSecret : String = null;

		/** 
		* 		* */ 
		public var cmsPassword : String = null;

		/** 
		* 		* */ 
		public var allowMultiNotification : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var adminLoginUsersQuota : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var adminUserId : String = null;

		/** 
		* firstName and lastName replace the old (deprecated) adminName		* */ 
		public var firstName : String = null;

		/** 
		* lastName and firstName replace the old (deprecated) adminName		* */ 
		public var lastName : String = null;

		/** 
		* country code (2char) - this field is optional
		* */ 
		public var country : String = null;

		/** 
		* state code (2char) - this field is optional		* */ 
		public var state : String = null;

		/** 
		* 		* */ 
		public var additionalParams : Array = new Array();

		/** 
		* a list of attributes which may be updated on this object 
		* */ 
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
			arr.push('firstName');
			arr.push('lastName');
			arr.push('country');
			arr.push('state');
			return arr;
		}

		/** 
		* a list of attributes which may only be inserted when initializing this object 
		* */ 
		public function getInsertableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('additionalParams');
			return arr;
		}

	}
}
