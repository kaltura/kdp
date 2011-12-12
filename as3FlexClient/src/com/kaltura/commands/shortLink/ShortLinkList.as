package com.kaltura.commands.shortLink
{
	import com.kaltura.vo.KalturaShortLinkFilter;
	import com.kaltura.vo.KalturaFilterPager;
	import com.kaltura.delegates.shortLink.ShortLinkListDelegate;
	import com.kaltura.net.KalturaCall;

	public class ShortLinkList extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param filter KalturaShortLinkFilter
		 * @param pager KalturaFilterPager
		 **/
		public function ShortLinkList( filter : KalturaShortLinkFilter=null,pager : KalturaFilterPager=null )
		{
			service= 'shortlink_shortlink';
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
			delegate = new ShortLinkListDelegate( this , config );
		}
	}
}
