package com.kaltura.commands.report
{
	import com.kaltura.vo.KalturaReportInputFilter;
	import com.kaltura.delegates.report.ReportGetTotalDelegate;
	import com.kaltura.net.KalturaCall;

	public class ReportGetTotal extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param reportType int
		 * @param reportInputFilter KalturaReportInputFilter
		 * @param objectIds String
		 **/
		public function ReportGetTotal( reportType : int,reportInputFilter : KalturaReportInputFilter,objectIds : String='' )
		{
			service= 'report';
			action= 'getTotal';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('reportType');
			valueArr.push(reportType);
 			keyValArr = kalturaObject2Arrays(reportInputFilter, 'reportInputFilter');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			keyArr.push('objectIds');
			valueArr.push(objectIds);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new ReportGetTotalDelegate( this , config );
		}
	}
}
