package com.kaltura.vo
{
	import com.kaltura.vo.KalturaThumbParams;

	[Bindable]
	public dynamic class KalturaThumbParamsOutput extends KalturaThumbParams
	{
		public var thumbParamsId : int = int.MIN_VALUE;

		public var thumbParamsVersion : String;

		public var thumbAssetId : String;

		public var thumbAssetVersion : String;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('thumbParamsId');
			arr.push('thumbParamsVersion');
			arr.push('thumbAssetId');
			arr.push('thumbAssetVersion');
			return arr;
		}
	}
}
