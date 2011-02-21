package com.kaltura.vo
{
	import com.kaltura.vo.KalturaControlPanelCommandBaseFilter;

	[Bindable]
	public dynamic class KalturaControlPanelCommandFilter extends KalturaControlPanelCommandBaseFilter
	{
		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			return arr;
		}
	}
}
