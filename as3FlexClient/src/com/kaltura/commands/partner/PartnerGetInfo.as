package com.kaltura.commands.partner
{
	import com.kaltura.delegates.partner.PartnerGetInfoDelegate;
	import com.kaltura.net.KalturaCall;

	public class PartnerGetInfo extends KalturaCall
	{
		public var filterFields : String;
		/**
		 **/
		public function PartnerGetInfo(  )
		{
			service= 'partner';
			action= 'getInfo';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new PartnerGetInfoDelegate( this , config );
		}
	}
}
