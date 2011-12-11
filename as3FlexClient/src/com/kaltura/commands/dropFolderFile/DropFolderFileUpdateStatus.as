package com.kaltura.commands.dropFolderFile
{
	import com.kaltura.delegates.dropFolderFile.DropFolderFileUpdateStatusDelegate;
	import com.kaltura.net.KalturaCall;

	public class DropFolderFileUpdateStatus extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param dropFolderFileId int
		 * @param status int
		 **/
		public function DropFolderFileUpdateStatus( dropFolderFileId : int,status : int )
		{
			service= 'dropfolder_dropfolderfile';
			action= 'updateStatus';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('dropFolderFileId');
			valueArr.push(dropFolderFileId);
			keyArr.push('status');
			valueArr.push(status);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new DropFolderFileUpdateStatusDelegate( this , config );
		}
	}
}
