package com.kaltura.vo
{
	import com.kaltura.vo.KalturaBaseSyndicationFeedFilter;

	[Bindable]
	public dynamic class KalturaYahooSyndicationFeedBaseFilter extends KalturaBaseSyndicationFeedFilter
	{
		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			return arr;
		}
	}
}
