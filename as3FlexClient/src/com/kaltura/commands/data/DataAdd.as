package com.kaltura.commands.data
{
	import com.kaltura.vo.KalturaDataEntry;
	import com.kaltura.delegates.data.DataAddDelegate;
	import com.kaltura.net.KalturaCall;

	public class DataAdd extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param dataEntry KalturaDataEntry
		 **/
		public function DataAdd( dataEntry : KalturaDataEntry )
		{
			service= 'data';
			action= 'add';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
 			keyValArr = kalturaObject2Arrays(dataEntry, 'dataEntry');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new DataAddDelegate( this , config );
		}
	}
}
