package com.kaltura.commands.metadata
{
	import com.kaltura.delegates.metadata.MetadataGetDelegate;
	import com.kaltura.net.KalturaCall;

	public class MetadataGet extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param id int
		 **/
		public function MetadataGet( id : int )
		{
			service= 'metadata_metadata';
			action= 'get';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('id');
			valueArr.push(id);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new MetadataGetDelegate( this , config );
		}
	}
}
