package com.kaltura.vo
{
	import com.kaltura.vo.KalturaGenericSyndicationFeedBaseFilter;

	[Bindable]
	public dynamic class KalturaGenericSyndicationFeedFilter extends KalturaGenericSyndicationFeedBaseFilter
	{
		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			return arr;
		}
	}
}
