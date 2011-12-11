package com.kaltura.commands.flavorAsset
{
	import com.kaltura.delegates.flavorAsset.FlavorAssetGetWebPlayableByEntryIdDelegate;
	import com.kaltura.net.KalturaCall;

	public class FlavorAssetGetWebPlayableByEntryId extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param entryId String
		 **/
		public function FlavorAssetGetWebPlayableByEntryId( entryId : String )
		{
			service= 'flavorasset';
			action= 'getWebPlayableByEntryId';

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
			delegate = new FlavorAssetGetWebPlayableByEntryIdDelegate( this , config );
		}
	}
}
