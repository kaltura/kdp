package com.kaltura.commands.EmailIngestionProfile
{
	import com.kaltura.delegates.EmailIngestionProfile.EmailIngestionProfileDeleteDelegate;
	import com.kaltura.net.KalturaCall;

	public class EmailIngestionProfileDelete extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param id int
		 **/
		public function EmailIngestionProfileDelete( id : int )
		{
			service= 'emailingestionprofile';
			action= 'delete';

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
			delegate = new EmailIngestionProfileDeleteDelegate( this , config );
		}
	}
}
