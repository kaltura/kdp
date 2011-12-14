package com.kaltura.commands.metadata
{
	import com.kaltura.delegates.metadata.MetadataInvalidateDelegate;
	import com.kaltura.net.KalturaCall;

	public class MetadataInvalidate extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param id int
		 * @param version int
		 **/
		public function MetadataInvalidate( id : int,version : int=int.MIN_VALUE )
		{
			service= 'metadata_metadata';
			action= 'invalidate';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('id');
			valueArr.push(id);
			keyArr.push('version');
			valueArr.push(version);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new MetadataInvalidateDelegate( this , config );
		}
	}
}
