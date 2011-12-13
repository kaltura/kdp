package com.kaltura.commands.genericDistributionProviderAction
{
	import com.kaltura.vo.KalturaGenericDistributionProviderActionFilter;
	import com.kaltura.vo.KalturaFilterPager;
	import com.kaltura.delegates.genericDistributionProviderAction.GenericDistributionProviderActionListDelegate;
	import com.kaltura.net.KalturaCall;

	public class GenericDistributionProviderActionList extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param filter KalturaGenericDistributionProviderActionFilter
		 * @param pager KalturaFilterPager
		 **/
		public function GenericDistributionProviderActionList( filter : KalturaGenericDistributionProviderActionFilter=null,pager : KalturaFilterPager=null )
		{
			service= 'contentdistribution_genericdistributionprovideraction';
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
			delegate = new GenericDistributionProviderActionListDelegate( this , config );
		}
	}
}
