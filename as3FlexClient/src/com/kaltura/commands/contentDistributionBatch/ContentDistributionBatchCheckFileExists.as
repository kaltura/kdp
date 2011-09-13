package com.kaltura.commands.contentDistributionBatch
{
	import com.kaltura.delegates.contentDistributionBatch.ContentDistributionBatchCheckFileExistsDelegate;
	import com.kaltura.net.KalturaCall;

	public class ContentDistributionBatchCheckFileExists extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param localPath String
		 * @param size int
		 **/
		public function ContentDistributionBatchCheckFileExists( localPath : String,size : int )
		{
			service= 'contentdistribution_contentdistributionbatch';
			action= 'checkFileExists';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('localPath');
			valueArr.push(localPath);
			keyArr.push('size');
			valueArr.push(size);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new ContentDistributionBatchCheckFileExistsDelegate( this , config );
		}
	}
}
