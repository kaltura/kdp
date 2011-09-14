package com.kaltura.vo
{
	import com.kaltura.vo.KalturaBatchJobBaseFilter;

	[Bindable]
	public dynamic class KalturaBatchJobFilter extends KalturaBatchJobBaseFilter
	{
		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			return arr;
		}
	}
}
