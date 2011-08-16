package com.kaltura.commands.entryAdmin
{
	import com.kaltura.delegates.entryAdmin.EntryAdminGetTracksDelegate;
	import com.kaltura.net.KalturaCall;

	public class EntryAdminGetTracks extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param entryId String
		 **/
		public function EntryAdminGetTracks( entryId : String )
		{
			service= 'adminconsole_entryadmin';
			action= 'getTracks';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('entryId');
			valueArr.push(entryId);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new EntryAdminGetTracksDelegate( this , config );
		}
	}
}
