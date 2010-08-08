package com.kaltura.vo
{
	import com.kaltura.vo.KalturaBaseSyndicationFeed;

	[Bindable]
	public dynamic class KalturaYahooSyndicationFeed extends KalturaBaseSyndicationFeed
	{
		public var category : String;
		public var adultContent : String;
		public var feedDescription : String;
		public var feedLandingPage : String;
		override protected function setupPropertyList():void
		{
			super.setupPropertyList();
			propertyList.push('category');
			propertyList.push('adultContent');
			propertyList.push('feedDescription');
			propertyList.push('feedLandingPage');
		}
		override public function getParamKeys():Array
		{
			var arr : Array;
			arr = super.getParamKeys();
			arr.push('category');
			arr.push('adultContent');
			arr.push('feedDescription');
			arr.push('feedLandingPage');
			return arr;
		}

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('adultContent');
			arr.push('feedDescription');
			arr.push('feedLandingPage');
			return arr;
		}

	}
}
