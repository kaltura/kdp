package com.kaltura.commands.systemPartner
{
	import com.kaltura.vo.KalturaSystemPartnerConfiguration;
	import com.kaltura.delegates.systemPartner.SystemPartnerUpdateConfigurationDelegate;
	import com.kaltura.net.KalturaCall;

	public class SystemPartnerUpdateConfiguration extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param partnerId int
		 * @param configuration KalturaSystemPartnerConfiguration
		 **/
		public function SystemPartnerUpdateConfiguration( partnerId : int,configuration : KalturaSystemPartnerConfiguration )
		{
			service= 'systempartner_systempartner';
			action= 'updateConfiguration';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('partnerId');
			valueArr.push(partnerId);
 			keyValArr = kalturaObject2Arrays(configuration, 'configuration');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new SystemPartnerUpdateConfigurationDelegate( this , config );
		}
	}
}
