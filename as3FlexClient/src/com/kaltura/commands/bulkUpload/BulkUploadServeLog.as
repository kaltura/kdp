package com.kaltura.commands.bulkUpload
{
	import com.kaltura.delegates.bulkUpload.BulkUploadServeLogDelegate;
	import com.kaltura.net.KalturaCall;

	public class BulkUploadServeLog extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param id int
		 **/
		public function BulkUploadServeLog( id : int )
		{
			service= 'bulkupload';
			action= 'serveLog';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('id');
			valueArr.push(id);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new BulkUploadServeLogDelegate( this , config );
		}
	}
}
