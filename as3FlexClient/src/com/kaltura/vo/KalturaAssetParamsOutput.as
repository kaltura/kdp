package com.kaltura.vo
{
	import com.kaltura.vo.KalturaAssetParams;

	[Bindable]
	public dynamic class KalturaAssetParamsOutput extends KalturaAssetParams
	{
		public var assetParamsId : int = int.MIN_VALUE;

		public var assetParamsVersion : String;

		public var assetId : String;

		public var assetVersion : String;

		public var readyBehavior : int = int.MIN_VALUE;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('assetParamsId');
			arr.push('assetParamsVersion');
			arr.push('assetId');
			arr.push('assetVersion');
			arr.push('readyBehavior');
			return arr;
		}
	}
}
