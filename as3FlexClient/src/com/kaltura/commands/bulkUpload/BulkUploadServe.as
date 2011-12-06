package com.kaltura.commands.bulkUpload
{
	import com.kaltura.delegates.bulkUpload.BulkUploadServeDelegate;
	import com.kaltura.net.KalturaCall;

	public class BulkUploadServe extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param id int
		 **/
		public function BulkUploadServe( id : int )
		{
			service= 'bulkupload';
			action= 'serve';

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
			delegate = new BulkUploadServeDelegate( this , config );
		}
	}
}
