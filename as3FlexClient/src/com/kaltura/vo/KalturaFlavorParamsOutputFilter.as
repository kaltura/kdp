package com.kaltura.vo
{
	import com.kaltura.vo.KalturaFlavorParamsFilter;

	[Bindable]
	public dynamic class KalturaFlavorParamsOutputFilter extends KalturaFlavorParamsFilter
	{
		public var flavorParamsIdEqual : int = int.MIN_VALUE;
		public var flavorParamsVersionEqual : String;
		public var flavorAssetIdEqual : String;
		public var flavorAssetVersionEqual : String;
		override protected function setupPropertyList():void
		{
			super.setupPropertyList();
			propertyList.push('flavorParamsIdEqual');
			propertyList.push('flavorParamsVersionEqual');
			propertyList.push('flavorAssetIdEqual');
			propertyList.push('flavorAssetVersionEqual');
		}
		override public function getParamKeys():Array
		{
			var arr : Array;
			arr = super.getParamKeys();
			arr.push('flavorParamsIdEqual');
			arr.push('flavorParamsVersionEqual');
			arr.push('flavorAssetIdEqual');
			arr.push('flavorAssetVersionEqual');
			return arr;
		}

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
