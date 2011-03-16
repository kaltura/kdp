package com.kaltura.commands.entryDistribution
{
	import com.kaltura.vo.KalturaEntryDistributionFilter;
	import com.kaltura.vo.KalturaFilterPager;
	import com.kaltura.delegates.entryDistribution.EntryDistributionListDelegate;
	import com.kaltura.net.KalturaCall;

	public class EntryDistributionList extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param filter KalturaEntryDistributionFilter
		 * @param pager KalturaFilterPager
		 **/
		public function EntryDistributionList( filter : KalturaEntryDistributionFilter=null,pager : KalturaFilterPager=null )
		{
			if(filter== null)filter= new KalturaEntryDistributionFilter();
			if(pager== null)pager= new KalturaFilterPager();
			service= 'contentdistribution_entrydistribution';
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
			delegate = new EntryDistributionListDelegate( this , config );
		}
	}
}
