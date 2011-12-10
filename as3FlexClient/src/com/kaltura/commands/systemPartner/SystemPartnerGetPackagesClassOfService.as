package com.kaltura.commands.systemPartner
{
	import com.kaltura.delegates.systemPartner.SystemPartnerGetPackagesClassOfServiceDelegate;
	import com.kaltura.net.KalturaCall;

	public class SystemPartnerGetPackagesClassOfService extends KalturaCall
	{
		public var filterFields : String;
		/**
		 **/
		public function SystemPartnerGetPackagesClassOfService(  )
		{
			service= 'systempartner_systempartner';
			action= 'getPackagesClassOfService';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new SystemPartnerGetPackagesClassOfServiceDelegate( this , config );
		}
	}
}
