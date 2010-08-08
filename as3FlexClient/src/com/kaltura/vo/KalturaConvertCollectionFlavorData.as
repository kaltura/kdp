package com.kaltura.vo
{
	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaConvertCollectionFlavorData extends BaseFlexVo
	{
		public var flavorAssetId : String;
		public var flavorParamsOutputId : int = int.MIN_VALUE;
		public var readyBehavior : int = int.MIN_VALUE;
		public var videoBitrate : int = int.MIN_VALUE;
		public var audioBitrate : int = int.MIN_VALUE;
		public var destFileSyncLocalPath : String;
		public var destFileSyncRemoteUrl : String;
		override protected function setupPropertyList():void
		{
			super.setupPropertyList();
			propertyList.push('flavorAssetId');
			propertyList.push('flavorParamsOutputId');
			propertyList.push('readyBehavior');
			propertyList.push('videoBitrate');
			propertyList.push('audioBitrate');
			propertyList.push('destFileSyncLocalPath');
			propertyList.push('destFileSyncRemoteUrl');
		}
		public function getParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('flavorAssetId');
			arr.push('flavorParamsOutputId');
			arr.push('readyBehavior');
			arr.push('videoBitrate');
			arr.push('audioBitrate');
			arr.push('destFileSyncLocalPath');
			arr.push('destFileSyncRemoteUrl');
			return arr;
		}

		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('flavorAssetId');
			arr.push('flavorParamsOutputId');
			arr.push('readyBehavior');
			arr.push('videoBitrate');
			arr.push('audioBitrate');
			arr.push('destFileSyncLocalPath');
			arr.push('destFileSyncRemoteUrl');
			return arr;
		}

	}
}
