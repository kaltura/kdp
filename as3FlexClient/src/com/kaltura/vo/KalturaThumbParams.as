package com.kaltura.vo
{
	import com.kaltura.vo.KalturaAssetParams;

	[Bindable]
	public dynamic class KalturaThumbParams extends KalturaAssetParams
	{
		public var cropType : int = int.MIN_VALUE;

		public var quality : int = int.MIN_VALUE;

		public var cropX : int = int.MIN_VALUE;

		public var cropY : int = int.MIN_VALUE;

		public var cropWidth : int = int.MIN_VALUE;

		public var cropHeight : int = int.MIN_VALUE;

		public var videoOffset : int = int.MIN_VALUE;

		public var width : int = int.MIN_VALUE;

		public var height : int = int.MIN_VALUE;

		public var scaleWidth : Number = NaN;

		public var scaleHeight : Number = NaN;

		public var backgroundColor : String;

		public var sourceParamsId : int = int.MIN_VALUE;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('cropType');
			arr.push('quality');
			arr.push('cropX');
			arr.push('cropY');
			arr.push('cropWidth');
			arr.push('cropHeight');
			arr.push('videoOffset');
			arr.push('width');
			arr.push('height');
			arr.push('scaleWidth');
			arr.push('scaleHeight');
			arr.push('backgroundColor');
			arr.push('sourceParamsId');
			return arr;
		}
	}
}
