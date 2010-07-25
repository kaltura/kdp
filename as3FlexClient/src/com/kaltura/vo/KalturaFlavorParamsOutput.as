package com.kaltura.vo
{
	import com.kaltura.vo.KalturaFlavorParams;

	[Bindable]
	public dynamic class KalturaFlavorParamsOutput extends KalturaFlavorParams
	{
		public var flavorParamsId : int = int.MIN_VALUE;
		public var commandLinesStr : String;
		public var flavorParamsVersion : String;
		public var flavorAssetId : String;
		public var flavorAssetVersion : String;
		public var readyBehavior : int = int.MIN_VALUE;
		override protected function setupPropertyList():void
		{
			super.setupPropertyList();
			propertyList.push('flavorParamsId');
			propertyList.push('commandLinesStr');
			propertyList.push('flavorParamsVersion');
			propertyList.push('flavorAssetId');
			propertyList.push('flavorAssetVersion');
			propertyList.push('readyBehavior');
		}
		override public function getParamKeys():Array
		{
			var arr : Array;
			arr = super.getParamKeys();
			arr.push('flavorParamsId');
			arr.push('commandLinesStr');
			arr.push('flavorParamsVersion');
			arr.push('flavorAssetId');
			arr.push('flavorAssetVersion');
			arr.push('readyBehavior');
			return arr;
		}

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('flavorParamsId');
			arr.push('commandLinesStr');
			arr.push('flavorParamsVersion');
			arr.push('flavorAssetId');
			arr.push('flavorAssetVersion');
			arr.push('readyBehavior');
			return arr;
		}

	}
}
