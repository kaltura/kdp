// ===================================================================================================
//                           _  __     _ _
//                          | |/ /__ _| | |_ _  _ _ _ __ _
//                          | ' </ _` | |  _| || | '_/ _` |
//                          |_|\_\__,_|_|\__|\_,_|_| \__,_|
//
// This file is part of the Kaltura Collaborative Media Suite which allows users
// to do with audio, video, and animation what Wiki platfroms allow them to do with
// text.
//
// Copyright (C) 2006-2011  Kaltura Inc.
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as
// published by the Free Software Foundation, either version 3 of the
// License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.
//
// @ignore
// ===================================================================================================
package com.kaltura.vo
{
	import com.kaltura.vo.KalturaAssetParams;

	[Bindable]
	public dynamic class KalturaFlavorParams extends KalturaAssetParams
	{
		/**
		* The video codec of the Flavor Params
		* 
		* @see com.kaltura.types.KalturaVideoCodec
		**/
		public var videoCodec : String = null;

		/**
		* The video bitrate (in KBits) of the Flavor Params
		* 
		**/
		public var videoBitrate : int = int.MIN_VALUE;

		/**
		* The audio codec of the Flavor Params
		* 
		* @see com.kaltura.types.KalturaAudioCodec
		**/
		public var audioCodec : String = null;

		/**
		* The audio bitrate (in KBits) of the Flavor Params
		* 
		**/
		public var audioBitrate : int = int.MIN_VALUE;

		/**
		* The number of audio channels for "downmixing"
		* 
		**/
		public var audioChannels : int = int.MIN_VALUE;

		/**
		* The audio sample rate of the Flavor Params
		* 
		**/
		public var audioSampleRate : int = int.MIN_VALUE;

		/**
		* The desired width of the Flavor Params
		* 
		**/
		public var width : int = int.MIN_VALUE;

		/**
		* The desired height of the Flavor Params
		* 
		**/
		public var height : int = int.MIN_VALUE;

		/**
		* The frame rate of the Flavor Params
		* 
		**/
		public var frameRate : int = int.MIN_VALUE;

		/**
		* The gop size of the Flavor Params
		* 
		**/
		public var gopSize : int = int.MIN_VALUE;

		/**
		* The list of conversion engines (comma separated)
		* 
		**/
		public var conversionEngines : String = null;

		/**
		* The list of conversion engines extra params (separated with "|")
		* 
		**/
		public var conversionEnginesExtraParams : String = null;

		/**
		* @see com.kaltura.types.kalturaBoolean
		**/
		public var twoPass : Boolean;

		/**
		**/
		public var deinterlice : int = int.MIN_VALUE;

		/**
		**/
		public var rotate : int = int.MIN_VALUE;

		/**
		**/
		public var operators : String = null;

		/**
		**/
		public var engineVersion : int = int.MIN_VALUE;

		/**
		* The container format of the Flavor Params
		* 
		* @see com.kaltura.types.KalturaContainerFormat
		**/
		public var format : String = null;

		/**
		**/
		public var aspectRatioProcessingMode : int = int.MIN_VALUE;

		/**
		**/
		public var forceFrameToMultiplication16 : int = int.MIN_VALUE;

		/**
		**/
		public var isGopInSec : int = int.MIN_VALUE;

		/**
		**/
		public var isAvoidVideoShrinkFramesizeToSource : int = int.MIN_VALUE;

		/**
		**/
		public var isAvoidVideoShrinkBitrateToSource : int = int.MIN_VALUE;

		/**
		**/
		public var isVideoFrameRateForLowBrAppleHls : int = int.MIN_VALUE;

		/**
		**/
		public var anamorphicPixels : Number = Number.NEGATIVE_INFINITY;

		/**
		**/
		public var isAvoidForcedKeyFrames : int = int.MIN_VALUE;

		/**
		**/
		public var maxFrameRate : int = int.MIN_VALUE;

		/**
		**/
		public var videoConstantBitrate : int = int.MIN_VALUE;

		/**
		**/
		public var videoBitrateTolerance : int = int.MIN_VALUE;

		/**
		**/
		public var clipOffset : int = int.MIN_VALUE;

		/**
		**/
		public var clipDuration : int = int.MIN_VALUE;

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
			arr.push('aspectRatioProcessingMode');
			arr.push('forceFrameToMultiplication16');
			arr.push('isGopInSec');
			arr.push('isAvoidVideoShrinkFramesizeToSource');
			arr.push('isAvoidVideoShrinkBitrateToSource');
			arr.push('isVideoFrameRateForLowBrAppleHls');
			arr.push('anamorphicPixels');
			arr.push('isAvoidForcedKeyFrames');
			arr.push('maxFrameRate');
			arr.push('videoConstantBitrate');
			arr.push('videoBitrateTolerance');
			arr.push('clipOffset');
			arr.push('clipDuration');
			return arr;
		}

		override public function getInsertableParamKeys():Array
		{
			var arr : Array;
			arr = super.getInsertableParamKeys();
			return arr;
		}

		override public function getElementType(arrayName:String):String
		{
			var result:String = '';
			switch (arrayName) {
				default:
					result = super.getElementType(arrayName);
					break;
			}
			return result;
		}
	}
}
