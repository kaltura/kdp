package com.kaltura.commands.thumbAsset
{
	import com.kaltura.vo.KalturaThumbAsset;
	import com.kaltura.delegates.thumbAsset.ThumbAssetUpdateDelegate;
	import com.kaltura.net.KalturaCall;

	public class ThumbAssetUpdate extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param id String
		 * @param thumbAsset KalturaThumbAsset
		 **/
		public function ThumbAssetUpdate( id : String,thumbAsset : KalturaThumbAsset )
		{
			service= 'thumbasset';
			action= 'update';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('id');
			valueArr.push(id);
 			keyValArr = kalturaObject2Arrays(thumbAsset, 'thumbAsset');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new ThumbAssetUpdateDelegate( this , config );
		}
	}
}
