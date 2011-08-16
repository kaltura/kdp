package com.kaltura.commands.baseEntry
{
	import com.kaltura.vo.KalturaBaseEntry;
	import com.kaltura.vo.KalturaResource;
	import com.kaltura.delegates.baseEntry.BaseEntryAddDelegate;
	import com.kaltura.net.KalturaCall;

	public class BaseEntryAdd extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param entry KalturaBaseEntry
		 * @param resource KalturaResource
		 * @param type String
		 **/
		public function BaseEntryAdd( entry : KalturaBaseEntry,resource : KalturaResource,type : String='null' )
		{
			service= 'baseentry';
			action= 'add';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
 			keyValArr = kalturaObject2Arrays(entry, 'entry');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
 			keyValArr = kalturaObject2Arrays(resource, 'resource');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			keyArr.push('type');
			valueArr.push(type);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new BaseEntryAddDelegate( this , config );
		}
	}
}
