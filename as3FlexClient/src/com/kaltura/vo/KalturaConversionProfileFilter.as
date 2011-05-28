package com.kaltura.vo
{
	import com.kaltura.vo.KalturaConversionProfileBaseFilter;

	[Bindable]
	public dynamic class KalturaConversionProfileFilter extends KalturaConversionProfileBaseFilter
	{
		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			return arr;
		}
	}
}
