package com.kaltura.commands.flavorAsset
{
	import com.kaltura.vo.KalturaFlavorAsset;
	import com.kaltura.delegates.flavorAsset.FlavorAssetAddDelegate;
	import com.kaltura.net.KalturaCall;

	public class FlavorAssetAdd extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param entryId String
		 * @param flavorAsset KalturaFlavorAsset
		 **/
		public function FlavorAssetAdd( entryId : String,flavorAsset : KalturaFlavorAsset )
		{
			service= 'flavorasset';
			action= 'add';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('entryId');
			valueArr.push(entryId);
 			keyValArr = kalturaObject2Arrays(flavorAsset, 'flavorAsset');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new FlavorAssetAddDelegate( this , config );
		}
	}
}
