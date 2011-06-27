package com.kaltura.commands.permission
{
	import com.kaltura.vo.KalturaPermissionFilter;
	import com.kaltura.vo.KalturaFilterPager;
	import com.kaltura.delegates.permission.PermissionListDelegate;
	import com.kaltura.net.KalturaCall;

	public class PermissionList extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param filter KalturaPermissionFilter
		 * @param pager KalturaFilterPager
		 **/
		public function PermissionList( filter : KalturaPermissionFilter=null,pager : KalturaFilterPager=null )
		{
			if(filter== null)filter= new KalturaPermissionFilter();
			if(pager== null)pager= new KalturaFilterPager();
			service= 'permission';
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
			delegate = new PermissionListDelegate( this , config );
		}
	}
}
