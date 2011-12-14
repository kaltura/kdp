package com.kaltura.commands.virusScanBatch
{
	import com.kaltura.delegates.virusScanBatch.VirusScanBatchCheckFileExistsDelegate;
	import com.kaltura.net.KalturaCall;

	public class VirusScanBatchCheckFileExists extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param localPath String
		 * @param size int
		 **/
		public function VirusScanBatchCheckFileExists( localPath : String,size : int )
		{
			service= 'virusscan_virusscanbatch';
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
			delegate = new VirusScanBatchCheckFileExistsDelegate( this , config );
		}
	}
}
