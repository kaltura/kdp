package com.kaltura.commands.stats
{
	import com.kaltura.delegates.stats.StatsReportErrorDelegate;
	import com.kaltura.net.KalturaCall;

	public class StatsReportError extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param errorCode String
		 * @param errorMessage String
		 **/
		public function StatsReportError( errorCode : String,errorMessage : String )
		{
			service= 'stats';
			action= 'reportError';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('errorCode');
			valueArr.push(errorCode);
			keyArr.push('errorMessage');
			valueArr.push(errorMessage);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new StatsReportErrorDelegate( this , config );
		}
	}
}
