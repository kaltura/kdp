package com.kaltura.vo
{
	import com.kaltura.vo.KalturaBatchJob;

	[Bindable]
	public dynamic class KalturaFileSyncImportBatchJob extends KalturaBatchJob
	{
override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			return arr;
		}
	}
}
