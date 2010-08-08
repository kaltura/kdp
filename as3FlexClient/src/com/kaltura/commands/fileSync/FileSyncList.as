package com.kaltura.commands.fileSync
{
	import com.kaltura.vo.KalturaFileSyncFilter;
	import com.kaltura.vo.KalturaFilterPager;
	import com.kaltura.delegates.fileSync.FileSyncListDelegate;
	import com.kaltura.net.KalturaCall;

	public class FileSyncList extends KalturaCall
	{
		public var filterFields : String;
		public function FileSyncList( filter : KalturaFileSyncFilter=null,pager : KalturaFilterPager=null )
		{
			if(filter== null)filter= new KalturaFileSyncFilter();
			if(pager== null)pager= new KalturaFilterPager();
			service= 'filesync_filesync';
			action= 'list';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
 			keyValArr = kalturaObject2Arrays(filter,'filter');
			keyArr = keyArr.concat( keyValArr[0] );
			valueArr = valueArr.concat( keyValArr[1] );
 			keyValArr = kalturaObject2Arrays(pager,'pager');
			keyArr = keyArr.concat( keyValArr[0] );
			valueArr = valueArr.concat( keyValArr[1] );
			applySchema( keyArr , valueArr );
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields',filterFields);
			delegate = new FileSyncListDelegate( this , config );
		}
	}
}
