package com.kaltura.vo
{
	import com.kaltura.vo.KalturaBaseSyndicationFeed;

	[Bindable]
	public dynamic class KalturaITunesSyndicationFeed extends KalturaBaseSyndicationFeed
	{
		public var feedDescription : String;
		public var language : String;
		public var feedLandingPage : String;
		public var ownerName : String;
		public var ownerEmail : String;
		public var feedImageUrl : String;
		public var category : String;
		public var adultContent : String;
		public var feedAuthor : String;
		override protected function setupPropertyList():void
		{
			super.setupPropertyList();
			propertyList.push('feedDescription');
			propertyList.push('language');
			propertyList.push('feedLandingPage');
			propertyList.push('ownerName');
			propertyList.push('ownerEmail');
			propertyList.push('feedImageUrl');
			propertyList.push('category');
			propertyList.push('adultContent');
			propertyList.push('feedAuthor');
		}
		override public function getParamKeys():Array
		{
			var arr : Array;
			arr = super.getParamKeys();
			arr.push('feedDescription');
			arr.push('language');
			arr.push('feedLandingPage');
			arr.push('ownerName');
			arr.push('ownerEmail');
			arr.push('feedImageUrl');
			arr.push('category');
			arr.push('adultContent');
			arr.push('feedAuthor');
			return arr;
		}

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('feedDescription');
			arr.push('language');
			arr.push('feedLandingPage');
			arr.push('ownerName');
			arr.push('ownerEmail');
			arr.push('feedImageUrl');
			arr.push('adultContent');
			arr.push('feedAuthor');
			return arr;
		}

	}
}
