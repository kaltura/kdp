package com.kaltura.commands.metadata
{
	import com.kaltura.delegates.metadata.MetadataDeleteDelegate;
	import com.kaltura.net.KalturaCall;

	public class MetadataDelete extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param id int
		 **/
		public function MetadataDelete( id : int )
		{
			service= 'metadata_metadata';
			action= 'delete';

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
			delegate = new MetadataDeleteDelegate( this , config );
		}
	}
}
