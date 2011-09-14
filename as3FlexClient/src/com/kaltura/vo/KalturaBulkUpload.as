package com.kaltura.vo
{
	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaBulkUpload extends BaseFlexVo
	{
		public var id : int = int.MIN_VALUE;

		public var uploadedBy : String;

		public var uploadedByUserId : String;

		public var uploadedOn : int = int.MIN_VALUE;

		public var numOfEntries : int = int.MIN_VALUE;

		public var status : int = int.MIN_VALUE;

		public var logFileUrl : String;

		public var csvFileUrl : String;

		public var results : Array = new Array();

		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('id');
			arr.push('uploadedBy');
			arr.push('uploadedByUserId');
			arr.push('uploadedOn');
			arr.push('numOfEntries');
			arr.push('status');
			arr.push('logFileUrl');
			arr.push('csvFileUrl');
			arr.push('results');
			return arr;
		}
	}
}
