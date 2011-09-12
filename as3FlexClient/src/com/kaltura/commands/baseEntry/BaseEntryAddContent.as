package com.kaltura.commands.baseEntry
{
	import com.kaltura.vo.KalturaResource;
	import com.kaltura.delegates.baseEntry.BaseEntryAddContentDelegate;
	import com.kaltura.net.KalturaCall;

	public class BaseEntryAddContent extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param entryId String
		 * @param resource KalturaResource
		 **/
		public function BaseEntryAddContent( entryId : String,resource : KalturaResource )
		{
			service= 'baseentry';
			action= 'addContent';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('entryId');
			valueArr.push(entryId);
 			keyValArr = kalturaObject2Arrays(resource, 'resource');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new BaseEntryAddContentDelegate( this , config );
		}
	}
}
