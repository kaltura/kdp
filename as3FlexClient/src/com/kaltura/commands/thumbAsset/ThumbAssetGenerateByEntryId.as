package com.kaltura.commands.thumbAsset
{
	import com.kaltura.delegates.thumbAsset.ThumbAssetGenerateByEntryIdDelegate;
	import com.kaltura.net.KalturaCall;

	public class ThumbAssetGenerateByEntryId extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param entryId String
		 * @param destThumbParamsId int
		 **/
		public function ThumbAssetGenerateByEntryId( entryId : String,destThumbParamsId : int )
		{
			service= 'thumbasset';
			action= 'generateByEntryId';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('entryId');
			valueArr.push(entryId);
			keyArr.push('destThumbParamsId');
			valueArr.push(destThumbParamsId);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new ThumbAssetGenerateByEntryIdDelegate( this , config );
		}
	}
}
