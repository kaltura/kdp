package com.kaltura.commands.captionAsset
{
	import com.kaltura.delegates.captionAsset.CaptionAssetServeByEntryIdDelegate;
	import com.kaltura.net.KalturaCall;

	public class CaptionAssetServeByEntryId extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param entryId String
		 * @param captionParamId int
		 **/
		public function CaptionAssetServeByEntryId( entryId : String,captionParamId : int=int.MIN_VALUE )
		{
			service= 'caption_captionasset';
			action= 'serveByEntryId';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('entryId');
			valueArr.push(entryId);
			keyArr.push('captionParamId');
			valueArr.push(captionParamId);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new CaptionAssetServeByEntryIdDelegate( this , config );
		}
	}
}
