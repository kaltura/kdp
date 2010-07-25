package com.kaltura.commands.session
{
	import com.kaltura.delegates.session.SessionStartDelegate;
	import com.kaltura.net.KalturaCall;

	public class SessionStart extends KalturaCall
	{
		public var filterFields : String;
		public function SessionStart( secret : String,userId : String='',type : int=0,partnerId : int=-1,expiry : int=86400,privileges : String='' )
		{
			service= 'session';
			action= 'start';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push( 'secret' );
			valueArr.push( secret );
			keyArr.push( 'userId' );
			valueArr.push( userId );
			keyArr.push( 'type' );
			valueArr.push( type );
			keyArr.push( 'partnerId' );
			valueArr.push( partnerId );
			keyArr.push( 'expiry' );
			valueArr.push( expiry );
			keyArr.push( 'privileges' );
			valueArr.push( privileges );
			applySchema( keyArr , valueArr );
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields',filterFields);
			delegate = new SessionStartDelegate( this , config );
		}
	}
}
