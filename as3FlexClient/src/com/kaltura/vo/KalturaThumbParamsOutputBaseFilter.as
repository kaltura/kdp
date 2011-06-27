package com.kaltura.vo
{
	import com.kaltura.vo.KalturaThumbParamsFilter;

	[Bindable]
	public dynamic class KalturaThumbParamsOutputBaseFilter extends KalturaThumbParamsFilter
	{
		public var thumbParamsIdEqual : int = int.MIN_VALUE;

		public var thumbParamsVersionEqual : String;

		public var thumbAssetIdEqual : String;

		public var thumbAssetVersionEqual : String;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('thumbParamsIdEqual');
			arr.push('thumbParamsVersionEqual');
			arr.push('thumbAssetIdEqual');
			arr.push('thumbAssetVersionEqual');
			return arr;
		}
	}
}
