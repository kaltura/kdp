package com.kaltura.vo
{
	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaSystemPartnerConfiguration extends BaseFlexVo
	{
		/** 
		* 		* */ 
		public var id : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var partnerName : String = null;

		/** 
		* 		* */ 
		public var description : String = null;

		/** 
		* 		* */ 
		public var adminName : String = null;

		/** 
		* 		* */ 
		public var adminEmail : String = null;

		/** 
		* 		* */ 
		public var host : String = null;

		/** 
		* 		* */ 
		public var cdnHost : String = null;

		/** 
		* 		* */ 
		public var partnerPackage : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var monitorUsage : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var moderateContent : Boolean;

		/** 
		* 		* */ 
		public var rtmpUrl : String = null;

		/** 
		* 		* */ 
		public var storageDeleteFromKaltura : Boolean;

		/** 
		* 		* */ 
		public var storageServePriority : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var kmcVersion : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var restrictThumbnailByKs : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var defThumbOffset : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var userSessionRoleId : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var adminSessionRoleId : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var alwaysAllowedPermissionNames : String = null;

		/** 
		* 		* */ 
		public var importRemoteSourceForConvert : Boolean;

		/** 
		* 		* */ 
		public var permissions : Array = new Array();

		/** 
		* 		* */ 
		public var notificationsConfig : String = null;

		/** 
		* 		* */ 
		public var allowMultiNotification : Boolean;

		/** 
		* 		* */ 
		public var loginBlockPeriod : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var numPrevPassToKeep : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var passReplaceFreq : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var isFirstLogin : Boolean;

		/** 
		* 		* */ 
		public var partnerGroupType : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var partnerParentId : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var limits : Array = new Array();

		/** 
		* http/rtmp/hdnetwork		* */ 
		public var streamerType : String = null;

		/** 
		* http/https, rtmp/rtmpe		* */ 
		public var mediaProtocol : String = null;

		/** 
		* 		* */ 
		public var extendedFreeTrailExpiryReason : String = null;

		/** 
		* Unix timestamp (In seconds)
		* */ 
		public var extendedFreeTrailExpiryDate : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var extendedFreeTrail : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var crmId : String = null;

		/** 
		* 		* */ 
		public var crmLink : String = null;

		/** 
		* 		* */ 
		public var verticalClasiffication : String = null;

		/** 
		* 		* */ 
		public var partnerPackageClassOfService : String = null;

		/** 
		* a list of attributes which may be updated on this object 
		* */ 
		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('partnerName');
			arr.push('description');
			arr.push('adminName');
			arr.push('adminEmail');
			arr.push('host');
			arr.push('cdnHost');
			arr.push('partnerPackage');
			arr.push('monitorUsage');
			arr.push('moderateContent');
			arr.push('rtmpUrl');
			arr.push('storageDeleteFromKaltura');
			arr.push('storageServePriority');
			arr.push('kmcVersion');
			arr.push('restrictThumbnailByKs');
			arr.push('defThumbOffset');
			arr.push('userSessionRoleId');
			arr.push('adminSessionRoleId');
			arr.push('alwaysAllowedPermissionNames');
			arr.push('importRemoteSourceForConvert');
			arr.push('permissions');
			arr.push('notificationsConfig');
			arr.push('allowMultiNotification');
			arr.push('loginBlockPeriod');
			arr.push('numPrevPassToKeep');
			arr.push('passReplaceFreq');
			arr.push('isFirstLogin');
			arr.push('partnerGroupType');
			arr.push('partnerParentId');
			arr.push('limits');
			arr.push('streamerType');
			arr.push('mediaProtocol');
			arr.push('extendedFreeTrailExpiryReason');
			arr.push('extendedFreeTrailExpiryDate');
			arr.push('extendedFreeTrail');
			arr.push('crmId');
			arr.push('crmLink');
			arr.push('verticalClasiffication');
			arr.push('partnerPackageClassOfService');
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
