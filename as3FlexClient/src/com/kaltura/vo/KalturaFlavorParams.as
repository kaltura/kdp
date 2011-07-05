package com.kaltura.vo
{
	import com.kaltura.vo.KalturaAssetParams;

	[Bindable]
	public dynamic class KalturaFlavorParams extends KalturaAssetParams
	{
		public var videoCodec : String;

		public var videoBitrate : int = int.MIN_VALUE;

		public var audioCodec : String;

		public var audioBitrate : int = int.MIN_VALUE;

		public var audioChannels : int = int.MIN_VALUE;

		public var audioSampleRate : int = int.MIN_VALUE;

		public var width : int = int.MIN_VALUE;

		public var height : int = int.MIN_VALUE;

		public var frameRate : int = int.MIN_VALUE;

		public var gopSize : int = int.MIN_VALUE;

		public var conversionEngines : String;

		public var conversionEnginesExtraParams : String;

		public var twoPass : Boolean;

		public var deinterlice : int = int.MIN_VALUE;

		public var rotate : int = int.MIN_VALUE;

		public var operators : String;

		public var engineVersion : int = int.MIN_VALUE;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('videoCodec');
			arr.push('videoBitrate');
			arr.push('audioCodec');
			arr.push('audioBitrate');
			arr.push('audioChannels');
			arr.push('audioSampleRate');
			arr.push('width');
			arr.push('height');
			arr.push('frameRate');
			arr.push('gopSize');
			arr.push('conversionEngines');
			arr.push('conversionEnginesExtraParams');
			arr.push('twoPass');
			arr.push('deinterlice');
			arr.push('rotate');
			arr.push('operators');
			arr.push('engineVersion');
			return arr;
		}
	}
}
