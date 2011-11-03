package com.kaltura.vo
{
	import com.kaltura.vo.KalturaAssetParamsFilter;

	import com.kaltura.vo.KalturaConversionProfileFilter;

	import com.kaltura.vo.KalturaConversionProfileAssetParamsBaseFilter;

	[Bindable]
	public dynamic class KalturaConversionProfileAssetParamsFilter extends KalturaConversionProfileAssetParamsBaseFilter
	{
		/** 
		* 		* */ 
		public var conversionProfileIdFilter : KalturaConversionProfileFilter;

		/** 
		* 		* */ 
		public var assetParamsIdFilter : KalturaAssetParamsFilter;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('conversionProfileIdFilter');
			arr.push('assetParamsIdFilter');
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
