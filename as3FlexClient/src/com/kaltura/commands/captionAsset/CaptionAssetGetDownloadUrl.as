package com.kaltura.commands.captionAsset
{
	import com.kaltura.delegates.captionAsset.CaptionAssetGetDownloadUrlDelegate;
	import com.kaltura.net.KalturaCall;

	public class CaptionAssetGetDownloadUrl extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param id String
		 * @param useCdn Boolean
		 **/
		public function CaptionAssetGetDownloadUrl( id : String,useCdn : Boolean=false )
		{
			service= 'caption_captionasset';
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
			delegate = new CaptionAssetGetDownloadUrlDelegate( this , config );
		}
	}
}
