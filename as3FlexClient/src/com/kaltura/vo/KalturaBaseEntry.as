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
		public var status : int = int.MIN_VALUE;
		public var moderationStatus : int = int.MIN_VALUE;
		public var moderationCount : int = int.MIN_VALUE;
		public var type : int = int.MIN_VALUE;
		public var createdAt : int = int.MIN_VALUE;
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
		override protected function setupPropertyList():void
		{
			super.setupPropertyList();
			propertyList.push('id');
			propertyList.push('name');
			propertyList.push('description');
			propertyList.push('partnerId');
			propertyList.push('userId');
			propertyList.push('tags');
			propertyList.push('adminTags');
			propertyList.push('categories');
			propertyList.push('status');
			propertyList.push('moderationStatus');
			propertyList.push('moderationCount');
			propertyList.push('type');
			propertyList.push('createdAt');
			propertyList.push('rank');
			propertyList.push('totalRank');
			propertyList.push('votes');
			propertyList.push('groupId');
			propertyList.push('partnerData');
			propertyList.push('downloadUrl');
			propertyList.push('searchText');
			propertyList.push('licenseType');
			propertyList.push('version');
			propertyList.push('thumbnailUrl');
			propertyList.push('accessControlId');
			propertyList.push('startDate');
			propertyList.push('endDate');
		}
		public function getParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('id');
			arr.push('name');
			arr.push('description');
			arr.push('partnerId');
			arr.push('userId');
			arr.push('tags');
			arr.push('adminTags');
			arr.push('categories');
			arr.push('status');
			arr.push('moderationStatus');
			arr.push('moderationCount');
			arr.push('type');
			arr.push('createdAt');
			arr.push('rank');
			arr.push('totalRank');
			arr.push('votes');
			arr.push('groupId');
			arr.push('partnerData');
			arr.push('downloadUrl');
			arr.push('searchText');
			arr.push('licenseType');
			arr.push('version');
			arr.push('thumbnailUrl');
			arr.push('accessControlId');
			arr.push('startDate');
			arr.push('endDate');
			return arr;
		}

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
			arr.push('groupId');
			arr.push('partnerData');
			arr.push('licenseType');
			arr.push('accessControlId');
			arr.push('startDate');
			arr.push('endDate');
			return arr;
		}

	}
}
