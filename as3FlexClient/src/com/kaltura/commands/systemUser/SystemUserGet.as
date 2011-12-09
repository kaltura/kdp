package com.kaltura.commands.systemUser
{
	import com.kaltura.delegates.systemUser.SystemUserGetDelegate;
	import com.kaltura.net.KalturaCall;

	public class SystemUserGet extends KalturaCall
	{
		public var filterFields : String;
		public function SystemUserGet( userId : int )
		{
			service= 'systemuser_systemuser';
			action= 'get';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push( 'userId' );
			valueArr.push( userId );
			applySchema( keyArr , valueArr );
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields',filterFields);
			delegate = new SystemUserGetDelegate( this , config );
		}
	}
}
