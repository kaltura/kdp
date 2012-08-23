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
	public dynamic class KalturaPartnerStatistics extends BaseFlexVo
	{
		/**
		 * Package total allowed bandwidth and storage
		 * 
		 **/
		public var packageBandwidthAndStorage : int = int.MIN_VALUE;

		/**
		 * Partner total hosting in GB on the disk
		 * 
		 **/
		public var hosting : Number = Number.NEGATIVE_INFINITY;

		/**
		 * Partner total bandwidth in GB
		 * 
		 **/
		public var bandwidth : Number = Number.NEGATIVE_INFINITY;

		/**
		 * total usage in GB - including bandwidth and storage
		 * 
		 **/
		public var usage : int = int.MIN_VALUE;

		/**
		 * Percent of usage out of partner's package. if usage is 5GB and package is 10GB, this value will be 50
		 * 
		 **/
		public var usagePercent : Number = Number.NEGATIVE_INFINITY;

		/**
		 * date when partner reached the limit of his package (timestamp)
		 * 
		 **/
		public var reachedLimitDate : int = int.MIN_VALUE;

		/** 
		 * a list of attributes which may be updated on this object 
		 **/ 
		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
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
