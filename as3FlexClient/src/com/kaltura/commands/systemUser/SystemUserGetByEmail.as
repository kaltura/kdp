package com.kaltura.commands.systemUser
{
	import com.kaltura.delegates.systemUser.SystemUserGetByEmailDelegate;
	import com.kaltura.net.KalturaCall;

	public class SystemUserGetByEmail extends KalturaCall
	{
		public var filterFields : String;
		public function SystemUserGetByEmail( email : String )
		{
			service= 'systemuser_systemuser';
			action= 'getByEmail';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push( 'email' );
			valueArr.push( email );
			applySchema( keyArr , valueArr );
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields',filterFields);
			delegate = new SystemUserGetByEmailDelegate( this , config );
		}
	}
}
