package com.kaltura.commands.stats
{
	import com.kaltura.vo.KalturaCEError;
	import com.kaltura.delegates.stats.StatsReportKceErrorDelegate;
	import com.kaltura.net.KalturaCall;

	public class StatsReportKceError extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param kalturaCEError KalturaCEError
		 **/
		public function StatsReportKceError( kalturaCEError : KalturaCEError )
		{
			service= 'stats';
			action= 'reportKceError';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
 			keyValArr = kalturaObject2Arrays(kalturaCEError, 'kalturaCEError');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new StatsReportKceErrorDelegate( this , config );
		}
	}
}
