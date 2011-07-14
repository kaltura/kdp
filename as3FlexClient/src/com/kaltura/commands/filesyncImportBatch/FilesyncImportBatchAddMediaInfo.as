package com.kaltura.commands.filesyncImportBatch
{
	import com.kaltura.vo.KalturaMediaInfo;
	import com.kaltura.delegates.filesyncImportBatch.FilesyncImportBatchAddMediaInfoDelegate;
	import com.kaltura.net.KalturaCall;

	public class FilesyncImportBatchAddMediaInfo extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param mediaInfo KalturaMediaInfo
		 **/
		public function FilesyncImportBatchAddMediaInfo( mediaInfo : KalturaMediaInfo )
		{
			service= 'multicenters_filesyncimportbatch';
			action= 'addMediaInfo';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
 			keyValArr = kalturaObject2Arrays(mediaInfo, 'mediaInfo');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new FilesyncImportBatchAddMediaInfoDelegate( this , config );
		}
	}
}
