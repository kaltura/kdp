package com.kaltura.commands.dropFolderFile
{
	import com.kaltura.delegates.dropFolderFile.DropFolderFileIgnoreDelegate;
	import com.kaltura.net.KalturaCall;

	public class DropFolderFileIgnore extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param dropFolderFileId int
		 **/
		public function DropFolderFileIgnore( dropFolderFileId : int )
		{
			service= 'dropfolder_dropfolderfile';
			action= 'ignore';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('dropFolderFileId');
			valueArr.push(dropFolderFileId);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new DropFolderFileIgnoreDelegate( this , config );
		}
	}
}
