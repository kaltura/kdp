package com.kaltura.commands.systemPartner
{
	import com.kaltura.delegates.systemPartner.SystemPartnerGetConfigurationDelegate;
	import com.kaltura.net.KalturaCall;

	public class SystemPartnerGetConfiguration extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param partnerId int
		 **/
		public function SystemPartnerGetConfiguration( partnerId : int )
		{
			service= 'systempartner_systempartner';
			action= 'getConfiguration';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('partnerId');
			valueArr.push(partnerId);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new SystemPartnerGetConfigurationDelegate( this , config );
		}
	}
}
