package com.kaltura.commands.thumbAsset
{
	import com.kaltura.delegates.thumbAsset.ThumbAssetGetUrlDelegate;
	import com.kaltura.net.KalturaCall;

	public class ThumbAssetGetUrl extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param id String
		 * @param storageId int
		 **/
		public function ThumbAssetGetUrl( id : String,storageId : int=int.MIN_VALUE )
		{
			service= 'thumbasset';
			action= 'getUrl';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('id');
			valueArr.push(id);
			keyArr.push('storageId');
			valueArr.push(storageId);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new ThumbAssetGetUrlDelegate( this , config );
		}
	}
}
