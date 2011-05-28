package com.kaltura.vo
{
	import com.kaltura.vo.KalturaYahooSyndicationFeedBaseFilter;

	[Bindable]
	public dynamic class KalturaYahooSyndicationFeedFilter extends KalturaYahooSyndicationFeedBaseFilter
	{
		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			return arr;
		}
	}
}
