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
	import com.kaltura.vo.BaseFlexVo;

	[Bindable]
	public dynamic class KalturaMediaInfo extends BaseFlexVo
	{
		/**
		 * The id of the media info
		 * 
		 **/
		public var id : int = int.MIN_VALUE;

		/**
		 * The id of the related flavor asset
		 * 
		 **/
		public var flavorAssetId : String = null;

		/**
		 * The file size
		 * 
		 **/
		public var fileSize : int = int.MIN_VALUE;

		/**
		 * The container format
		 * 
		 **/
		public var containerFormat : String = null;

		/**
		 * The container id
		 * 
		 **/
		public var containerId : String = null;

		/**
		 * The container profile
		 * 
		 **/
		public var containerProfile : String = null;

		/**
		 * The container duration
		 * 
		 **/
		public var containerDuration : int = int.MIN_VALUE;

		/**
		 * The container bit rate
		 * 
		 **/
		public var containerBitRate : int = int.MIN_VALUE;

		/**
		 * The video format
		 * 
		 **/
		public var videoFormat : String = null;

		/**
		 * The video codec id
		 * 
		 **/
		public var videoCodecId : String = null;

		/**
		 * The video duration
		 * 
		 **/
		public var videoDuration : int = int.MIN_VALUE;

		/**
		 * The video bit rate
		 * 
		 **/
		public var videoBitRate : int = int.MIN_VALUE;

		/**
		 * The video bit rate mode
		 * 
		 * @see com.kaltura.types.KalturaBitRateMode
		 **/
		public var videoBitRateMode : int = int.MIN_VALUE;

		/**
		 * The video width
		 * 
		 **/
		public var videoWidth : int = int.MIN_VALUE;

		/**
		 * The video height
		 * 
		 **/
		public var videoHeight : int = int.MIN_VALUE;

		/**
		 * The video frame rate
		 * 
		 **/
		public var videoFrameRate : Number = Number.NEGATIVE_INFINITY;

		/**
		 * The video display aspect ratio (dar)
		 * 
		 **/
		public var videoDar : Number = Number.NEGATIVE_INFINITY;

		/**
		 **/
		public var videoRotation : int = int.MIN_VALUE;

		/**
		 * The audio format
		 * 
		 **/
		public var audioFormat : String = null;

		/**
		 * The audio codec id
		 * 
		 **/
		public var audioCodecId : String = null;

		/**
		 * The audio duration
		 * 
		 **/
		public var audioDuration : int = int.MIN_VALUE;

		/**
		 * The audio bit rate
		 * 
		 **/
		public var audioBitRate : int = int.MIN_VALUE;

		/**
		 * The audio bit rate mode
		 * 
		 * @see com.kaltura.types.KalturaBitRateMode
		 **/
		public var audioBitRateMode : int = int.MIN_VALUE;

		/**
		 * The number of audio channels
		 * 
		 **/
		public var audioChannels : int = int.MIN_VALUE;

		/**
		 * The audio sampling rate
		 * 
		 **/
		public var audioSamplingRate : int = int.MIN_VALUE;

		/**
		 * The audio resolution
		 * 
		 **/
		public var audioResolution : int = int.MIN_VALUE;

		/**
		 * The writing library
		 * 
		 **/
		public var writingLib : String = null;

		/**
		 * The data as returned by the mediainfo command line
		 * 
		 **/
		public var rawData : String = null;

		/**
		 **/
		public var multiStreamInfo : String = null;

		/**
		 **/
		public var scanType : int = int.MIN_VALUE;

		/**
		 **/
		public var multiStream : String = null;

		/** 
		 * a list of attributes which may be updated on this object 
		 **/ 
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

		/** 
		 * a list of attributes which may only be inserted when initializing this object 
		 **/ 
		public function getInsertableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			return arr;
		}
	}
}
