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
package com.kaltura.commands.conversionProfileAssetParams
{
	import com.kaltura.vo.KalturaConversionProfileAssetParams;
	import com.kaltura.delegates.conversionProfileAssetParams.ConversionProfileAssetParamsUpdateDelegate;
	import com.kaltura.net.KalturaCall;

	/**
	 * Update asset parmas of conversion profile by ID
	 * 
	 **/
	public class ConversionProfileAssetParamsUpdate extends KalturaCall
	{
		public var filterFields : String;
		
		/**
		 * @param conversionProfileId int
		 * @param assetParamsId int
		 * @param conversionProfileAssetParams KalturaConversionProfileAssetParams
		 **/
		public function ConversionProfileAssetParamsUpdate( conversionProfileId : int,assetParamsId : int,conversionProfileAssetParams : KalturaConversionProfileAssetParams )
		{
			service= 'conversionprofileassetparams';
			action= 'update';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('conversionProfileId');
			valueArr.push(conversionProfileId);
			keyArr.push('assetParamsId');
			valueArr.push(assetParamsId);
 			keyValArr = kalturaObject2Arrays(conversionProfileAssetParams, 'conversionProfileAssetParams');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new ConversionProfileAssetParamsUpdateDelegate( this , config );
		}
	}
}
