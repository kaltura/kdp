package com.kaltura.commands.captionAsset
{
	import com.kaltura.vo.KalturaCaptionAsset;
	import com.kaltura.delegates.captionAsset.CaptionAssetUpdateDelegate;
	import com.kaltura.net.KalturaCall;

	public class CaptionAssetUpdate extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param id String
		 * @param captionAsset KalturaCaptionAsset
		 **/
		public function CaptionAssetUpdate( id : String,captionAsset : KalturaCaptionAsset )
		{
			service= 'caption_captionasset';
			action= 'update';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('id');
			valueArr.push(id);
 			keyValArr = kalturaObject2Arrays(captionAsset, 'captionAsset');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new CaptionAssetUpdateDelegate( this , config );
		}
	}
}
