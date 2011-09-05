package com.kaltura.commands.baseEntry
{
	import com.kaltura.delegates.baseEntry.BaseEntryGetByIdsDelegate;
	import com.kaltura.net.KalturaCall;

	public class BaseEntryGetByIds extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param entryIds String
		 **/
		public function BaseEntryGetByIds( entryIds : String )
		{
			service= 'baseentry';
			action= 'getByIds';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('entryIds');
			valueArr.push(entryIds);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new BaseEntryGetByIdsDelegate( this , config );
		}
	}
}
