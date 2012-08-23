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
package com.kaltura.commands.document
{
	import com.kaltura.vo.KalturaDocumentEntry;
	import com.kaltura.delegates.document.DocumentAddFromEntryDelegate;
	import com.kaltura.net.KalturaCall;

	/**
	 * Copy entry into new entry
	 * 
	 **/
	public class DocumentAddFromEntry extends KalturaCall
	{
		public var filterFields : String;
		
		/**
		 * @param sourceEntryId String
		 * @param documentEntry KalturaDocumentEntry
		 * @param sourceFlavorParamsId int
		 **/
		public function DocumentAddFromEntry( sourceEntryId : String,documentEntry : KalturaDocumentEntry=null,sourceFlavorParamsId : int=int.MIN_VALUE )
		{
			service= 'document';
			action= 'addFromEntry';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('sourceEntryId');
			valueArr.push(sourceEntryId);
 			if (documentEntry) { 
 			keyValArr = kalturaObject2Arrays(documentEntry, 'documentEntry');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
 			} 
			keyArr.push('sourceFlavorParamsId');
			valueArr.push(sourceFlavorParamsId);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new DocumentAddFromEntryDelegate( this , config );
		}
	}
}
