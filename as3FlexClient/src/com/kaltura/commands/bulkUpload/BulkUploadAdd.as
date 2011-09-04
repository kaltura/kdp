package com.kaltura.commands.bulkUpload
{
	import flash.net.FileReference;
	import com.kaltura.net.KalturaFileCall;
	import com.kaltura.delegates.bulkUpload.BulkUploadAddDelegate;

	public class BulkUploadAdd extends KalturaFileCall
	{
		public var csvFileData:Object;

		/**
		 * @param conversionProfileId int
		 * @param csvFileData Object - FileReference or ByteArray
		 * @param bulkUploadType String
		 * @param uploadedBy String
		 **/
		public function BulkUploadAdd( conversionProfileId : int,csvFileData : Object,bulkUploadType : String = null,uploadedBy : String = null )
		{
			service= 'bulkupload';
			action= 'add';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('conversionProfileId');
			valueArr.push(conversionProfileId);
			this.csvFileData = csvFileData;
			keyArr.push('bulkUploadType');
			valueArr.push(bulkUploadType);
			keyArr.push('uploadedBy');
			valueArr.push(uploadedBy);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new BulkUploadAddDelegate( this , config );
		}
	}
}
