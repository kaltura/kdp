package com.kaltura.commands.stats
{
	import com.kaltura.vo.KalturaStatsKmcEvent;
	import com.kaltura.delegates.stats.StatsKmcCollectDelegate;
	import com.kaltura.net.KalturaCall;

	public class StatsKmcCollect extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param kmcEvent KalturaStatsKmcEvent
		 **/
		public function StatsKmcCollect( kmcEvent : KalturaStatsKmcEvent )
		{
			service= 'stats';
			action= 'kmcCollect';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
 			keyValArr = kalturaObject2Arrays(kmcEvent, 'kmcEvent');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new StatsKmcCollectDelegate( this , config );
		}
	}
}
