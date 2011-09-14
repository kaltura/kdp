package com.kaltura.vo
{
	import com.kaltura.vo.KalturaGenericSyndicationFeed;

	[Bindable]
	public dynamic class KalturaGenericXsltSyndicationFeed extends KalturaGenericSyndicationFeed
	{
		public var xslt : String;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('xslt');
			return arr;
		}
	}
}
