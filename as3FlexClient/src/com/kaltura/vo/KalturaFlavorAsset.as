package com.kaltura.vo
{
	import com.kaltura.vo.KalturaAsset;

	[Bindable]
	public dynamic class KalturaFlavorAsset extends KalturaAsset
	{
		public var flavorParamsId : int = int.MIN_VALUE;

		public var width : int = int.MIN_VALUE;

		public var height : int = int.MIN_VALUE;

		public var bitrate : int = int.MIN_VALUE;

		public var frameRate : int = int.MIN_VALUE;

		public var isOriginal : Boolean;

		public var isWeb : Boolean;

		public var containerFormat : String;

		public var videoCodecId : String;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('isOriginal');
			arr.push('isWeb');
			arr.push('containerFormat');
			arr.push('videoCodecId');
			return arr;
		}
	}
}
