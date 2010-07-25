package com.kaltura.vo
{
	import com.kaltura.vo.KalturaJobData;

	[Bindable]
	public dynamic class KalturaImportJobData extends KalturaJobData
	{
		public var srcFileUrl : String;
		public var destFileLocalPath : String;
		public var flavorAssetId : String;
		override protected function setupPropertyList():void
		{
			super.setupPropertyList();
			propertyList.push('srcFileUrl');
			propertyList.push('destFileLocalPath');
			propertyList.push('flavorAssetId');
		}
		override public function getParamKeys():Array
		{
			var arr : Array;
			arr = super.getParamKeys();
			arr.push('srcFileUrl');
			arr.push('destFileLocalPath');
			arr.push('flavorAssetId');
			return arr;
		}

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
