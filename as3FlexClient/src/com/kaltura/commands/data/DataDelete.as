package com.kaltura.commands.data
{
	import com.kaltura.delegates.data.DataDeleteDelegate;
	import com.kaltura.net.KalturaCall;

	public class DataDelete extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param entryId String
		 **/
		public function DataDelete( entryId : String )
		{
			service= 'data';
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
			delegate = new DataDeleteDelegate( this , config );
		}
	}
}
