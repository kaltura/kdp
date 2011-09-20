package com.kaltura.commands.user
{
	import com.kaltura.delegates.user.UserLoginDelegate;
	import com.kaltura.net.KalturaCall;

	public class UserLogin extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param partnerId int
		 * @param userId String
		 * @param password String
		 * @param expiry int
		 * @param privileges String
		 **/
		public function UserLogin( partnerId : int,userId : String,password : String,expiry : int=86400,privileges : String='*' )
		{
			service= 'user';
			action= 'login';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('partnerId');
			valueArr.push(partnerId);
			keyArr.push('userId');
			valueArr.push(userId);
			keyArr.push('password');
			valueArr.push(password);
			keyArr.push('expiry');
			valueArr.push(expiry);
			keyArr.push('privileges');
			valueArr.push(privileges);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new UserLoginDelegate( this , config );
		}
	}
}
