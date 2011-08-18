package com.kaltura.vo
{
	import com.kaltura.vo.KalturaYoutubeApiDistributionProfileBaseFilter;

	[Bindable]
	public dynamic class KalturaYoutubeApiDistributionProfileFilter extends KalturaYoutubeApiDistributionProfileBaseFilter
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
