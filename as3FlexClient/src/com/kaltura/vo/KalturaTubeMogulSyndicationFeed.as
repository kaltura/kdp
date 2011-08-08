package com.kaltura.vo
{
	import com.kaltura.vo.KalturaBaseSyndicationFeed;

	[Bindable]
	public dynamic class KalturaTubeMogulSyndicationFeed extends KalturaBaseSyndicationFeed
	{
		public var category : String;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			return arr;
		}
	}
}
