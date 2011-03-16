package com.kaltura.commands.genericDistributionProvider
{
	import com.kaltura.vo.KalturaGenericDistributionProviderFilter;
	import com.kaltura.vo.KalturaFilterPager;
	import com.kaltura.delegates.genericDistributionProvider.GenericDistributionProviderListDelegate;
	import com.kaltura.net.KalturaCall;

	public class GenericDistributionProviderList extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param filter KalturaGenericDistributionProviderFilter
		 * @param pager KalturaFilterPager
		 **/
		public function GenericDistributionProviderList( filter : KalturaGenericDistributionProviderFilter=null,pager : KalturaFilterPager=null )
		{
			if(filter== null)filter= new KalturaGenericDistributionProviderFilter();
			if(pager== null)pager= new KalturaFilterPager();
			service= 'contentdistribution_genericdistributionprovider';
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
			delegate = new GenericDistributionProviderListDelegate( this , config );
		}
	}
}
