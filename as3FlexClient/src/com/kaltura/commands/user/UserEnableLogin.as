package com.kaltura.commands.user
{
	import com.kaltura.delegates.user.UserEnableLoginDelegate;
	import com.kaltura.net.KalturaCall;

	public class UserEnableLogin extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param userId String
		 * @param loginId String
		 * @param password String
		 **/
		public function UserEnableLogin( userId : String,loginId : String,password : String='' )
		{
			service= 'user';
			action= 'enableLogin';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('userId');
			valueArr.push(userId);
			keyArr.push('loginId');
			valueArr.push(loginId);
			keyArr.push('password');
			valueArr.push(password);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new UserEnableLoginDelegate( this , config );
		}
	}
}
