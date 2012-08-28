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
	import com.kaltura.vo.KalturaConfigurableDistributionProfile;

	[Bindable]
	public dynamic class KalturaMsnDistributionProfile extends KalturaConfigurableDistributionProfile
	{
		/**
		 **/
		public var username : String = null;

		/**
		 **/
		public var password : String = null;

		/**
		 **/
		public var domain : String = null;

		/**
		 **/
		public var csId : String = null;

		/**
		 **/
		public var source : String = null;

		/**
		 **/
		public var sourceFriendlyName : String = null;

		/**
		 **/
		public var pageGroup : String = null;

		/**
		 **/
		public var sourceFlavorParamsId : int = int.MIN_VALUE;

		/**
		 **/
		public var wmvFlavorParamsId : int = int.MIN_VALUE;

		/**
		 **/
		public var flvFlavorParamsId : int = int.MIN_VALUE;

		/**
		 **/
		public var slFlavorParamsId : int = int.MIN_VALUE;

		/**
		 **/
		public var slHdFlavorParamsId : int = int.MIN_VALUE;

		/**
		 **/
		public var msnvideoCat : String = null;

		/**
		 **/
		public var msnvideoTop : String = null;

		/**
		 **/
		public var msnvideoTopCat : String = null;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('username');
			arr.push('password');
			arr.push('domain');
			arr.push('csId');
			arr.push('source');
			arr.push('sourceFriendlyName');
			arr.push('pageGroup');
			arr.push('sourceFlavorParamsId');
			arr.push('wmvFlavorParamsId');
			arr.push('flvFlavorParamsId');
			arr.push('slFlavorParamsId');
			arr.push('slHdFlavorParamsId');
			arr.push('msnvideoCat');
			arr.push('msnvideoTop');
			arr.push('msnvideoTopCat');
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
