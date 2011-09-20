package com.kaltura.commands.userRole
{
	import com.kaltura.delegates.userRole.UserRoleGetDelegate;
	import com.kaltura.net.KalturaCall;

	public class UserRoleGet extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param userRoleId int
		 **/
		public function UserRoleGet( userRoleId : int )
		{
			service= 'userrole';
			action= 'get';

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
			delegate = new UserRoleGetDelegate( this , config );
		}
	}
}
