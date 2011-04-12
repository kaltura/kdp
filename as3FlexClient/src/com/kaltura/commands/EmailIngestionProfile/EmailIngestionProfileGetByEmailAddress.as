package com.kaltura.commands.EmailIngestionProfile
{
	import com.kaltura.delegates.EmailIngestionProfile.EmailIngestionProfileGetByEmailAddressDelegate;
	import com.kaltura.net.KalturaCall;

	public class EmailIngestionProfileGetByEmailAddress extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param emailAddress String
		 **/
		public function EmailIngestionProfileGetByEmailAddress( emailAddress : String )
		{
			service= 'emailingestionprofile';
			action= 'getByEmailAddress';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('emailAddress');
			valueArr.push(emailAddress);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new EmailIngestionProfileGetByEmailAddressDelegate( this , config );
		}
	}
}
