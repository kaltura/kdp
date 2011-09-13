package com.kaltura.vo
{
	import com.kaltura.vo.KalturaUrlResource;

	[Bindable]
	public dynamic class KalturaBulkResource extends KalturaUrlResource
	{
		public var bulkUploadId : String;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('bulkUploadId');
			return arr;
		}
	}
}
