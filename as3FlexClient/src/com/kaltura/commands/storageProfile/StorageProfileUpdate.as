package com.kaltura.commands.storageProfile
{
	import com.kaltura.vo.KalturaStorageProfile;
	import com.kaltura.delegates.storageProfile.StorageProfileUpdateDelegate;
	import com.kaltura.net.KalturaCall;

	public class StorageProfileUpdate extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param storageProfileId int
		 * @param storageProfile KalturaStorageProfile
		 **/
		public function StorageProfileUpdate( storageProfileId : int,storageProfile : KalturaStorageProfile )
		{
			service= 'storageprofile_storageprofile';
			action= 'update';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('storageProfileId');
			valueArr.push(storageProfileId);
 			keyValArr = kalturaObject2Arrays(storageProfile, 'storageProfile');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new StorageProfileUpdateDelegate( this , config );
		}
	}
}
