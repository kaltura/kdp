package com.kaltura.commands.userRole
{
	import com.kaltura.vo.KalturaUserRole;
	import com.kaltura.delegates.userRole.UserRoleUpdateDelegate;
	import com.kaltura.net.KalturaCall;

	public class UserRoleUpdate extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param userRoleId int
		 * @param userRole KalturaUserRole
		 **/
		public function UserRoleUpdate( userRoleId : int,userRole : KalturaUserRole )
		{
			service= 'userrole';
			action= 'update';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('userRoleId');
			valueArr.push(userRoleId);
 			keyValArr = kalturaObject2Arrays(userRole, 'userRole');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new UserRoleUpdateDelegate( this , config );
		}
	}
}
