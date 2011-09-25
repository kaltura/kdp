package com.kaltura.commands.flavorAsset
{
	import com.kaltura.delegates.flavorAsset.FlavorAssetGetByEntryIdDelegate;
	import com.kaltura.net.KalturaCall;

	public class FlavorAssetGetByEntryId extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param entryId String
		 **/
		public function FlavorAssetGetByEntryId( entryId : String )
		{
			service= 'flavorasset';
			action= 'getByEntryId';

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
			delegate = new FlavorAssetGetByEntryIdDelegate( this , config );
		}
	}
}
