package com.kaltura.vo
{
	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaEntryContextDataResult extends BaseFlexVo
	{
		public var isSiteRestricted : Boolean;

		public var isCountryRestricted : Boolean;

		public var isSessionRestricted : Boolean;

		public var previewLength : int = int.MIN_VALUE;

		public var isScheduledNow : Boolean;

		public var isAdmin : Boolean;

		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('isSiteRestricted');
			arr.push('isCountryRestricted');
			arr.push('isSessionRestricted');
			arr.push('previewLength');
			arr.push('isScheduledNow');
			arr.push('isAdmin');
			return arr;
		}
	}
}
