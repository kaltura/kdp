package com.kaltura.commands.captionAsset
{
	import com.kaltura.delegates.captionAsset.CaptionAssetServeDelegate;
	import com.kaltura.net.KalturaCall;

	public class CaptionAssetServe extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param captionAssetId String
		 **/
		public function CaptionAssetServe( captionAssetId : String )
		{
			service= 'caption_captionasset';
			action= 'serve';

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
			delegate = new CaptionAssetServeDelegate( this , config );
		}
	}
}
