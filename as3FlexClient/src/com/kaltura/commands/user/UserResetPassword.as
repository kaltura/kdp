package com.kaltura.commands.user
{
	import com.kaltura.delegates.user.UserResetPasswordDelegate;
	import com.kaltura.net.KalturaCall;

	public class UserResetPassword extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param email String
		 **/
		public function UserResetPassword( email : String )
		{
			service= 'user';
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
			delegate = new UserResetPasswordDelegate( this , config );
		}
	}
}
