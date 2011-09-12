package com.kaltura.commands.adminUser
{
	import com.kaltura.delegates.adminUser.AdminUserResetPasswordDelegate;
	import com.kaltura.net.KalturaCall;

	public class AdminUserResetPassword extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param email String
		 **/
		public function AdminUserResetPassword( email : String )
		{
			service= 'adminuser';
			action= 'resetPassword';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('email');
			valueArr.push(email);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new AdminUserResetPasswordDelegate( this , config );
		}
	}
}
