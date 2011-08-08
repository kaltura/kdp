package com.kaltura.commands.virusScanProfile
{
	import com.kaltura.vo.KalturaVirusScanProfileFilter;
	import com.kaltura.vo.KalturaFilterPager;
	import com.kaltura.delegates.virusScanProfile.VirusScanProfileListDelegate;
	import com.kaltura.net.KalturaCall;

	public class VirusScanProfileList extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param filter KalturaVirusScanProfileFilter
		 * @param pager KalturaFilterPager
		 **/
		public function VirusScanProfileList( filter : KalturaVirusScanProfileFilter=null,pager : KalturaFilterPager=null )
		{
			if(filter== null)filter= new KalturaVirusScanProfileFilter();
			if(pager== null)pager= new KalturaFilterPager();
			service= 'virusscan_virusscanprofile';
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
			delegate = new VirusScanProfileListDelegate( this , config );
		}
	}
}
