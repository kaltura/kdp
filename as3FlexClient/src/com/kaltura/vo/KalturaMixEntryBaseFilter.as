package com.kaltura.vo
{
	import com.kaltura.vo.KalturaPlayableEntryFilter;

	[Bindable]
	public dynamic class KalturaMixEntryBaseFilter extends KalturaPlayableEntryFilter
	{
		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			return arr;
		}
	}
}
