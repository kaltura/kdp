package com.kaltura.vo
{
	import com.kaltura.vo.KalturaPodcastDistributionProfileBaseFilter;

	[Bindable]
	public dynamic class KalturaPodcastDistributionProfileFilter extends KalturaPodcastDistributionProfileBaseFilter
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
