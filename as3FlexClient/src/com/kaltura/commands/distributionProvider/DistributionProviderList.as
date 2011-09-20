package com.kaltura.commands.distributionProvider
{
	import com.kaltura.vo.KalturaDistributionProviderFilter;
	import com.kaltura.vo.KalturaFilterPager;
	import com.kaltura.delegates.distributionProvider.DistributionProviderListDelegate;
	import com.kaltura.net.KalturaCall;

	public class DistributionProviderList extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param filter KalturaDistributionProviderFilter
		 * @param pager KalturaFilterPager
		 **/
		public function DistributionProviderList( filter : KalturaDistributionProviderFilter=null,pager : KalturaFilterPager=null )
		{
			if(filter== null)filter= new KalturaDistributionProviderFilter();
			if(pager== null)pager= new KalturaFilterPager();
			service= 'contentdistribution_distributionprovider';
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
			delegate = new DistributionProviderListDelegate( this , config );
		}
	}
}
