package com.kaltura.commands.flavorAsset
{
	import com.kaltura.delegates.flavorAsset.FlavorAssetGetFlavorAssetsWithParamsDelegate;
	import com.kaltura.net.KalturaCall;

	public class FlavorAssetGetFlavorAssetsWithParams extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param entryId String
		 **/
		public function FlavorAssetGetFlavorAssetsWithParams( entryId : String )
		{
			service= 'flavorasset';
			action= 'getFlavorAssetsWithParams';

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
			delegate = new FlavorAssetGetFlavorAssetsWithParamsDelegate( this , config );
		}
	}
}
