package com.kaltura.commands.user
{
	import com.kaltura.delegates.user.UserSetInitialPasswordDelegate;
	import com.kaltura.net.KalturaCall;

	public class UserSetInitialPassword extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param hashKey String
		 * @param newPassword String
		 **/
		public function UserSetInitialPassword( hashKey : String,newPassword : String )
		{
			service= 'user';
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
			delegate = new UserSetInitialPasswordDelegate( this , config );
		}
	}
}
