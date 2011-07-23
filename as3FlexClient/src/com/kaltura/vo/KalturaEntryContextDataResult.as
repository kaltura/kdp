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
		public var previewLength : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var isScheduledNow : Boolean;

		/** 
		* 		* */ 
		public var isAdmin : Boolean;

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
			arr.push('previewLength');
			arr.push('isScheduledNow');
			arr.push('isAdmin');
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
