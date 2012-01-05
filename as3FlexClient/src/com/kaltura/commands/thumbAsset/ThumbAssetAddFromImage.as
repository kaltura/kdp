package com.kaltura.commands.thumbAsset
{
	import flash.net.FileReference;
	import com.kaltura.net.KalturaFileCall;
	import com.kaltura.delegates.thumbAsset.ThumbAssetAddFromImageDelegate;

	public class ThumbAssetAddFromImage extends KalturaFileCall
	{
		public var fileData:Object;

		/**
		 * @param entryId String
		 * @param fileData Object - FileReference or ByteArray
		 **/
		public function ThumbAssetAddFromImage( entryId : String,fileData : Object )
		{
			service= 'thumbasset';
			action= 'addFromImage';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('entryId');
			valueArr.push(entryId);
			this.fileData = fileData;
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new ThumbAssetAddFromImageDelegate( this , config );
		}
	}
}
