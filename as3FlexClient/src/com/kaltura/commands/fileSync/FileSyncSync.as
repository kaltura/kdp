package com.kaltura.commands.fileSync
{
	import com.kaltura.vo.File;
	import com.kaltura.delegates.fileSync.FileSyncSyncDelegate;
	import com.kaltura.net.KalturaCall;

	public class FileSyncSync extends KalturaCall
	{
		public var filterFields : String;
		public function FileSyncSync( fileSyncId : int,fileData : file )
		{
			service= 'filesync_filesync';
			action= 'sync';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push( 'fileSyncId' );
			valueArr.push( fileSyncId );
 			keyValArr = kalturaObject2Arrays(fileData,'fileData');
			keyArr = keyArr.concat( keyValArr[0] );
			valueArr = valueArr.concat( keyValArr[1] );
			applySchema( keyArr , valueArr );
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields',filterFields);
			delegate = new FileSyncSyncDelegate( this , config );
		}
	}
}
