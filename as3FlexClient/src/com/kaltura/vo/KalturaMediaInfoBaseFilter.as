package com.kaltura.vo
{
	import com.kaltura.vo.KalturaFilter;

	[Bindable]
	public dynamic class KalturaMediaInfoBaseFilter extends KalturaFilter
	{
		public var flavorAssetIdEqual : String;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('flavorAssetIdEqual');
			return arr;
		}
	}
}
