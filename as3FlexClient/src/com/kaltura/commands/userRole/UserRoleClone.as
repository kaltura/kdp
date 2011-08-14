package com.kaltura.commands.userRole
{
	import com.kaltura.delegates.userRole.UserRoleCloneDelegate;
	import com.kaltura.net.KalturaCall;

	public class UserRoleClone extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param userRoleId int
		 **/
		public function UserRoleClone( userRoleId : int )
		{
			service= 'userrole';
			action= 'clone';

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
			delegate = new UserRoleCloneDelegate( this , config );
		}
	}
}
