package com.kaltura.commands.dropFolder
{
	import com.kaltura.delegates.dropFolder.DropFolderGetDelegate;
	import com.kaltura.net.KalturaCall;

	public class DropFolderGet extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param dropFolderId int
		 **/
		public function DropFolderGet( dropFolderId : int )
		{
			service= 'dropfolder_dropfolder';
			action= 'get';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('dropFolderId');
			valueArr.push(dropFolderId);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new DropFolderGetDelegate( this , config );
		}
	}
}
