package com.kaltura.commands.systemPartner
{
	import com.kaltura.vo.KalturaPartnerFilter;
	import com.kaltura.vo.KalturaFilterPager;
	import com.kaltura.delegates.systemPartner.SystemPartnerListDelegate;
	import com.kaltura.net.KalturaCall;

	public class SystemPartnerList extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param filter KalturaPartnerFilter
		 * @param pager KalturaFilterPager
		 **/
		public function SystemPartnerList( filter : KalturaPartnerFilter=null,pager : KalturaFilterPager=null )
		{
			if(filter== null)filter= new KalturaPartnerFilter();
			if(pager== null)pager= new KalturaFilterPager();
			service= 'systempartner_systempartner';
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
			delegate = new SystemPartnerListDelegate( this , config );
		}
	}
}
