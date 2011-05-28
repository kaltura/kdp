package com.kaltura.commands.storageProfile
{
	import com.kaltura.delegates.storageProfile.StorageProfileUpdateStatusDelegate;
	import com.kaltura.net.KalturaCall;

	public class StorageProfileUpdateStatus extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param storageId int
		 * @param status int
		 **/
		public function StorageProfileUpdateStatus( storageId : int,status : int )
		{
			service= 'storageprofile_storageprofile';
			action= 'updateStatus';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('storageId');
			valueArr.push(storageId);
			keyArr.push('status');
			valueArr.push(status);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new StorageProfileUpdateStatusDelegate( this , config );
		}
	}
}
