package com.kaltura.vo
{
	import com.kaltura.vo.KalturaJobData;

	[Bindable]
	public dynamic class KalturaBulkDownloadJobData extends KalturaJobData
	{
		public var entryIds : String;

		public var flavorParamsId : int = int.MIN_VALUE;

		public var puserId : String;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('entryIds');
			arr.push('flavorParamsId');
			arr.push('puserId');
			return arr;
		}
	}
}
