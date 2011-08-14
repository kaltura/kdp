package com.kaltura.commands.adminUser
{
	import com.kaltura.delegates.adminUser.AdminUserSetInitialPasswordDelegate;
	import com.kaltura.net.KalturaCall;

	public class AdminUserSetInitialPassword extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param hashKey String
		 * @param newPassword String
		 **/
		public function AdminUserSetInitialPassword( hashKey : String,newPassword : String )
		{
			service= 'adminuser';
			action= 'setInitialPassword';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('hashKey');
			valueArr.push(hashKey);
			keyArr.push('newPassword');
			valueArr.push(newPassword);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new AdminUserSetInitialPasswordDelegate( this , config );
		}
	}
}
