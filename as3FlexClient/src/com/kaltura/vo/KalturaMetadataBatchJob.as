package com.kaltura.vo
{
	import com.kaltura.vo.KalturaBatchJob;

	[Bindable]
	public dynamic class KalturaMetadataBatchJob extends KalturaBatchJob
	{
		override protected function setupPropertyList():void
		{
			super.setupPropertyList();
		}
		override public function getParamKeys():Array
		{
			var arr : Array;
			arr = super.getParamKeys();
			return arr;
		}

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			return arr;
		}

	}
}
