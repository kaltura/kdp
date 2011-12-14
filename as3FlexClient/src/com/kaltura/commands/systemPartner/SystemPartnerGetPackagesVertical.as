package com.kaltura.commands.systemPartner
{
	import com.kaltura.delegates.systemPartner.SystemPartnerGetPackagesVerticalDelegate;
	import com.kaltura.net.KalturaCall;

	public class SystemPartnerGetPackagesVertical extends KalturaCall
	{
		public var filterFields : String;
		/**
		 **/
		public function SystemPartnerGetPackagesVertical(  )
		{
			service= 'systempartner_systempartner';
			action= 'getPackagesVertical';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new SystemPartnerGetPackagesVerticalDelegate( this , config );
		}
	}
}
