package com.kaltura.commands.document
{
	import com.kaltura.delegates.document.DocumentGetDelegate;
	import com.kaltura.net.KalturaCall;

	public class DocumentGet extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param entryId String
		 * @param version int
		 **/
		public function DocumentGet( entryId : String,version : int=-1 )
		{
			service= 'document';
			action= 'get';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('entryId');
			valueArr.push(entryId);
			keyArr.push('version');
			valueArr.push(version);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new DocumentGetDelegate( this , config );
		}
	}
}
