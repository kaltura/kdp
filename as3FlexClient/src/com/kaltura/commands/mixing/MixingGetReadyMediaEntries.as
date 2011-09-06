package com.kaltura.commands.mixing
{
	import com.kaltura.delegates.mixing.MixingGetReadyMediaEntriesDelegate;
	import com.kaltura.net.KalturaCall;

	public class MixingGetReadyMediaEntries extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param mixId String
		 * @param version int
		 **/
		public function MixingGetReadyMediaEntries( mixId : String,version : int=-1 )
		{
			service= 'mixing';
			action= 'getReadyMediaEntries';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('mixId');
			valueArr.push(mixId);
			keyArr.push('version');
			valueArr.push(version);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new MixingGetReadyMediaEntriesDelegate( this , config );
		}
	}
}
