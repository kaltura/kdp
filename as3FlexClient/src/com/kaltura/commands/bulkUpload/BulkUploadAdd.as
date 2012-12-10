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
package com.kaltura.commands.bulkUpload
{
	import flash.net.FileReference;
	import com.kaltura.net.KalturaFileCall;
	import com.kaltura.delegates.bulkUpload.BulkUploadAddDelegate;

	/**
	 * Add new bulk upload batch job
	 * Conversion profile id can be specified in the API or in the CSV file, the one in the CSV file will be stronger.
	 * If no conversion profile was specified, partner's default will be used
	 * 
	 **/
	public class BulkUploadAdd extends KalturaFileCall
	{
		public var csvFileData:Object;

		
		/**
		 * @param conversionProfileId int
		 * @param csvFileData Object - FileReference or ByteArray
		 * @param bulkUploadType String
		 * @param uploadedBy String
		 * @param fileName String
		 **/
		public function BulkUploadAdd( conversionProfileId : int,csvFileData : Object,bulkUploadType : String = null,uploadedBy : String = null,fileName : String = null )
		{
			service= 'bulkupload';
			action= 'add';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('conversionProfileId');
			valueArr.push(conversionProfileId);
			this.csvFileData = csvFileData;
			keyArr.push('bulkUploadType');
			valueArr.push(bulkUploadType);
			keyArr.push('uploadedBy');
			valueArr.push(uploadedBy);
			keyArr.push('fileName');
			valueArr.push(fileName);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new BulkUploadAddDelegate( this , config );
		}
	}
}
