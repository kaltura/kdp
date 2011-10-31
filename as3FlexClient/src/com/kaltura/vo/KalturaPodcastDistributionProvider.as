package com.kaltura.vo
{
	import com.kaltura.vo.KalturaDistributionProvider;

	[Bindable]
	public dynamic class KalturaPodcastDistributionProvider extends KalturaDistributionProvider
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
