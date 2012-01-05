package com.kaltura.commands.document
{
	import com.kaltura.delegates.document.DocumentDeleteDelegate;
	import com.kaltura.net.KalturaCall;

	public class DocumentDelete extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param entryId String
		 **/
		public function DocumentDelete( entryId : String )
		{
			service= 'document';
			action= 'delete';

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
			delegate = new DocumentDeleteDelegate( this , config );
		}
	}
}
