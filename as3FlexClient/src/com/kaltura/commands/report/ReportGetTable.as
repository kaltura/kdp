package com.kaltura.commands.report
{
	import com.kaltura.vo.KalturaReportInputFilter;
	import com.kaltura.vo.KalturaFilterPager;
	import com.kaltura.delegates.report.ReportGetTableDelegate;
	import com.kaltura.net.KalturaCall;

	public class ReportGetTable extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param reportType int
		 * @param reportInputFilter KalturaReportInputFilter
		 * @param pager KalturaFilterPager
		 * @param order String
		 * @param objectIds String
		 **/
		public function ReportGetTable( reportType : int,reportInputFilter : KalturaReportInputFilter,pager : KalturaFilterPager,order : String='',objectIds : String='' )
		{
			service= 'report';
			action= 'getTable';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('reportType');
			valueArr.push(reportType);
 			keyValArr = kalturaObject2Arrays(reportInputFilter, 'reportInputFilter');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
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
			delegate = new ReportGetTableDelegate( this , config );
		}
	}
}
