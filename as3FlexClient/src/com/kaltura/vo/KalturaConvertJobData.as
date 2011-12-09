package com.kaltura.vo
{
	import com.kaltura.vo.KalturaConvartableJobData;

	[Bindable]
	public dynamic class KalturaConvertJobData extends KalturaConvartableJobData
	{
		public var destFileSyncLocalPath : String;

		public var destFileSyncRemoteUrl : String;

		public var logFileSyncLocalPath : String;

		public var flavorAssetId : String;

		public var remoteMediaId : String;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('destFileSyncLocalPath');
			arr.push('destFileSyncRemoteUrl');
			arr.push('logFileSyncLocalPath');
			arr.push('flavorAssetId');
			arr.push('remoteMediaId');
			return arr;
		}
	}
}
