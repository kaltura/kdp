package com.kaltura.vo
{
	import com.kaltura.vo.KalturaGoogleVideoSyndicationFeedBaseFilter;

	[Bindable]
	public dynamic class KalturaGoogleVideoSyndicationFeedFilter extends KalturaGoogleVideoSyndicationFeedBaseFilter
	{
		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			return arr;
		}
	}
}
