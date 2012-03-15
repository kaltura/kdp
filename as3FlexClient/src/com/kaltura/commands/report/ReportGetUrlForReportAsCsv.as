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
package com.kaltura.commands.report
{
	import com.kaltura.vo.KalturaReportInputFilter;
	import com.kaltura.vo.KalturaFilterPager;
	import com.kaltura.delegates.report.ReportGetUrlForReportAsCsvDelegate;
	import com.kaltura.net.KalturaCall;

	public class ReportGetUrlForReportAsCsv extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param reportTitle String
		 * @param reportText String
		 * @param headers String
		 * @param reportType int
		 * @param reportInputFilter KalturaReportInputFilter
		 * @param dimension String
		 * @param pager KalturaFilterPager
		 * @param order String
		 * @param objectIds String
		 **/
		public function ReportGetUrlForReportAsCsv( reportTitle : String,reportText : String,headers : String,reportType : int,reportInputFilter : KalturaReportInputFilter,dimension : String = null,pager : KalturaFilterPager=null,order : String = null,objectIds : String = null )
		{
			service= 'report';
			action= 'getUrlForReportAsCsv';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('reportTitle');
			valueArr.push(reportTitle);
			keyArr.push('reportText');
			valueArr.push(reportText);
			keyArr.push('headers');
			valueArr.push(headers);
			keyArr.push('reportType');
			valueArr.push(reportType);
 			keyValArr = kalturaObject2Arrays(reportInputFilter, 'reportInputFilter');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			keyArr.push('dimension');
			valueArr.push(dimension);
 			if (pager) { 
 			keyValArr = kalturaObject2Arrays(pager, 'pager');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
 			} 
			keyArr.push('order');
			valueArr.push(order);
			keyArr.push('objectIds');
			valueArr.push(objectIds);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new ReportGetUrlForReportAsCsvDelegate( this , config );
		}
	}
}
