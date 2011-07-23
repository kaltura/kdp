package com.kaltura.commands.document
{
	import com.kaltura.delegates.document.DocumentConvertPptToSwfDelegate;
	import com.kaltura.net.KalturaCall;

	public class DocumentConvertPptToSwf extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param entryId String
		 **/
		public function DocumentConvertPptToSwf( entryId : String )
		{
			service= 'document';
			action= 'convertPptToSwf';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('entryId');
			valueArr.push(entryId);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new DocumentConvertPptToSwfDelegate( this , config );
		}
	}
}
