package com.kaltura.commands.baseEntry
{
	import com.kaltura.vo.KalturaResource;
	import com.kaltura.delegates.baseEntry.BaseEntryUpdateContentDelegate;
	import com.kaltura.net.KalturaCall;

	public class BaseEntryUpdateContent extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param entryId String
		 * @param resource KalturaResource
		 * @param conversionProfileId int
		 **/
		public function BaseEntryUpdateContent( entryId : String,resource : KalturaResource,conversionProfileId : int=int.MIN_VALUE )
		{
			service= 'baseentry';
			action= 'updateContent';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('entryId');
			valueArr.push(entryId);
 			keyValArr = kalturaObject2Arrays(resource, 'resource');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			keyArr.push('conversionProfileId');
			valueArr.push(conversionProfileId);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new BaseEntryUpdateContentDelegate( this , config );
		}
	}
}
