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
	public dynamic class KalturaGenericDistributionProviderAction extends BaseFlexVo
	{
		/**
		 * Auto generated
		 * 
		 **/
		public var id : int = int.MIN_VALUE;

		/**
		 * Generic distribution provider action creation date as Unix timestamp (In seconds)
		 * 
		 **/
		public var createdAt : int = int.MIN_VALUE;

		/**
		 * Generic distribution provider action last update date as Unix timestamp (In seconds)
		 * 
		 **/
		public var updatedAt : int = int.MIN_VALUE;

		/**
		 **/
		public var genericDistributionProviderId : int = int.MIN_VALUE;

		/**
		 * @see com.kaltura.types.KalturaDistributionAction
		 **/
		public var action : int = int.MIN_VALUE;

		/**
		 * @see com.kaltura.types.KalturaGenericDistributionProviderStatus
		 **/
		public var status : int = int.MIN_VALUE;

		/**
		 * @see com.kaltura.types.KalturaGenericDistributionProviderParser
		 **/
		public var resultsParser : int = int.MIN_VALUE;

		/**
		 * @see com.kaltura.types.KalturaDistributionProtocol
		 **/
		public var protocol : int = int.MIN_VALUE;

		/**
		 **/
		public var serverAddress : String = null;

		/**
		 **/
		public var remotePath : String = null;

		/**
		 **/
		public var remoteUsername : String = null;

		/**
		 **/
		public var remotePassword : String = null;

		/**
		 **/
		public var editableFields : String = null;

		/**
		 **/
		public var mandatoryFields : String = null;

		/**
		 **/
		public var mrssTransformer : String = null;

		/**
		 **/
		public var mrssValidator : String = null;

		/**
		 **/
		public var resultsTransformer : String = null;

		/** 
		 * a list of attributes which may be updated on this object 
		 **/ 
		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('resultsParser');
			arr.push('protocol');
			arr.push('serverAddress');
			arr.push('remotePath');
			arr.push('remoteUsername');
			arr.push('remotePassword');
			arr.push('editableFields');
			arr.push('mandatoryFields');
			return arr;
		}

		/** 
		 * a list of attributes which may only be inserted when initializing this object 
		 **/ 
		public function getInsertableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('genericDistributionProviderId');
			arr.push('action');
			return arr;
		}
	}
}
