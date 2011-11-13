package com.kaltura.commands.metadata
{
	import com.kaltura.delegates.metadata.MetadataServeDelegate;
	import com.kaltura.net.KalturaCall;

	public class MetadataServe extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param id int
		 **/
		public function MetadataServe( id : int )
		{
			service= 'metadata_metadata';
			action= 'serve';

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
			delegate = new MetadataServeDelegate( this , config );
		}
	}
}
