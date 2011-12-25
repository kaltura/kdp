package com.kaltura.commands.user
{
	import com.kaltura.delegates.user.UserNotifyBanDelegate;
	import com.kaltura.net.KalturaCall;

	public class UserNotifyBan extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param userId String
		 **/
		public function UserNotifyBan( userId : String )
		{
			service= 'user';
			action= 'notifyBan';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('userId');
			valueArr.push(userId);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new UserNotifyBanDelegate( this , config );
		}
	}
}
