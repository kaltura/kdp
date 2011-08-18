package com.kaltura.commands.syndicationFeed
{
	import com.kaltura.vo.KalturaBaseSyndicationFeedFilter;
	import com.kaltura.vo.KalturaFilterPager;
	import com.kaltura.delegates.syndicationFeed.SyndicationFeedListDelegate;
	import com.kaltura.net.KalturaCall;

	public class SyndicationFeedList extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param filter KalturaBaseSyndicationFeedFilter
		 * @param pager KalturaFilterPager
		 **/
		public function SyndicationFeedList( filter : KalturaBaseSyndicationFeedFilter=null,pager : KalturaFilterPager=null )
		{
			service= 'syndicationfeed';
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
			delegate = new SyndicationFeedListDelegate( this , config );
		}
	}
}
