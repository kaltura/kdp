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
	public dynamic class KalturaPartnerUsage extends BaseFlexVo
	{
		/**
		 * Partner total hosting in GB on the disk
		 * 
		 **/
		public var hostingGB : Number = Number.NEGATIVE_INFINITY;

		/**
		 * percent of usage out of partner's package. if usageGB is 5 and package is 10GB, this value will be 50
		 * 
		 **/
		public var Percent : Number = Number.NEGATIVE_INFINITY;

		/**
		 * package total BW - actually this is usage, which represents BW+storage
		 * 
		 **/
		public var packageBW : int = int.MIN_VALUE;

		/**
		 * total usage in GB - including bandwidth and storage
		 * 
		 **/
		public var usageGB : Number = Number.NEGATIVE_INFINITY;

		/**
		 * date when partner reached the limit of his package (timestamp)
		 * 
		 **/
		public var reachedLimitDate : int = int.MIN_VALUE;

		/**
		 * a semi-colon separated list of comma-separated key-values to represent a usage graph.
		 * keys could be 1-12 for a year view (1,1.2;2,1.1;3,0.9;...;12,1.4;)
		 * keys could be 1-[28,29,30,31] depending on the requested month, for a daily view in a given month (1,0.4;2,0.2;...;31,0.1;)
		 * 
		 **/
		public var usageGraph : String = null;

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
