package com.kaltura.commands.flavorAsset
{
	import com.kaltura.delegates.flavorAsset.FlavorAssetReconvertDelegate;
	import com.kaltura.net.KalturaCall;

	public class FlavorAssetReconvert extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param id String
		 **/
		public function FlavorAssetReconvert( id : String )
		{
			service= 'flavorasset';
			action= 'reconvert';

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
			delegate = new FlavorAssetReconvertDelegate( this , config );
		}
	}
}
