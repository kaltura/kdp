package com.kaltura.commands.xInternal
{
	import com.kaltura.delegates.xInternal.XInternalXAddBulkDownloadDelegate;
	import com.kaltura.net.KalturaCall;

	public class XInternalXAddBulkDownload extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param entryIds String
		 * @param flavorParamsId String
		 **/
		public function XInternalXAddBulkDownload( entryIds : String,flavorParamsId : String='' )
		{
			service= 'xinternal';
			action= 'xAddBulkDownload';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('entryIds');
			valueArr.push(entryIds);
			keyArr.push('flavorParamsId');
			valueArr.push(flavorParamsId);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new XInternalXAddBulkDownloadDelegate( this , config );
		}
	}
}
