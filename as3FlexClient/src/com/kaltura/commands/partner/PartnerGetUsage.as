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
package com.kaltura.commands.partner
{
	import com.kaltura.delegates.partner.PartnerGetUsageDelegate;
	import com.kaltura.net.KalturaCall;

	/**
	 * Get usage statistics for a partner
	 * Calculation is done according to partner's package
	 * Additional data returned is a graph points of streaming usage in a timeframe
	 * The resolution can be "days" or "months"
	 * 
	 **/
	public class PartnerGetUsage extends KalturaCall
	{
		public var filterFields : String;
		
		/**
		 * @param year int
		 * @param month int
		 * @param resolution String
		 **/
		public function PartnerGetUsage( year : int=int.MIN_VALUE,month : int=1,resolution : String = null )
		{
			service= 'partner';
			action= 'getUsage';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('year');
			valueArr.push(year);
			keyArr.push('month');
			valueArr.push(month);
			keyArr.push('resolution');
			valueArr.push(resolution);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new PartnerGetUsageDelegate( this , config );
		}
	}
}
