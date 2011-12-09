package com.kaltura.commands.flavorAsset
{
	import com.kaltura.delegates.flavorAsset.FlavorAssetGetDelegate;
	import com.kaltura.net.KalturaCall;

	public class FlavorAssetGet extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param id String
		 **/
		public function FlavorAssetGet( id : String )
		{
			service= 'flavorasset';
			action= 'get';

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
			delegate = new FlavorAssetGetDelegate( this , config );
		}
	}
}
