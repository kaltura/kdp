package com.kaltura.commands.cuePoint
{
	import com.kaltura.vo.KalturaCuePoint;
	import com.kaltura.delegates.cuePoint.CuePointAddDelegate;
	import com.kaltura.net.KalturaCall;

	public class CuePointAdd extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param cuePoint KalturaCuePoint
		 **/
		public function CuePointAdd( cuePoint : KalturaCuePoint )
		{
			service= 'cuepoint_cuepoint';
			action= 'add';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
 			keyValArr = kalturaObject2Arrays(cuePoint, 'cuePoint');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new CuePointAddDelegate( this , config );
		}
	}
}
