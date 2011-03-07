package com.kaltura.commands.user
{
	import com.kaltura.delegates.user.UserDeleteDelegate;
	import com.kaltura.net.KalturaCall;

	public class UserDelete extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param userId String
		 **/
		public function UserDelete( userId : String )
		{
			service= 'user';
			action= 'delete';

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
			delegate = new UserDeleteDelegate( this , config );
		}
	}
}
