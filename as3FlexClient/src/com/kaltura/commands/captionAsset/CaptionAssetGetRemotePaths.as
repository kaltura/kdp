package com.kaltura.commands.captionAsset
{
	import com.kaltura.delegates.captionAsset.CaptionAssetGetRemotePathsDelegate;
	import com.kaltura.net.KalturaCall;

	public class CaptionAssetGetRemotePaths extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param id String
		 **/
		public function CaptionAssetGetRemotePaths( id : String )
		{
			service= 'caption_captionasset';
			action= 'getRemotePaths';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('id');
			valueArr.push(id);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new CaptionAssetGetRemotePathsDelegate( this , config );
		}
	}
}
