package com.kaltura.vo
{
	import com.kaltura.vo.KalturaJobData;

	[Bindable]
	public dynamic class KalturaImportJobData extends KalturaJobData
	{
		public var srcFileUrl : String;

		public var destFileLocalPath : String;

		public var flavorAssetId : String;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('srcFileUrl');
			arr.push('destFileLocalPath');
			arr.push('flavorAssetId');
			return arr;
		}
	}
}
