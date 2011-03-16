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
