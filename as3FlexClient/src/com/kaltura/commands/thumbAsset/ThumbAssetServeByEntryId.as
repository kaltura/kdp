package com.kaltura.commands.thumbAsset
{
	import com.kaltura.delegates.thumbAsset.ThumbAssetServeByEntryIdDelegate;
	import com.kaltura.net.KalturaCall;

	public class ThumbAssetServeByEntryId extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param entryId String
		 * @param thumbParamId int
		 **/
		public function ThumbAssetServeByEntryId( entryId : String,thumbParamId : int=int.MIN_VALUE )
		{
			service= 'thumbasset';
			action= 'serveByEntryId';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('entryId');
			valueArr.push(entryId);
			keyArr.push('thumbParamId');
			valueArr.push(thumbParamId);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new ThumbAssetServeByEntryIdDelegate( this , config );
		}
	}
}
