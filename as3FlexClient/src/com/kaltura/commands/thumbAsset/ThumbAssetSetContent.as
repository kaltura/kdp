package com.kaltura.commands.thumbAsset
{
	import com.kaltura.vo.KalturaContentResource;
	import com.kaltura.delegates.thumbAsset.ThumbAssetSetContentDelegate;
	import com.kaltura.net.KalturaCall;

	public class ThumbAssetSetContent extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param id String
		 * @param contentResource KalturaContentResource
		 **/
		public function ThumbAssetSetContent( id : String,contentResource : KalturaContentResource )
		{
			service= 'thumbasset';
			action= 'setContent';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('id');
			valueArr.push(id);
 			keyValArr = kalturaObject2Arrays(contentResource, 'contentResource');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new ThumbAssetSetContentDelegate( this , config );
		}
	}
}
