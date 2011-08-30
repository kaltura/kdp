package com.kaltura.vo
{
	import com.kaltura.vo.KalturaBaseSyndicationFeed;

	[Bindable]
	public dynamic class KalturaYahooSyndicationFeed extends KalturaBaseSyndicationFeed
	{
		/** 
		* 		* */ 
		public var category : String = null;

		/** 
		* 		* */ 
		public var adultContent : String = null;

		/** 
		* feed description
		* */ 
		public var feedDescription : String = null;

		/** 
		* feed landing page (i.e publisher website)
		* */ 
		public var feedLandingPage : String = null;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('adultContent');
			arr.push('feedDescription');
			arr.push('feedLandingPage');
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
