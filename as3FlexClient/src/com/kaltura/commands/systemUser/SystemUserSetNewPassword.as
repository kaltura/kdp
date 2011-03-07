package com.kaltura.commands.systemUser
{
	import com.kaltura.delegates.systemUser.SystemUserSetNewPasswordDelegate;
	import com.kaltura.net.KalturaCall;

	public class SystemUserSetNewPassword extends KalturaCall
	{
		public var filterFields : String;
		public function SystemUserSetNewPassword( userId : int,password : String )
		{
			service= 'systemuser_systemuser';
			action= 'setNewPassword';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push( 'userId' );
			valueArr.push( userId );
			keyArr.push( 'password' );
			valueArr.push( password );
			applySchema( keyArr , valueArr );
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields',filterFields);
			delegate = new SystemUserSetNewPasswordDelegate( this , config );
		}
	}
}
