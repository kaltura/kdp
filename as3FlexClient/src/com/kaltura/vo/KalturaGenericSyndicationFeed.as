package com.kaltura.vo
{
	import com.kaltura.vo.KalturaBaseSyndicationFeed;

	[Bindable]
	public dynamic class KalturaGenericSyndicationFeed extends KalturaBaseSyndicationFeed
	{
		/** 
		* feed description
		* */ 
		public var feedDescription : String;

		/** 
		* feed landing page (i.e publisher website)
		* */ 
		public var feedLandingPage : String;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
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
