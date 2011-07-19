package com.kaltura.vo
{
	import com.kaltura.vo.KalturaGenericSyndicationFeedFilter;

	[Bindable]
	public dynamic class KalturaGenericXsltSyndicationFeedBaseFilter extends KalturaGenericSyndicationFeedFilter
	{
		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			return arr;
		}
	}
}
