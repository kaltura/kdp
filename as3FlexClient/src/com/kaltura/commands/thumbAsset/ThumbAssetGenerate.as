package com.kaltura.commands.thumbAsset
{
	import com.kaltura.vo.KalturaThumbParams;
	import com.kaltura.delegates.thumbAsset.ThumbAssetGenerateDelegate;
	import com.kaltura.net.KalturaCall;

	public class ThumbAssetGenerate extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param entryId String
		 * @param thumbParams KalturaThumbParams
		 * @param sourceAssetId String
		 **/
		public function ThumbAssetGenerate( entryId : String,thumbParams : KalturaThumbParams,sourceAssetId : String='' )
		{
			service= 'thumbasset';
			action= 'generate';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('entryId');
			valueArr.push(entryId);
 			keyValArr = kalturaObject2Arrays(thumbParams, 'thumbParams');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			keyArr.push('sourceAssetId');
			valueArr.push(sourceAssetId);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new ThumbAssetGenerateDelegate( this , config );
		}
	}
}
