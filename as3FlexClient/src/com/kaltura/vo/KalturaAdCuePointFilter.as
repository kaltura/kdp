package com.kaltura.vo
{
	import com.kaltura.vo.KalturaAdCuePointBaseFilter;

	[Bindable]
	public dynamic class KalturaAdCuePointFilter extends KalturaAdCuePointBaseFilter
	{
		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			return arr;
		}

		override public function getInsertableParamKeys():Array
		{
			var arr : Array;
			arr = super.getInsertableParamKeys();
			return arr;
		}

	}
}
