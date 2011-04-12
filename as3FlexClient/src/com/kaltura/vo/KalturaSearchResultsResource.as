package com.kaltura.vo
{
	import com.kaltura.vo.KalturaSearchResult;

	import com.kaltura.vo.KalturaContentResource;

	[Bindable]
	public dynamic class KalturaSearchResultsResource extends KalturaContentResource
	{
		public var result : KalturaSearchResult;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('result');
			return arr;
		}
	}
}
