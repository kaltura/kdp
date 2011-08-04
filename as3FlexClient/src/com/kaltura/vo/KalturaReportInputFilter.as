package com.kaltura.vo
{
	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaReportInputFilter extends BaseFlexVo
	{
		/** 
		* 		* */ 
		public var fromDate : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var toDate : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var keywords : String;

		/** 
		* 		* */ 
		public var searchInTags : Boolean;

		/** 
		* 		* */ 
		public var searchInAdminTags : Boolean;

		/** 
		* 		* */ 
		public var categories : String;

		/** 
		* time zone offset in minutes		* */ 
		public var timeZoneOffset : int = int.MIN_VALUE;

		/** 
		* a list of attributes which may be updated on this object 
		* */ 
		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('fromDate');
			arr.push('toDate');
			arr.push('keywords');
			arr.push('searchInTags');
			arr.push('searchInAdminTags');
			arr.push('categories');
			arr.push('timeZoneOffset');
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
