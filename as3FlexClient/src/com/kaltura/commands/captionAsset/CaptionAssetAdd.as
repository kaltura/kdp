package com.kaltura.commands.captionAsset
{
	import com.kaltura.vo.KalturaCaptionAsset;
	import com.kaltura.delegates.captionAsset.CaptionAssetAddDelegate;
	import com.kaltura.net.KalturaCall;

	public class CaptionAssetAdd extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param entryId String
		 * @param captionAsset KalturaCaptionAsset
		 **/
		public function CaptionAssetAdd( entryId : String,captionAsset : KalturaCaptionAsset )
		{
			service= 'caption_captionasset';
			action= 'add';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('entryId');
			valueArr.push(entryId);
 			keyValArr = kalturaObject2Arrays(captionAsset, 'captionAsset');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new CaptionAssetAddDelegate( this , config );
		}
	}
}
