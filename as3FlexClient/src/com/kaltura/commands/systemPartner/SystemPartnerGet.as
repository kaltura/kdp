package com.kaltura.commands.systemPartner
{
	import com.kaltura.delegates.systemPartner.SystemPartnerGetDelegate;
	import com.kaltura.net.KalturaCall;

	public class SystemPartnerGet extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param partnerId int
		 **/
		public function SystemPartnerGet( partnerId : int )
		{
			service= 'systempartner_systempartner';
			action= 'get';

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
			delegate = new SystemPartnerGetDelegate( this , config );
		}
	}
}
