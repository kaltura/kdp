package com.kaltura.commands.user
{
	import com.kaltura.vo.KalturaUser;
	import com.kaltura.delegates.user.UserAddDelegate;
	import com.kaltura.net.KalturaCall;

	public class UserAdd extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param user KalturaUser
		 **/
		public function UserAdd( user : KalturaUser )
		{
			service= 'user';
			action= 'add';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
 			keyValArr = kalturaObject2Arrays(user, 'user');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new UserAddDelegate( this , config );
		}
	}
}
