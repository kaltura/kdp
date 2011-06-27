package com.kaltura.commands.contentDistributionBatch
{
	import com.kaltura.vo.KalturaMediaInfo;
	import com.kaltura.delegates.contentDistributionBatch.ContentDistributionBatchAddMediaInfoDelegate;
	import com.kaltura.net.KalturaCall;

	public class ContentDistributionBatchAddMediaInfo extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param mediaInfo KalturaMediaInfo
		 **/
		public function ContentDistributionBatchAddMediaInfo( mediaInfo : KalturaMediaInfo )
		{
			service= 'contentdistribution_contentdistributionbatch';
			action= 'addMediaInfo';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
 			keyValArr = kalturaObject2Arrays(mediaInfo, 'mediaInfo');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new ContentDistributionBatchAddMediaInfoDelegate( this , config );
		}
	}
}
