package com.kaltura.commands.corputils
{
	import com.kaltura.delegates.corputils.CorputilsAdSupportOptInDelegate;
	import com.kaltura.net.KalturaCall;

	public class CorputilsAdSupportOptIn extends KalturaCall
	{
		public var filterFields : String;
		public function CorputilsAdSupportOptIn( partner_id : int,emailHashString : String )
		{
			service= 'corputils_corputils';
			action= 'adSupportOptIn';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push( 'partner_id' );
			valueArr.push( partner_id );
			keyArr.push( 'emailHashString' );
			valueArr.push( emailHashString );
			applySchema( keyArr , valueArr );
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields',filterFields);
			delegate = new CorputilsAdSupportOptInDelegate( this , config );
		}
	}
}
