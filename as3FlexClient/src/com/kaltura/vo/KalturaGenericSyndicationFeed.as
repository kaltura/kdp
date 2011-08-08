package com.kaltura.vo
{
	import com.kaltura.vo.KalturaBaseSyndicationFeed;

	[Bindable]
	public dynamic class KalturaGenericSyndicationFeed extends KalturaBaseSyndicationFeed
	{
		public var feedDescription : String;

		public var feedLandingPage : String;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('feedDescription');
			arr.push('feedLandingPage');
			return arr;
		}
	}
}
