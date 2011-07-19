package com.kaltura.commands.accessControl
{
	import com.kaltura.vo.KalturaAccessControlFilter;
	import com.kaltura.vo.KalturaFilterPager;
	import com.kaltura.delegates.accessControl.AccessControlListDelegate;
	import com.kaltura.net.KalturaCall;

	public class AccessControlList extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param filter KalturaAccessControlFilter
		 * @param pager KalturaFilterPager
		 **/
		public function AccessControlList( filter : KalturaAccessControlFilter=null,pager : KalturaFilterPager=null )
		{
			if(filter== null)filter= new KalturaAccessControlFilter();
			if(pager== null)pager= new KalturaFilterPager();
			service= 'accesscontrol';
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
			delegate = new AccessControlListDelegate( this , config );
		}
	}
}
