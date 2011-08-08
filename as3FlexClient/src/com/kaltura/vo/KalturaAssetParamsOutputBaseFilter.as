package com.kaltura.vo
{
	import com.kaltura.vo.KalturaAssetParamsFilter;

	[Bindable]
	public dynamic class KalturaAssetParamsOutputBaseFilter extends KalturaAssetParamsFilter
	{
		public var assetParamsIdEqual : int = int.MIN_VALUE;

		public var assetParamsVersionEqual : String;

		public var assetIdEqual : String;

		public var assetVersionEqual : String;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('assetParamsIdEqual');
			arr.push('assetParamsVersionEqual');
			arr.push('assetIdEqual');
			arr.push('assetVersionEqual');
			return arr;
		}
	}
}
