package com.kaltura.commands.userRole
{
	import com.kaltura.vo.KalturaUserRoleFilter;
	import com.kaltura.vo.KalturaFilterPager;
	import com.kaltura.delegates.userRole.UserRoleListDelegate;
	import com.kaltura.net.KalturaCall;

	public class UserRoleList extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param filter KalturaUserRoleFilter
		 * @param pager KalturaFilterPager
		 **/
		public function UserRoleList( filter : KalturaUserRoleFilter=null,pager : KalturaFilterPager=null )
		{
			if(filter== null)filter= new KalturaUserRoleFilter();
			if(pager== null)pager= new KalturaFilterPager();
			service= 'userrole';
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
			delegate = new UserRoleListDelegate( this , config );
		}
	}
}
