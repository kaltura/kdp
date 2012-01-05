package com.kaltura.commands.systemPartner
{
	import com.kaltura.vo.KalturaUserLoginDataFilter;
	import com.kaltura.vo.KalturaFilterPager;
	import com.kaltura.delegates.systemPartner.SystemPartnerListUserLoginDataDelegate;
	import com.kaltura.net.KalturaCall;

	public class SystemPartnerListUserLoginData extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param filter KalturaUserLoginDataFilter
		 * @param pager KalturaFilterPager
		 **/
		public function SystemPartnerListUserLoginData( filter : KalturaUserLoginDataFilter=null,pager : KalturaFilterPager=null )
		{
			service= 'systempartner_systempartner';
			action= 'listUserLoginData';

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
			delegate = new SystemPartnerListUserLoginDataDelegate( this , config );
		}
	}
}
