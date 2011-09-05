package com.kaltura.vo
{
	import com.kaltura.vo.KalturaBaseSyndicationFeed;

	[Bindable]
	public dynamic class KalturaITunesSyndicationFeed extends KalturaBaseSyndicationFeed
	{
		/** 
		* feed description
		* */ 
		public var feedDescription : String = null;

		/** 
		* feed language
		* */ 
		public var language : String = null;

		/** 
		* feed landing page (i.e publisher website)
		* */ 
		public var feedLandingPage : String = null;

		/** 
		* author/publisher name
		* */ 
		public var ownerName : String = null;

		/** 
		* publisher email
		* */ 
		public var ownerEmail : String = null;

		/** 
		* podcast thumbnail
		* */ 
		public var feedImageUrl : String = null;

		/** 
		* 		* */ 
		public var category : String = null;

		/** 
		* 		* */ 
		public var adultContent : String = null;

		/** 
		* 		* */ 
		public var feedAuthor : String = null;

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
