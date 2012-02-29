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
		* 		* */ 
		public var videoCodec : String = null;

		/** 
		* 		* */ 
		public var videoBitrate : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var audioCodec : String = null;

		/** 
		* 		* */ 
		public var audioBitrate : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var audioChannels : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var audioSampleRate : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var width : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var height : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var frameRate : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var gopSize : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var conversionEngines : String = null;

		/** 
		* 		* */ 
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
		* 		* */ 
		public var format : String = null;

		/** 
		* 		* */ 
		public var aspectRatioProcessingMode : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var forceFrameToMultiplication16 : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var videoConstantBitrate : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var videoBitrateTolerance : int = int.MIN_VALUE;

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
			arr.push('videoConstantBitrate');
			arr.push('videoBitrateTolerance');
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
