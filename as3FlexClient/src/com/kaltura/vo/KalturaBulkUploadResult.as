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
	public dynamic class KalturaBulkUploadResult extends BaseFlexVo
	{
		/** 
		* 		* */ 
		public var id : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var bulkUploadJobId : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var lineIndex : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var partnerId : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var action : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var entryId : String = null;

		/** 
		* 		* */ 
		public var objectId : String = null;

		/** 
		* 		* */ 
		public var bulkUploadResultObjectType : String = null;

		/** 
		* 		* */ 
		public var entryStatus : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var rowData : String = null;

		/** 
		* 		* */ 
		public var title : String = null;

		/** 
		* 		* */ 
		public var description : String = null;

		/** 
		* 		* */ 
		public var tags : String = null;

		/** 
		* 		* */ 
		public var url : String = null;

		/** 
		* 		* */ 
		public var contentType : String = null;

		/** 
		* 		* */ 
		public var conversionProfileId : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var accessControlProfileId : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var category : String = null;

		/** 
		* 		* */ 
		public var scheduleStartDate : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var scheduleEndDate : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var thumbnailUrl : String = null;

		/** 
		* 		* */ 
		public var thumbnailSaved : Boolean;

		/** 
		* 		* */ 
		public var partnerData : String = null;

		/** 
		* 		* */ 
		public var errorDescription : String = null;

		/** 
		* 		* */ 
		public var pluginsData : Array = new Array();

		/** 
		* 		* */ 
		public var sshPrivateKey : String = null;

		/** 
		* 		* */ 
		public var sshPublicKey : String = null;

		/** 
		* 		* */ 
		public var sshKeyPassphrase : String = null;

		/** 
		* a list of attributes which may be updated on this object 
		* */ 
		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('bulkUploadJobId');
			arr.push('lineIndex');
			arr.push('partnerId');
			arr.push('action');
			arr.push('entryId');
			arr.push('objectId');
			arr.push('bulkUploadResultObjectType');
			arr.push('entryStatus');
			arr.push('rowData');
			arr.push('title');
			arr.push('description');
			arr.push('tags');
			arr.push('url');
			arr.push('contentType');
			arr.push('conversionProfileId');
			arr.push('accessControlProfileId');
			arr.push('category');
			arr.push('scheduleStartDate');
			arr.push('scheduleEndDate');
			arr.push('thumbnailUrl');
			arr.push('thumbnailSaved');
			arr.push('partnerData');
			arr.push('errorDescription');
			arr.push('pluginsData');
			arr.push('sshPrivateKey');
			arr.push('sshPublicKey');
			arr.push('sshKeyPassphrase');
			return arr;
		}

		/** 
		* a list of attributes which may only be inserted when initializing this object 
		* */ 
		public function getInsertableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			return arr;
		}

	}
}
