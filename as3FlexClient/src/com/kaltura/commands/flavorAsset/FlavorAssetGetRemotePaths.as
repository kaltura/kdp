package com.kaltura.commands.flavorAsset
{
	import com.kaltura.delegates.flavorAsset.FlavorAssetGetRemotePathsDelegate;
	import com.kaltura.net.KalturaCall;

	public class FlavorAssetGetRemotePaths extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param id String
		 **/
		public function FlavorAssetGetRemotePaths( id : String )
		{
			service= 'flavorasset';
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
			delegate = new FlavorAssetGetRemotePathsDelegate( this , config );
		}
	}
}
