package com.kaltura.vo
{
	import com.kaltura.vo.KalturaYouTubeDistributionProviderBaseFilter;

	[Bindable]
	public dynamic class KalturaYouTubeDistributionProviderFilter extends KalturaYouTubeDistributionProviderBaseFilter
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
