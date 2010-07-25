package com.kaltura.vo
{
	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaBulkUploadResult extends BaseFlexVo
	{
		public var id : int = int.MIN_VALUE;
		public var bulkUploadJobId : int = int.MIN_VALUE;
		public var lineIndex : int = int.MIN_VALUE;
		public var partnerId : int = int.MIN_VALUE;
		public var entryId : String;
		public var entryStatus : int = int.MIN_VALUE;
		public var rowData : String;
		public var title : String;
		public var description : String;
		public var tags : String;
		public var url : String;
		public var contentType : String;
		public var conversionProfileId : int = int.MIN_VALUE;
		public var accessControlProfileId : int = int.MIN_VALUE;
		public var category : String;
		public var scheduleStartDate : int = int.MIN_VALUE;
		public var scheduleEndDate : int = int.MIN_VALUE;
		public var thumbnailUrl : String;
		public var thumbnailSaved : Boolean;
		public var partnerData : String;
		public var errorDescription : String;
		override protected function setupPropertyList():void
		{
			super.setupPropertyList();
			propertyList.push('id');
			propertyList.push('bulkUploadJobId');
			propertyList.push('lineIndex');
			propertyList.push('partnerId');
			propertyList.push('entryId');
			propertyList.push('entryStatus');
			propertyList.push('rowData');
			propertyList.push('title');
			propertyList.push('description');
			propertyList.push('tags');
			propertyList.push('url');
			propertyList.push('contentType');
			propertyList.push('conversionProfileId');
			propertyList.push('accessControlProfileId');
			propertyList.push('category');
			propertyList.push('scheduleStartDate');
			propertyList.push('scheduleEndDate');
			propertyList.push('thumbnailUrl');
			propertyList.push('thumbnailSaved');
			propertyList.push('partnerData');
			propertyList.push('errorDescription');
		}
		public function getParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('id');
			arr.push('bulkUploadJobId');
			arr.push('lineIndex');
			arr.push('partnerId');
			arr.push('entryId');
			arr.push('entryStatus');
			arr.push('rowData');
			arr.push('title');
			arr.push('description');
			arr.push('tags');
			arr.push('url');
			arr.push('contentType');
			arr.push('conversionProfileId');
			arr.push('accessControlProfileId');
			arr.push('category');
			arr.push('scheduleStartDate');
			arr.push('scheduleEndDate');
			arr.push('thumbnailUrl');
			arr.push('thumbnailSaved');
			arr.push('partnerData');
			arr.push('errorDescription');
			return arr;
		}

		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('bulkUploadJobId');
			arr.push('lineIndex');
			arr.push('partnerId');
			arr.push('entryId');
			arr.push('entryStatus');
			arr.push('rowData');
			arr.push('title');
			arr.push('description');
			arr.push('tags');
			arr.push('url');
			arr.push('contentType');
			arr.push('conversionProfileId');
			arr.push('accessControlProfileId');
			arr.push('category');
			arr.push('scheduleStartDate');
			arr.push('scheduleEndDate');
			arr.push('thumbnailUrl');
			arr.push('thumbnailSaved');
			arr.push('partnerData');
			arr.push('errorDescription');
			return arr;
		}

	}
}
