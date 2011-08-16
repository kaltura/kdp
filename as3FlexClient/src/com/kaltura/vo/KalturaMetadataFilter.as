package com.kaltura.vo
{
	import com.kaltura.vo.KalturaMetadataBaseFilter;

	[Bindable]
	public dynamic class KalturaMetadataFilter extends KalturaMetadataBaseFilter
	{
		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			return arr;
		}
	}
}
