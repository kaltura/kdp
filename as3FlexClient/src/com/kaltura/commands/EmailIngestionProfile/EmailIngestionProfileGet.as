package com.kaltura.commands.EmailIngestionProfile
{
	import com.kaltura.delegates.EmailIngestionProfile.EmailIngestionProfileGetDelegate;
	import com.kaltura.net.KalturaCall;

	public class EmailIngestionProfileGet extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param id int
		 **/
		public function EmailIngestionProfileGet( id : int )
		{
			service= 'emailingestionprofile';
			action= 'get';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('id');
			valueArr.push(id);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new EmailIngestionProfileGetDelegate( this , config );
		}
	}
}
