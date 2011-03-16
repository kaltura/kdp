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

		public var pluginsData : Array = new Array();

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
			arr.push('pluginsData');
			return arr;
		}
	}
}
