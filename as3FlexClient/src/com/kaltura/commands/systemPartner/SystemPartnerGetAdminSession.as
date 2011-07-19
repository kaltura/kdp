package com.kaltura.commands.systemPartner
{
	import com.kaltura.delegates.systemPartner.SystemPartnerGetAdminSessionDelegate;
	import com.kaltura.net.KalturaCall;

	public class SystemPartnerGetAdminSession extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param partnerId int
		 * @param userId String
		 **/
		public function SystemPartnerGetAdminSession( partnerId : int,userId : String='' )
		{
			service= 'systempartner_systempartner';
			action= 'getAdminSession';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('partnerId');
			valueArr.push(partnerId);
			keyArr.push('userId');
			valueArr.push(userId);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new SystemPartnerGetAdminSessionDelegate( this , config );
		}
	}
}
