package com.kaltura.commands.liveStream
{
	import com.kaltura.vo.KalturaLiveStreamEntryFilter;
	import com.kaltura.vo.KalturaFilterPager;
	import com.kaltura.delegates.liveStream.LiveStreamListDelegate;
	import com.kaltura.net.KalturaCall;

	public class LiveStreamList extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param filter KalturaLiveStreamEntryFilter
		 * @param pager KalturaFilterPager
		 **/
		public function LiveStreamList( filter : KalturaLiveStreamEntryFilter=null,pager : KalturaFilterPager=null )
		{
			service= 'livestream';
			action= 'list';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
 			if (filter) { 
 			keyValArr = kalturaObject2Arrays(filter, 'filter');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
 			} 
 			if (pager) { 
 			keyValArr = kalturaObject2Arrays(pager, 'pager');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
 			} 
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new LiveStreamListDelegate( this , config );
		}
	}
}
