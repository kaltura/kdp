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
	import com.kaltura.vo.KalturaFlavorParamsOutput;

	import com.kaltura.vo.KalturaJobData;

	[Bindable]
	public dynamic class KalturaConvartableJobData extends KalturaJobData
	{
		/**
		 **/
		public var srcFileSyncLocalPath : String = null;

		/**
		 * The translated path as used by the scheduler
		 * 
		 **/
		public var actualSrcFileSyncLocalPath : String = null;

		/**
		 **/
		public var srcFileSyncRemoteUrl : String = null;

		/**
		 **/
		public var engineVersion : int = int.MIN_VALUE;

		/**
		 **/
		public var flavorParamsOutputId : int = int.MIN_VALUE;

		/**
		 **/
		public var flavorParamsOutput : KalturaFlavorParamsOutput;

		/**
		 **/
		public var mediaInfoId : int = int.MIN_VALUE;

		/**
		 **/
		public var currentOperationSet : int = int.MIN_VALUE;

		/**
		 **/
		public var currentOperationIndex : int = int.MIN_VALUE;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('srcFileSyncLocalPath');
			arr.push('actualSrcFileSyncLocalPath');
			arr.push('srcFileSyncRemoteUrl');
			arr.push('engineVersion');
			arr.push('flavorParamsOutputId');
			arr.push('flavorParamsOutput');
			arr.push('mediaInfoId');
			arr.push('currentOperationSet');
			arr.push('currentOperationIndex');
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
