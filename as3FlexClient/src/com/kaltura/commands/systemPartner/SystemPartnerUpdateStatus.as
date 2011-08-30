package com.kaltura.commands.systemPartner
{
	import com.kaltura.delegates.systemPartner.SystemPartnerUpdateStatusDelegate;
	import com.kaltura.net.KalturaCall;

	public class SystemPartnerUpdateStatus extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param partnerId int
		 * @param status int
		 **/
		public function SystemPartnerUpdateStatus( partnerId : int,status : int )
		{
			service= 'systempartner_systempartner';
			action= 'updateStatus';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('partnerId');
			valueArr.push(partnerId);
			keyArr.push('status');
			valueArr.push(status);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new SystemPartnerUpdateStatusDelegate( this , config );
		}
	}
}
