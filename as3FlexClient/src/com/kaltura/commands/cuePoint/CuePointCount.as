package com.kaltura.commands.cuePoint
{
	import com.kaltura.vo.KalturaCuePointFilter;
	import com.kaltura.delegates.cuePoint.CuePointCountDelegate;
	import com.kaltura.net.KalturaCall;

	public class CuePointCount extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param filter KalturaCuePointFilter
		 **/
		public function CuePointCount( filter : KalturaCuePointFilter=null )
		{
			service= 'cuepoint_cuepoint';
			action= 'count';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
 			if (filter) { 
 			keyValArr = kalturaObject2Arrays(filter, 'filter');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
 			} 
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new CuePointCountDelegate( this , config );
		}
	}
}
