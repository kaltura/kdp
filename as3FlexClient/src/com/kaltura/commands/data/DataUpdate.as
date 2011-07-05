package com.kaltura.commands.data
{
	import com.kaltura.vo.KalturaDataEntry;
	import com.kaltura.delegates.data.DataUpdateDelegate;
	import com.kaltura.net.KalturaCall;

	public class DataUpdate extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param entryId String
		 * @param documentEntry KalturaDataEntry
		 **/
		public function DataUpdate( entryId : String,documentEntry : KalturaDataEntry )
		{
			service= 'data';
			action= 'update';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('entryId');
			valueArr.push(entryId);
 			keyValArr = kalturaObject2Arrays(documentEntry, 'documentEntry');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new DataUpdateDelegate( this , config );
		}
	}
}
