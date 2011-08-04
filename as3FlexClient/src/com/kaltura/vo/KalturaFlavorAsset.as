package com.kaltura.vo
{
	import com.kaltura.vo.KalturaAsset;

	[Bindable]
	public dynamic class KalturaFlavorAsset extends KalturaAsset
	{
		/** 
		* The Flavor Params used to create this Flavor Asset
		* */ 
		public var flavorParamsId : int = int.MIN_VALUE;

		/** 
		* The width of the Flavor Asset 
		* */ 
		public var width : int = int.MIN_VALUE;

		/** 
		* The height of the Flavor Asset
		* */ 
		public var height : int = int.MIN_VALUE;

		/** 
		* The overall bitrate (in KBits) of the Flavor Asset 
		* */ 
		public var bitrate : int = int.MIN_VALUE;

		/** 
		* The frame rate (in FPS) of the Flavor Asset
		* */ 
		public var frameRate : int = int.MIN_VALUE;

		/** 
		* True if this Flavor Asset is the original source
		* */ 
		public var isOriginal : Boolean;

		/** 
		* True if this Flavor Asset is playable in KDP
		* */ 
		public var isWeb : Boolean;

		/** 
		* The container format
		* */ 
		public var containerFormat : String;

		/** 
		* The video codec
		* */ 
		public var videoCodecId : String;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			return arr;
		}

		override public function getInsertableParamKeys():Array
		{
			var arr : Array;
			arr = super.getInsertableParamKeys();
			arr.push('flavorParamsId');
			return arr;
		}

	}
}
