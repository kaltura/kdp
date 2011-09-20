package com.kaltura.commands.storageProfile
{
	import com.kaltura.delegates.storageProfile.StorageProfileGetDelegate;
	import com.kaltura.net.KalturaCall;

	public class StorageProfileGet extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param storageProfileId int
		 **/
		public function StorageProfileGet( storageProfileId : int )
		{
			service= 'storageprofile_storageprofile';
			action= 'get';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('storageProfileId');
			valueArr.push(storageProfileId);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new StorageProfileGetDelegate( this , config );
		}
	}
}
