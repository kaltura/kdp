package com.kaltura.commands.entryAdmin
{
	import com.kaltura.delegates.entryAdmin.EntryAdminGetByFlavorIdDelegate;
	import com.kaltura.net.KalturaCall;

	public class EntryAdminGetByFlavorId extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param flavorId String
		 * @param version int
		 **/
		public function EntryAdminGetByFlavorId( flavorId : String,version : int=-1 )
		{
			service= 'adminconsole_entryadmin';
			action= 'getByFlavorId';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('flavorId');
			valueArr.push(flavorId);
			keyArr.push('version');
			valueArr.push(version);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new EntryAdminGetByFlavorIdDelegate( this , config );
		}
	}
}
