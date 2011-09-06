package com.kaltura.commands.dropFolder
{
	import com.kaltura.delegates.dropFolder.DropFolderDeleteDelegate;
	import com.kaltura.net.KalturaCall;

	public class DropFolderDelete extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param dropFolderId int
		 **/
		public function DropFolderDelete( dropFolderId : int )
		{
			service= 'dropfolder_dropfolder';
			action= 'delete';

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
			delegate = new DropFolderDeleteDelegate( this , config );
		}
	}
}
