package com.kaltura.vo
{
	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaMediaInfo extends BaseFlexVo
	{
		public var id : int = int.MIN_VALUE;

		public var flavorAssetId : String;

		public var fileSize : int = int.MIN_VALUE;

		public var containerFormat : String;

		public var containerId : String;

		public var containerProfile : String;

		public var containerDuration : int = int.MIN_VALUE;

		public var containerBitRate : int = int.MIN_VALUE;

		public var videoFormat : String;

		public var videoCodecId : String;

		public var videoDuration : int = int.MIN_VALUE;

		public var videoBitRate : int = int.MIN_VALUE;

		public var videoBitRateMode : int = int.MIN_VALUE;

		public var videoWidth : int = int.MIN_VALUE;

		public var videoHeight : int = int.MIN_VALUE;

		public var videoFrameRate : Number = NaN;

		public var videoDar : Number = NaN;

		public var videoRotation : int = int.MIN_VALUE;

		public var audioFormat : String;

		public var audioCodecId : String;

		public var audioDuration : int = int.MIN_VALUE;

		public var audioBitRate : int = int.MIN_VALUE;

		public var audioBitRateMode : int = int.MIN_VALUE;

		public var audioChannels : int = int.MIN_VALUE;

		public var audioSamplingRate : int = int.MIN_VALUE;

		public var audioResolution : int = int.MIN_VALUE;

		public var writingLib : String;

		public var rawData : String;

		public var multiStreamInfo : String;

		public var scanType : int = int.MIN_VALUE;

		public var multiStream : String;

		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('flavorAssetId');
			arr.push('fileSize');
			arr.push('containerFormat');
			arr.push('containerId');
			arr.push('containerProfile');
			arr.push('containerDuration');
			arr.push('containerBitRate');
			arr.push('videoFormat');
			arr.push('videoCodecId');
			arr.push('videoDuration');
			arr.push('videoBitRate');
			arr.push('videoBitRateMode');
			arr.push('videoWidth');
			arr.push('videoHeight');
			arr.push('videoFrameRate');
			arr.push('videoDar');
			arr.push('videoRotation');
			arr.push('audioFormat');
			arr.push('audioCodecId');
			arr.push('audioDuration');
			arr.push('audioBitRate');
			arr.push('audioBitRateMode');
			arr.push('audioChannels');
			arr.push('audioSamplingRate');
			arr.push('audioResolution');
			arr.push('writingLib');
			arr.push('rawData');
			arr.push('multiStreamInfo');
			arr.push('scanType');
			arr.push('multiStream');
			return arr;
		}
	}
}
