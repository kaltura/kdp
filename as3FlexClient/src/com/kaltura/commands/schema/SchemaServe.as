package com.kaltura.commands.schema
{
	import com.kaltura.delegates.schema.SchemaServeDelegate;
	import com.kaltura.net.KalturaCall;

	public class SchemaServe extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param type String
		 **/
		public function SchemaServe( type : String )
		{
			service= 'schema';
			action= 'serve';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('type');
			valueArr.push(type);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new SchemaServeDelegate( this , config );
		}
	}
}
