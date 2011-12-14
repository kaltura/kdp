package com.kaltura.commands.thumbAsset
{
	import com.kaltura.delegates.thumbAsset.ThumbAssetGetRemotePathsDelegate;
	import com.kaltura.net.KalturaCall;

	public class ThumbAssetGetRemotePaths extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param id String
		 **/
		public function ThumbAssetGetRemotePaths( id : String )
		{
			service= 'thumbasset';
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
			delegate = new ThumbAssetGetRemotePathsDelegate( this , config );
		}
	}
}
