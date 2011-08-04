package com.kaltura.commands.captionAsset
{
	import com.kaltura.delegates.captionAsset.CaptionAssetGetDelegate;
	import com.kaltura.net.KalturaCall;

	public class CaptionAssetGet extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param captionAssetId String
		 **/
		public function CaptionAssetGet( captionAssetId : String )
		{
			service= 'caption_captionasset';
			action= 'get';

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
			delegate = new CaptionAssetGetDelegate( this , config );
		}
	}
}
