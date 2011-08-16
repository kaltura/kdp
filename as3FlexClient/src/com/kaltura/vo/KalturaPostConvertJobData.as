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
