package com.kaltura.commands.thumbAsset
{
	import com.kaltura.delegates.thumbAsset.ThumbAssetGetDelegate;
	import com.kaltura.net.KalturaCall;

	public class ThumbAssetGet extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param thumbAssetId String
		 **/
		public function ThumbAssetGet( thumbAssetId : String )
		{
			service= 'thumbasset';
			action= 'get';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('thumbAssetId');
			valueArr.push(thumbAssetId);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new ThumbAssetGetDelegate( this , config );
		}
	}
}
