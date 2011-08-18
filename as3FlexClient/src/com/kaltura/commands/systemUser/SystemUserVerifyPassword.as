package com.kaltura.commands.systemUser
{
	import com.kaltura.delegates.systemUser.SystemUserVerifyPasswordDelegate;
	import com.kaltura.net.KalturaCall;

	public class SystemUserVerifyPassword extends KalturaCall
	{
		public var filterFields : String;
		public function SystemUserVerifyPassword( email : String,password : String )
		{
			service= 'systemuser_systemuser';
			action= 'verifyPassword';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push( 'email' );
			valueArr.push( email );
			keyArr.push( 'password' );
			valueArr.push( password );
			applySchema( keyArr , valueArr );
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields',filterFields);
			delegate = new SystemUserVerifyPasswordDelegate( this , config );
		}
	}
}
