package com.kaltura.commands.baseEntry
{
	import com.kaltura.vo.KalturaEntryContextDataParams;
	import com.kaltura.delegates.baseEntry.BaseEntryGetContextDataDelegate;
	import com.kaltura.net.KalturaCall;

	public class BaseEntryGetContextData extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param entryId String
		 * @param contextDataParams KalturaEntryContextDataParams
		 **/
		public function BaseEntryGetContextData( entryId : String,contextDataParams : KalturaEntryContextDataParams )
		{
			service= 'baseentry';
			action= 'getContextData';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('entryId');
			valueArr.push(entryId);
 			keyValArr = kalturaObject2Arrays(contextDataParams, 'contextDataParams');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new BaseEntryGetContextDataDelegate( this , config );
		}
	}
}
