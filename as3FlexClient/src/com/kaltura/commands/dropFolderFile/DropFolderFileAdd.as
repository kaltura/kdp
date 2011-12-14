package com.kaltura.commands.dropFolderFile
{
	import com.kaltura.vo.KalturaDropFolderFile;
	import com.kaltura.delegates.dropFolderFile.DropFolderFileAddDelegate;
	import com.kaltura.net.KalturaCall;

	public class DropFolderFileAdd extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param dropFolderFile KalturaDropFolderFile
		 **/
		public function DropFolderFileAdd( dropFolderFile : KalturaDropFolderFile )
		{
			service= 'dropfolder_dropfolderfile';
			action= 'add';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
 			keyValArr = kalturaObject2Arrays(dropFolderFile, 'dropFolderFile');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new DropFolderFileAddDelegate( this , config );
		}
	}
}
