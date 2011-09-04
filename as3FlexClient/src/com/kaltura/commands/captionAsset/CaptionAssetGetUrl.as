package com.kaltura.commands.captionAsset
{
	import com.kaltura.delegates.captionAsset.CaptionAssetGetUrlDelegate;
	import com.kaltura.net.KalturaCall;

	public class CaptionAssetGetUrl extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param id String
		 * @param storageId int
		 **/
		public function CaptionAssetGetUrl( id : String,storageId : int=int.MIN_VALUE )
		{
			service= 'caption_captionasset';
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
			delegate = new CaptionAssetGetUrlDelegate( this , config );
		}
	}
}
