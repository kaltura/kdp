package com.kaltura.commands.thumbAsset
{
	import com.kaltura.delegates.thumbAsset.ThumbAssetDeleteDelegate;
	import com.kaltura.net.KalturaCall;

	public class ThumbAssetDelete extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param thumbAssetId String
		 **/
		public function ThumbAssetDelete( thumbAssetId : String )
		{
			service= 'thumbasset';
			action= 'delete';

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
			delegate = new ThumbAssetDeleteDelegate( this , config );
		}
	}
}
