package com.kaltura.vo
{
	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaBaseEntry extends BaseFlexVo
	{
		public var id : String;

		public var name : String;

		public var description : String;

		public var partnerId : int = int.MIN_VALUE;

		public var userId : String;

		public var tags : String;

		public var adminTags : String;

		public var categories : String;

		public var categoriesIds : String;

		public var status : String;

		public var moderationStatus : int = int.MIN_VALUE;

		public var moderationCount : int = int.MIN_VALUE;

		public var type : String;

		public var createdAt : int = int.MIN_VALUE;

		public var updatedAt : int = int.MIN_VALUE;

		public var rank : Number = NaN;

		public var totalRank : int = int.MIN_VALUE;

		public var votes : int = int.MIN_VALUE;

		public var groupId : int = int.MIN_VALUE;

		public var partnerData : String;

		public var downloadUrl : String;

		public var searchText : String;

		public var licenseType : int = int.MIN_VALUE;

		public var version : int = int.MIN_VALUE;

		public var thumbnailUrl : String;

		public var accessControlId : int = int.MIN_VALUE;

		public var startDate : int = int.MIN_VALUE;

		public var endDate : int = int.MIN_VALUE;

		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('name');
			arr.push('description');
			arr.push('userId');
			arr.push('tags');
			arr.push('adminTags');
			arr.push('categories');
			arr.push('categoriesIds');
			arr.push('type');
			arr.push('groupId');
			arr.push('partnerData');
			arr.push('licenseType');
			arr.push('accessControlId');
			arr.push('startDate');
			arr.push('endDate');
			return arr;
		}
		
		public function getParamKeys():Array {
			trace("backward incompatible");
			throw new Error("backward incompatible");
		}
	}
}
