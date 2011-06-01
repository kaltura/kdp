package com.kaltura.commands.thumbAsset
{
	import com.kaltura.delegates.thumbAsset.ThumbAssetAddFromUrlDelegate;
	import com.kaltura.net.KalturaCall;

	public class ThumbAssetAddFromUrl extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param entryId String
		 * @param url String
		 **/
		public function ThumbAssetAddFromUrl( entryId : String,url : String )
		{
			service= 'thumbasset';
			action= 'addFromUrl';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('entryId');
			valueArr.push(entryId);
			keyArr.push('url');
			valueArr.push(url);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new ThumbAssetAddFromUrlDelegate( this , config );
		}
	}
}
