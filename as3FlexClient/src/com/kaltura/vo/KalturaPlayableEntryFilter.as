package com.kaltura.vo
{
	import com.kaltura.vo.KalturaPlayableEntryBaseFilter;

	[Bindable]
	public dynamic class KalturaPlayableEntryFilter extends KalturaPlayableEntryBaseFilter
	{
		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			return arr;
		}
	}
}
