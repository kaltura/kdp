package com.kaltura.commands.cuePoint
{
	import com.kaltura.vo.KalturaCuePoint;
	import com.kaltura.delegates.cuePoint.CuePointUpdateDelegate;
	import com.kaltura.net.KalturaCall;

	public class CuePointUpdate extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param id String
		 * @param cuePoint KalturaCuePoint
		 **/
		public function CuePointUpdate( id : String,cuePoint : KalturaCuePoint )
		{
			service= 'cuepoint_cuepoint';
			action= 'update';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('id');
			valueArr.push(id);
 			keyValArr = kalturaObject2Arrays(cuePoint, 'cuePoint');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new CuePointUpdateDelegate( this , config );
		}
	}
}
