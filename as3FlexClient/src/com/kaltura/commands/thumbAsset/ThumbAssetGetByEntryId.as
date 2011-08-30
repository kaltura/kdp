package com.kaltura.commands.thumbAsset
{
	import com.kaltura.delegates.thumbAsset.ThumbAssetGetByEntryIdDelegate;
	import com.kaltura.net.KalturaCall;

	public class ThumbAssetGetByEntryId extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param entryId String
		 **/
		public function ThumbAssetGetByEntryId( entryId : String )
		{
			service= 'thumbasset';
			action= 'getByEntryId';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('entryId');
			valueArr.push(entryId);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new ThumbAssetGetByEntryIdDelegate( this , config );
		}
	}
}
