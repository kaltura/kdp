package com.kaltura.commands.mixing
{
	import com.kaltura.vo.KalturaMixEntry;
	import com.kaltura.delegates.mixing.MixingAddDelegate;
	import com.kaltura.net.KalturaCall;

	public class MixingAdd extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param mixEntry KalturaMixEntry
		 **/
		public function MixingAdd( mixEntry : KalturaMixEntry )
		{
			service= 'mixing';
			action= 'add';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
 			keyValArr = kalturaObject2Arrays(mixEntry, 'mixEntry');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new MixingAddDelegate( this , config );
		}
	}
}
