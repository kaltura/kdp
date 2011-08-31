package com.kaltura.vo
{
	import com.kaltura.vo.KalturaPodcastDistributionProviderBaseFilter;

	[Bindable]
	public dynamic class KalturaPodcastDistributionProviderFilter extends KalturaPodcastDistributionProviderBaseFilter
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
