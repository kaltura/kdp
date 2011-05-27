package com.kaltura.commands.stats
{
	import com.kaltura.vo.KalturaStatsEvent;
	import com.kaltura.delegates.stats.StatsCollectDelegate;
	import com.kaltura.net.KalturaCall;

	public class StatsCollect extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param event KalturaStatsEvent
		 **/
		public function StatsCollect( event : KalturaStatsEvent )
		{
			service= 'stats';
			action= 'collect';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
 			keyValArr = kalturaObject2Arrays(event, 'event');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new StatsCollectDelegate( this , config );
		}
	}
}
