package com.kaltura.commands.flavorAsset
{
	import com.kaltura.vo.KalturaFlavorAsset;
	import com.kaltura.delegates.flavorAsset.FlavorAssetUpdateDelegate;
	import com.kaltura.net.KalturaCall;

	public class FlavorAssetUpdate extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param id String
		 * @param flavorAsset KalturaFlavorAsset
		 **/
		public function FlavorAssetUpdate( id : String,flavorAsset : KalturaFlavorAsset )
		{
			service= 'flavorasset';
			action= 'update';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('id');
			valueArr.push(id);
 			keyValArr = kalturaObject2Arrays(flavorAsset, 'flavorAsset');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new FlavorAssetUpdateDelegate( this , config );
		}
	}
}
