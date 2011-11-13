package com.kaltura.commands.dropFolderFile
{
	import com.kaltura.vo.KalturaDropFolderFile;
	import com.kaltura.delegates.dropFolderFile.DropFolderFileUpdateDelegate;
	import com.kaltura.net.KalturaCall;

	public class DropFolderFileUpdate extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param dropFolderFileId int
		 * @param dropFolderFile KalturaDropFolderFile
		 **/
		public function DropFolderFileUpdate( dropFolderFileId : int,dropFolderFile : KalturaDropFolderFile )
		{
			service= 'dropfolder_dropfolderfile';
			action= 'update';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('dropFolderFileId');
			valueArr.push(dropFolderFileId);
 			keyValArr = kalturaObject2Arrays(dropFolderFile, 'dropFolderFile');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new DropFolderFileUpdateDelegate( this , config );
		}
	}
}
