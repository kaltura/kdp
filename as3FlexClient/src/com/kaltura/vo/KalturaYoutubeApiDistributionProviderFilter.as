package com.kaltura.vo
{
	import com.kaltura.vo.KalturaYoutubeApiDistributionProviderBaseFilter;

	[Bindable]
	public dynamic class KalturaYoutubeApiDistributionProviderFilter extends KalturaYoutubeApiDistributionProviderBaseFilter
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
