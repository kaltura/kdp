package com.kaltura.vo
{
	import com.kaltura.vo.KalturaStorageJobData;

	[Bindable]
	public dynamic class KalturaStorageExportJobData extends KalturaStorageJobData
	{
		public var destFileSyncStoredPath : String;

		public var force : Boolean;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('destFileSyncStoredPath');
			arr.push('force');
			return arr;
		}
	}
}
