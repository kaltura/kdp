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
		public function ReportGetUrlForReportAsCsv( reportTitle : String,reportText : String,headers : String,reportType : int,reportInputFilter : KalturaReportInputFilter,dimension : String='',pager : KalturaFilterPager=null,order : String='',objectIds : String='' )
		{
			if(pager== null)pager= new KalturaFilterPager();
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
 			keyValArr = kalturaObject2Arrays(pager, 'pager');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
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
