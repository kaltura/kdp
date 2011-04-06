package com.kaltura.commands.entryAdmin
{
	import com.kaltura.delegates.entryAdmin.EntryAdminGetDelegate;
	import com.kaltura.net.KalturaCall;

	public class EntryAdminGet extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param entryId String
		 * @param version int
		 **/
		public function EntryAdminGet( entryId : String,version : int=-1 )
		{
			service= 'adminconsole_entryadmin';
			action= 'get';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('entryId');
			valueArr.push(entryId);
			keyArr.push('version');
			valueArr.push(version);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new EntryAdminGetDelegate( this , config );
		}
	}
}
