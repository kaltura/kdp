package com.kaltura.vo
{
	import com.kaltura.vo.KalturaTubeMogulSyndicationFeedBaseFilter;

	[Bindable]
	public dynamic class KalturaTubeMogulSyndicationFeedFilter extends KalturaTubeMogulSyndicationFeedBaseFilter
	{
		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			return arr;
		}
	}
}
