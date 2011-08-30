package com.kaltura.commands.baseEntry
{
	import com.kaltura.vo.KalturaBaseEntry;
	import com.kaltura.delegates.baseEntry.BaseEntryAddFromUploadedFileDelegate;
	import com.kaltura.net.KalturaCall;

	public class BaseEntryAddFromUploadedFile extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param entry KalturaBaseEntry
		 * @param uploadTokenId String
		 * @param type String
		 **/
		public function BaseEntryAddFromUploadedFile( entry : KalturaBaseEntry,uploadTokenId : String,type : String='null' )
		{
			service= 'baseentry';
			action= 'addFromUploadedFile';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
 			keyValArr = kalturaObject2Arrays(entry, 'entry');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			keyArr.push('uploadTokenId');
			valueArr.push(uploadTokenId);
			keyArr.push('type');
			valueArr.push(type);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new BaseEntryAddFromUploadedFileDelegate( this , config );
		}
	}
}
