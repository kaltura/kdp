package com.kaltura.commands.user
{
	import com.kaltura.delegates.user.UserGetByLoginIdDelegate;
	import com.kaltura.net.KalturaCall;

	public class UserGetByLoginId extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param loginId String
		 **/
		public function UserGetByLoginId( loginId : String )
		{
			service= 'user';
			action= 'getByLoginId';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('loginId');
			valueArr.push(loginId);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new UserGetByLoginIdDelegate( this , config );
		}
	}
}
