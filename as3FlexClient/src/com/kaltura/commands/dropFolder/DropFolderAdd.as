package com.kaltura.commands.dropFolder
{
	import com.kaltura.vo.KalturaDropFolder;
	import com.kaltura.delegates.dropFolder.DropFolderAddDelegate;
	import com.kaltura.net.KalturaCall;

	public class DropFolderAdd extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param dropFolder KalturaDropFolder
		 **/
		public function DropFolderAdd( dropFolder : KalturaDropFolder )
		{
			service= 'dropfolder_dropfolder';
			action= 'add';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
 			keyValArr = kalturaObject2Arrays(dropFolder, 'dropFolder');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new DropFolderAddDelegate( this , config );
		}
	}
}
