package com.kaltura.vo
{
	import com.kaltura.vo.KalturaAssetParams;

	[Bindable]
	public dynamic class KalturaFlavorParams extends KalturaAssetParams
	{
		/** 
		* The video codec of the Flavor Params
		* */ 
		public var videoCodec : String = null;

		/** 
		* The video bitrate (in KBits) of the Flavor Params
		* */ 
		public var videoBitrate : int = int.MIN_VALUE;

		/** 
		* The audio codec of the Flavor Params
		* */ 
		public var audioCodec : String = null;

		/** 
		* The audio bitrate (in KBits) of the Flavor Params
		* */ 
		public var audioBitrate : int = int.MIN_VALUE;

		/** 
		* The number of audio channels for "downmixing"
		* */ 
		public var audioChannels : int = int.MIN_VALUE;

		/** 
		* The audio sample rate of the Flavor Params
		* */ 
		public var audioSampleRate : int = int.MIN_VALUE;

		/** 
		* The desired width of the Flavor Params
		* */ 
		public var width : int = int.MIN_VALUE;

		/** 
		* The desired height of the Flavor Params
		* */ 
		public var height : int = int.MIN_VALUE;

		/** 
		* The frame rate of the Flavor Params
		* */ 
		public var frameRate : int = int.MIN_VALUE;

		/** 
		* The gop size of the Flavor Params
		* */ 
		public var gopSize : int = int.MIN_VALUE;

		/** 
		* The list of conversion engines (comma separated)
		* */ 
		public var conversionEngines : String = null;

		/** 
		* The list of conversion engines extra params (separated with "|")
		* */ 
		public var conversionEnginesExtraParams : String = null;

		/** 
		* 		* */ 
		public var twoPass : Boolean;

		/** 
		* 		* */ 
		public var deinterlice : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var rotate : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var operators : String = null;

		/** 
		* 		* */ 
		public var engineVersion : int = int.MIN_VALUE;

		/** 
		* The container format of the Flavor Params
		* */ 
		public var format : String = null;

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
			arr.push('format');
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
