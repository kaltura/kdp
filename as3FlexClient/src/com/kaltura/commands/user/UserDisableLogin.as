package com.kaltura.commands.user
{
	import com.kaltura.delegates.user.UserDisableLoginDelegate;
	import com.kaltura.net.KalturaCall;

	public class UserDisableLogin extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param userId String
		 * @param loginId String
		 **/
		public function UserDisableLogin( userId : String='',loginId : String='' )
		{
			service= 'user';
			action= 'disableLogin';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('userId');
			valueArr.push(userId);
			keyArr.push('loginId');
			valueArr.push(loginId);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new UserDisableLoginDelegate( this , config );
		}
	}
}
