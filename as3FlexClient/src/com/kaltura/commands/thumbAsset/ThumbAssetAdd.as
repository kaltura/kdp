package com.kaltura.commands.thumbAsset
{
	import com.kaltura.vo.KalturaThumbAsset;
	import com.kaltura.delegates.thumbAsset.ThumbAssetAddDelegate;
	import com.kaltura.net.KalturaCall;

	public class ThumbAssetAdd extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param entryId String
		 * @param thumbAsset KalturaThumbAsset
		 **/
		public function ThumbAssetAdd( entryId : String,thumbAsset : KalturaThumbAsset )
		{
			service= 'thumbasset';
			action= 'add';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('entryId');
			valueArr.push(entryId);
 			keyValArr = kalturaObject2Arrays(thumbAsset, 'thumbAsset');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new ThumbAssetAddDelegate( this , config );
		}
	}
}
