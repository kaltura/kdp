package com.kaltura.vo
{
	import com.kaltura.vo.KalturaBaseSyndicationFeed;

	[Bindable]
	public dynamic class KalturaGoogleVideoSyndicationFeed extends KalturaBaseSyndicationFeed
	{
		public var adultContent : String;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('adultContent');
			return arr;
		}
	}
}
