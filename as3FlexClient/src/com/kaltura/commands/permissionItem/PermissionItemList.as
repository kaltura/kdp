package com.kaltura.commands.permissionItem
{
	import com.kaltura.vo.KalturaPermissionItemFilter;
	import com.kaltura.vo.KalturaFilterPager;
	import com.kaltura.delegates.permissionItem.PermissionItemListDelegate;
	import com.kaltura.net.KalturaCall;

	public class PermissionItemList extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param filter KalturaPermissionItemFilter
		 * @param pager KalturaFilterPager
		 **/
		public function PermissionItemList( filter : KalturaPermissionItemFilter=null,pager : KalturaFilterPager=null )
		{
			if(filter== null)filter= new KalturaPermissionItemFilter();
			if(pager== null)pager= new KalturaFilterPager();
			service= 'permissionitem';
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
			delegate = new PermissionItemListDelegate( this , config );
		}
	}
}
