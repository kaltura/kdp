package com.kaltura.commands.session
{
	import com.kaltura.delegates.session.SessionImpersonateDelegate;
	import com.kaltura.net.KalturaCall;

	public class SessionImpersonate extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param secret String
		 * @param impersonatedPartnerId int
		 * @param userId String
		 * @param type int
		 * @param partnerId int
		 * @param expiry int
		 * @param privileges String
		 **/
		public function SessionImpersonate( secret : String,impersonatedPartnerId : int,userId : String='',type : int=0,partnerId : int=undefined,expiry : int=86400,privileges : String='' )
		{
			service= 'session';
			action= 'impersonate';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('secret');
			valueArr.push(secret);
			keyArr.push('impersonatedPartnerId');
			valueArr.push(impersonatedPartnerId);
			keyArr.push('userId');
			valueArr.push(userId);
			keyArr.push('type');
			valueArr.push(type);
			keyArr.push('partnerId');
			valueArr.push(partnerId);
			keyArr.push('expiry');
			valueArr.push(expiry);
			keyArr.push('privileges');
			valueArr.push(privileges);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new SessionImpersonateDelegate( this , config );
		}
	}
}
