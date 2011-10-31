package com.kaltura.commands.dropFolder
{
	import com.kaltura.vo.KalturaDropFolder;
	import com.kaltura.delegates.dropFolder.DropFolderUpdateDelegate;
	import com.kaltura.net.KalturaCall;

	public class DropFolderUpdate extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param dropFolderId int
		 * @param dropFolder KalturaDropFolder
		 **/
		public function DropFolderUpdate( dropFolderId : int,dropFolder : KalturaDropFolder )
		{
			service= 'dropfolder_dropfolder';
			action= 'update';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('dropFolderId');
			valueArr.push(dropFolderId);
 			keyValArr = kalturaObject2Arrays(dropFolder, 'dropFolder');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new DropFolderUpdateDelegate( this , config );
		}
	}
}
