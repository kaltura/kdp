package com.kaltura.commands.systemPartner
{
	import com.kaltura.delegates.systemPartner.SystemPartnerGetPackagesDelegate;
	import com.kaltura.net.KalturaCall;

	public class SystemPartnerGetPackages extends KalturaCall
	{
		public var filterFields : String;
		/**
		 **/
		public function SystemPartnerGetPackages(  )
		{
			service= 'systempartner_systempartner';
			action= 'getPackages';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new SystemPartnerGetPackagesDelegate( this , config );
		}
	}
}
