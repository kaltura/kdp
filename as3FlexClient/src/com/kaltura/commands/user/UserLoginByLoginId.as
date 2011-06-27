package com.kaltura.commands.user
{
	import com.kaltura.delegates.user.UserLoginByLoginIdDelegate;
	import com.kaltura.net.KalturaCall;

	public class UserLoginByLoginId extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param loginId String
		 * @param password String
		 * @param partnerId int
		 * @param expiry int
		 * @param privileges String
		 **/
		public function UserLoginByLoginId( loginId : String,password : String,partnerId : int=undefined,expiry : int=86400,privileges : String='*' )
		{
			service= 'user';
			action= 'loginByLoginId';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('loginId');
			valueArr.push(loginId);
			keyArr.push('password');
			valueArr.push(password);
			keyArr.push('partnerId');
			valueArr.push(partnerId);
			keyArr.push('expiry');
			valueArr.push(expiry);
			keyArr.push('privileges');
			valueArr.push(privileges);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new UserLoginByLoginIdDelegate( this , config );
		}
	}
}
