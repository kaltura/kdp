package com.kaltura.commands.data
{
	import com.kaltura.delegates.data.DataServeDelegate;
	import com.kaltura.net.KalturaCall;

	public class DataServe extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param entryId String
		 * @param version int
		 * @param forceProxy Boolean
		 **/
		public function DataServe( entryId : String,version : int=-1,forceProxy : Boolean=false )
		{
			service= 'data';
			action= 'serve';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('entryId');
			valueArr.push(entryId);
			keyArr.push('version');
			valueArr.push(version);
			keyArr.push('forceProxy');
			valueArr.push(forceProxy);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new DataServeDelegate( this , config );
		}
	}
}
