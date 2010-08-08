package com.kaltura.vo
{
	import com.kaltura.vo.KalturaConvartableJobData;

	[Bindable]
	public dynamic class KalturaPostConvertJobData extends KalturaConvartableJobData
	{
		public var flavorAssetId : String;
		public var createThumb : Boolean;
		public var thumbPath : String;
		public var thumbOffset : int = int.MIN_VALUE;
		public var thumbHeight : int = int.MIN_VALUE;
		public var thumbBitrate : int = int.MIN_VALUE;
		override protected function setupPropertyList():void
		{
			super.setupPropertyList();
			propertyList.push('flavorAssetId');
			propertyList.push('createThumb');
			propertyList.push('thumbPath');
			propertyList.push('thumbOffset');
			propertyList.push('thumbHeight');
			propertyList.push('thumbBitrate');
		}
		override public function getParamKeys():Array
		{
			var arr : Array;
			arr = super.getParamKeys();
			arr.push('flavorAssetId');
			arr.push('createThumb');
			arr.push('thumbPath');
			arr.push('thumbOffset');
			arr.push('thumbHeight');
			arr.push('thumbBitrate');
			return arr;
		}

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('flavorAssetId');
			arr.push('createThumb');
			arr.push('thumbPath');
			arr.push('thumbOffset');
			arr.push('thumbHeight');
			arr.push('thumbBitrate');
			return arr;
		}

	}
}
