package com.kaltura.commands.bulkUpload
{
	import com.kaltura.delegates.bulkUpload.BulkUploadAbortDelegate;
	import com.kaltura.net.KalturaCall;

	public class BulkUploadAbort extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param id int
		 **/
		public function BulkUploadAbort( id : int )
		{
			service= 'bulkupload';
			action= 'abort';

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
			delegate = new BulkUploadAbortDelegate( this , config );
		}
	}
}
