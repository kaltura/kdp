package com.kaltura.vo
{
	import com.kaltura.vo.KalturaFlavorParams;

	import com.kaltura.vo.KalturaFlavorAsset;

	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaFlavorAssetWithParams extends BaseFlexVo
	{
		public var flavorAsset : KalturaFlavorAsset;
		public var flavorParams : KalturaFlavorParams;
		public var entryId : String;
		override protected function setupPropertyList():void
		{
			super.setupPropertyList();
			propertyList.push('flavorAsset');
			propertyList.push('flavorParams');
			propertyList.push('entryId');
		}
		public function getParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('flavorAsset');
			arr.push('flavorParams');
			arr.push('entryId');
			return arr;
		}

		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('flavorAsset');
			arr.push('flavorParams');
			arr.push('entryId');
			return arr;
		}

	}
}
