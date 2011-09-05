package com.kaltura.commands.data
{
	import com.kaltura.delegates.data.DataGetDelegate;
	import com.kaltura.net.KalturaCall;

	public class DataGet extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param entryId String
		 * @param version int
		 **/
		public function DataGet( entryId : String,version : int=-1 )
		{
			service= 'data';
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
			delegate = new DataGetDelegate( this , config );
		}
	}
}
