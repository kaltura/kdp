package com.kaltura.commands.systemUser
{
	import com.kaltura.delegates.systemUser.SystemUserGenerateNewPasswordDelegate;
	import com.kaltura.net.KalturaCall;

	public class SystemUserGenerateNewPassword extends KalturaCall
	{
		public var filterFields : String;
		public function SystemUserGenerateNewPassword(  )
		{
			service= 'systemuser_systemuser';
			action= 'generateNewPassword';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			applySchema( keyArr , valueArr );
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields',filterFields);
			delegate = new SystemUserGenerateNewPasswordDelegate( this , config );
		}
	}
}
