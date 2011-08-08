package com.kaltura.commands.storageProfile
{
	import com.kaltura.vo.KalturaStorageProfile;
	import com.kaltura.delegates.storageProfile.StorageProfileAddDelegate;
	import com.kaltura.net.KalturaCall;

	public class StorageProfileAdd extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param storageProfile KalturaStorageProfile
		 **/
		public function StorageProfileAdd( storageProfile : KalturaStorageProfile )
		{
			service= 'storageprofile_storageprofile';
			action= 'add';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
 			keyValArr = kalturaObject2Arrays(storageProfile, 'storageProfile');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new StorageProfileAddDelegate( this , config );
		}
	}
}
