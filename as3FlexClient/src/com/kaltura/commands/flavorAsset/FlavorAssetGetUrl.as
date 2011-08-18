package com.kaltura.commands.flavorAsset
{
	import com.kaltura.delegates.flavorAsset.FlavorAssetGetUrlDelegate;
	import com.kaltura.net.KalturaCall;

	public class FlavorAssetGetUrl extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param id String
		 * @param storageId int
		 **/
		public function FlavorAssetGetUrl( id : String,storageId : int=int.MIN_VALUE )
		{
			service= 'flavorasset';
			action= 'getUrl';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('id');
			valueArr.push(id);
			keyArr.push('storageId');
			valueArr.push(storageId);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new FlavorAssetGetUrlDelegate( this , config );
		}
	}
}
