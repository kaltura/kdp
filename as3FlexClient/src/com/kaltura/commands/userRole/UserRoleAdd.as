package com.kaltura.commands.userRole
{
	import com.kaltura.vo.KalturaUserRole;
	import com.kaltura.delegates.userRole.UserRoleAddDelegate;
	import com.kaltura.net.KalturaCall;

	public class UserRoleAdd extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param userRole KalturaUserRole
		 **/
		public function UserRoleAdd( userRole : KalturaUserRole )
		{
			service= 'userrole';
			action= 'add';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
 			keyValArr = kalturaObject2Arrays(userRole, 'userRole');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new UserRoleAddDelegate( this , config );
		}
	}
}
