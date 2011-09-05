package com.kaltura.vo
{
	import com.kaltura.vo.KalturaJobData;

	[Bindable]
	public dynamic class KalturaBulkUploadJobData extends KalturaJobData
	{
		public var userId : int = int.MIN_VALUE;

		public var uploadedBy : String;

		public var conversionProfileId : int = int.MIN_VALUE;

		public var csvFilePath : String;

		public var resultsFileLocalPath : String;

		public var resultsFileUrl : String;

		public var numOfEntries : int = int.MIN_VALUE;

		public var csvVersion : String;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('userId');
			arr.push('uploadedBy');
			arr.push('conversionProfileId');
			arr.push('csvFilePath');
			arr.push('resultsFileLocalPath');
			arr.push('resultsFileUrl');
			arr.push('numOfEntries');
			arr.push('csvVersion');
			return arr;
		}
	}
}
