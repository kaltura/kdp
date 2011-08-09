package com.kaltura.vo
{
	import com.kaltura.vo.KalturaThumbParamsOutput;

	import com.kaltura.vo.KalturaJobData;

	[Bindable]
	public dynamic class KalturaCaptureThumbJobData extends KalturaJobData
	{
		public var srcFileSyncLocalPath : String;

		public var actualSrcFileSyncLocalPath : String;

		public var srcFileSyncRemoteUrl : String;

		public var thumbParamsOutputId : int = int.MIN_VALUE;

		public var thumbParamsOutput : KalturaThumbParamsOutput;

		public var thumbAssetId : String;

		public var srcAssetType : String;

		public var thumbPath : String;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('srcFileSyncLocalPath');
			arr.push('actualSrcFileSyncLocalPath');
			arr.push('srcFileSyncRemoteUrl');
			arr.push('thumbParamsOutputId');
			arr.push('thumbParamsOutput');
			arr.push('thumbAssetId');
			arr.push('srcAssetType');
			arr.push('thumbPath');
			return arr;
		}
	}
}
