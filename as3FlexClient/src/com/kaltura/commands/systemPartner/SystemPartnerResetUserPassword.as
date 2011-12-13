package com.kaltura.commands.systemPartner
{
	import com.kaltura.delegates.systemPartner.SystemPartnerResetUserPasswordDelegate;
	import com.kaltura.net.KalturaCall;

	public class SystemPartnerResetUserPassword extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param userId String
		 * @param partnerId int
		 * @param newPassword String
		 **/
		public function SystemPartnerResetUserPassword( userId : String,partnerId : int,newPassword : String )
		{
			service= 'systempartner_systempartner';
			action= 'resetUserPassword';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('userId');
			valueArr.push(userId);
			keyArr.push('partnerId');
			valueArr.push(partnerId);
			keyArr.push('newPassword');
			valueArr.push(newPassword);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new SystemPartnerResetUserPasswordDelegate( this , config );
		}
	}
}
