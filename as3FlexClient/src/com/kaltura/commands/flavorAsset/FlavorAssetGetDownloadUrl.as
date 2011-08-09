package com.kaltura.commands.flavorAsset
{
	import com.kaltura.delegates.flavorAsset.FlavorAssetGetDownloadUrlDelegate;
	import com.kaltura.net.KalturaCall;

	public class FlavorAssetGetDownloadUrl extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param id String
		 * @param useCdn Boolean
		 **/
		public function FlavorAssetGetDownloadUrl( id : String,useCdn : Boolean=false )
		{
			service= 'flavorasset';
			action= 'getDownloadUrl';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('id');
			valueArr.push(id);
			keyArr.push('useCdn');
			valueArr.push(useCdn);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new FlavorAssetGetDownloadUrlDelegate( this , config );
		}
	}
}
