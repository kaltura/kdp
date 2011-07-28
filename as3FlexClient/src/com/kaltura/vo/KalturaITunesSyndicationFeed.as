package com.kaltura.vo
{
	import com.kaltura.vo.KalturaBaseSyndicationFeed;

	[Bindable]
	public dynamic class KalturaITunesSyndicationFeed extends KalturaBaseSyndicationFeed
	{
		/** 
		* feed description
		* */ 
		public var feedDescription : String;

		/** 
		* feed language
		* */ 
		public var language : String;

		/** 
		* feed landing page (i.e publisher website)
		* */ 
		public var feedLandingPage : String;

		/** 
		* author/publisher name
		* */ 
		public var ownerName : String;

		/** 
		* publisher email
		* */ 
		public var ownerEmail : String;

		/** 
		* podcast thumbnail
		* */ 
		public var feedImageUrl : String;

		/** 
		* 		* */ 
		public var category : String;

		/** 
		* 		* */ 
		public var adultContent : String;

		/** 
		* 		* */ 
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

		override public function getInsertableParamKeys():Array
		{
			var arr : Array;
			arr = super.getInsertableParamKeys();
			return arr;
		}

	}
}
