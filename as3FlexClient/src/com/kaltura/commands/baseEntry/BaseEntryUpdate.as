package com.kaltura.commands.baseEntry
{
	import com.kaltura.vo.KalturaBaseEntry;
	import com.kaltura.delegates.baseEntry.BaseEntryUpdateDelegate;
	import com.kaltura.net.KalturaCall;

	public class BaseEntryUpdate extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param entryId String
		 * @param baseEntry KalturaBaseEntry
		 **/
		public function BaseEntryUpdate( entryId : String,baseEntry : KalturaBaseEntry )
		{
			service= 'baseentry';
			action= 'update';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('entryId');
			valueArr.push(entryId);
 			keyValArr = kalturaObject2Arrays(baseEntry, 'baseEntry');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new BaseEntryUpdateDelegate( this , config );
		}
	}
}
