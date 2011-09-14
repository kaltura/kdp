package com.kaltura.commands.baseEntry
{
	import com.kaltura.delegates.baseEntry.BaseEntryUpdateThumbnailFromSourceEntryDelegate;
	import com.kaltura.net.KalturaCall;

	public class BaseEntryUpdateThumbnailFromSourceEntry extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param entryId String
		 * @param sourceEntryId String
		 * @param timeOffset int
		 **/
		public function BaseEntryUpdateThumbnailFromSourceEntry( entryId : String,sourceEntryId : String,timeOffset : int )
		{
			service= 'baseentry';
			action= 'updateThumbnailFromSourceEntry';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('entryId');
			valueArr.push(entryId);
			keyArr.push('sourceEntryId');
			valueArr.push(sourceEntryId);
			keyArr.push('timeOffset');
			valueArr.push(timeOffset);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new BaseEntryUpdateThumbnailFromSourceEntryDelegate( this , config );
		}
	}
}
