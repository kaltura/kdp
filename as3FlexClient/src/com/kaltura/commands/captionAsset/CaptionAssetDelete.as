package com.kaltura.commands.captionAsset
{
	import com.kaltura.delegates.captionAsset.CaptionAssetDeleteDelegate;
	import com.kaltura.net.KalturaCall;

	public class CaptionAssetDelete extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param captionAssetId String
		 **/
		public function CaptionAssetDelete( captionAssetId : String )
		{
			service= 'caption_captionasset';
			action= 'delete';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('captionAssetId');
			valueArr.push(captionAssetId);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new CaptionAssetDeleteDelegate( this , config );
		}
	}
}
