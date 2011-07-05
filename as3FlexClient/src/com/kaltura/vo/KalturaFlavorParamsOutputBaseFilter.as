package com.kaltura.vo
{
	import com.kaltura.vo.KalturaFlavorParamsFilter;

	[Bindable]
	public dynamic class KalturaFlavorParamsOutputBaseFilter extends KalturaFlavorParamsFilter
	{
		public var flavorParamsIdEqual : int = int.MIN_VALUE;

		public var flavorParamsVersionEqual : String;

		public var flavorAssetIdEqual : String;

		public var flavorAssetVersionEqual : String;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('flavorParamsIdEqual');
			arr.push('flavorParamsVersionEqual');
			arr.push('flavorAssetIdEqual');
			arr.push('flavorAssetVersionEqual');
			return arr;
		}
	}
}
