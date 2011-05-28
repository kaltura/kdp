package com.kaltura.commands.userRole
{
	import com.kaltura.delegates.userRole.UserRoleDeleteDelegate;
	import com.kaltura.net.KalturaCall;

	public class UserRoleDelete extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param userRoleId int
		 **/
		public function UserRoleDelete( userRoleId : int )
		{
			service= 'userrole';
			action= 'delete';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('userRoleId');
			valueArr.push(userRoleId);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new UserRoleDeleteDelegate( this , config );
		}
	}
}
