package com.kaltura.commands.document
{
	import com.kaltura.delegates.document.DocumentServeDelegate;
	import com.kaltura.net.KalturaCall;

	public class DocumentServe extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param entryId String
		 * @param flavorAssetId String
		 * @param forceProxy Boolean
		 **/
		public function DocumentServe( entryId : String,flavorAssetId : String = null,forceProxy : Boolean=false )
		{
			service= 'document';
			action= 'serve';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('entryId');
			valueArr.push(entryId);
			keyArr.push('flavorAssetId');
			valueArr.push(flavorAssetId);
			keyArr.push('forceProxy');
			valueArr.push(forceProxy);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new DocumentServeDelegate( this , config );
		}
	}
}
