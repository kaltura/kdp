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

		override public function getInsertableParamKeys():Array
		{
			var arr : Array;
			arr = super.getInsertableParamKeys();
			return arr;
		}

	}
}
