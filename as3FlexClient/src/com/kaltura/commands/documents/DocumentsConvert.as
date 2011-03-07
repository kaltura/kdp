package com.kaltura.commands.documents
{
	import com.kaltura.delegates.documents.DocumentsConvertDelegate;
	import com.kaltura.net.KalturaCall;

	public class DocumentsConvert extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param entryId String
		 * @param conversionProfileId int
		 * @param dynamicConversionAttributes Array
		 **/
		public function DocumentsConvert( entryId : String,conversionProfileId : int=undefined,dynamicConversionAttributes : Array=null )
		{
			if(dynamicConversionAttributes== null)dynamicConversionAttributes= new Array();
			service= 'document_documents';
			action= 'convert';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('entryId');
			valueArr.push(entryId);
			keyArr.push('conversionProfileId');
			valueArr.push(conversionProfileId);
 			keyValArr = extractArray(dynamicConversionAttributes,'dynamicConversionAttributes');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new DocumentsConvertDelegate( this , config );
		}
	}
}
