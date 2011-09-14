package com.kaltura.commands.mediaInfo
{
	import com.kaltura.vo.KalturaMediaInfoFilter;
	import com.kaltura.vo.KalturaFilterPager;
	import com.kaltura.delegates.mediaInfo.MediaInfoListDelegate;
	import com.kaltura.net.KalturaCall;

	public class MediaInfoList extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param filter KalturaMediaInfoFilter
		 * @param pager KalturaFilterPager
		 **/
		public function MediaInfoList( filter : KalturaMediaInfoFilter=null,pager : KalturaFilterPager=null )
		{
			if(filter== null)filter= new KalturaMediaInfoFilter();
			if(pager== null)pager= new KalturaFilterPager();
			service= 'adminconsole_mediainfo';
			action= 'list';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
 			keyValArr = kalturaObject2Arrays(filter, 'filter');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
 			keyValArr = kalturaObject2Arrays(pager, 'pager');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new MediaInfoListDelegate( this , config );
		}
	}
}
