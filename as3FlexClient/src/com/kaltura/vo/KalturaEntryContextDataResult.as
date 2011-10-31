package com.kaltura.vo
{
	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaEntryContextDataResult extends BaseFlexVo
	{
		/** 
		* 		* */ 
		public var isSiteRestricted : Boolean;

		/** 
		* 		* */ 
		public var isCountryRestricted : Boolean;

		/** 
		* 		* */ 
		public var isSessionRestricted : Boolean;

		/** 
		* 		* */ 
		public var isIpAddressRestricted : Boolean;

		/** 
		* 		* */ 
		public var isUserAgentRestricted : Boolean;

		/** 
		* 		* */ 
		public var previewLength : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var isScheduledNow : Boolean;

		/** 
		* 		* */ 
		public var isAdmin : Boolean;

		/** 
		* http/rtmp/hdnetwork		* */ 
		public var streamerType : String = null;

		/** 
		* http/https, rtmp/rtmpe		* */ 
		public var mediaProtocol : String = null;

		/** 
		* 		* */ 
		public var storageProfilesXML : String = null;

		/** 
		* a list of attributes which may be updated on this object 
		* */ 
		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('isSiteRestricted');
			arr.push('isCountryRestricted');
			arr.push('isSessionRestricted');
			arr.push('isIpAddressRestricted');
			arr.push('isUserAgentRestricted');
			arr.push('previewLength');
			arr.push('isScheduledNow');
			arr.push('isAdmin');
			arr.push('streamerType');
			arr.push('mediaProtocol');
			arr.push('storageProfilesXML');
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
