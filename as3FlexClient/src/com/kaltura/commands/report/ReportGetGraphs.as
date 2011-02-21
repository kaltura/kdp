package com.kaltura.commands.report
{
	import com.kaltura.vo.KalturaReportInputFilter;
	import com.kaltura.delegates.report.ReportGetGraphsDelegate;
	import com.kaltura.net.KalturaCall;

	public class ReportGetGraphs extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param reportType int
		 * @param reportInputFilter KalturaReportInputFilter
		 * @param dimension String
		 * @param objectIds String
		 **/
		public function ReportGetGraphs( reportType : int,reportInputFilter : KalturaReportInputFilter,dimension : String='',objectIds : String='' )
		{
			service= 'report';
			action= 'getGraphs';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('reportType');
			valueArr.push(reportType);
 			keyValArr = kalturaObject2Arrays(reportInputFilter, 'reportInputFilter');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			keyArr.push('dimension');
			valueArr.push(dimension);
			keyArr.push('objectIds');
			valueArr.push(objectIds);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new ReportGetGraphsDelegate( this , config );
		}
	}
}
