package com.kaltura.commands.metadata
{
	import com.kaltura.delegates.metadata.MetadataAddFromBulkDelegate;
	import com.kaltura.net.KalturaCall;

	public class MetadataAddFromBulk extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param metadataProfileId int
		 * @param objectType int
		 * @param objectId String
		 * @param url String
		 **/
		public function MetadataAddFromBulk( metadataProfileId : int,objectType : int,objectId : String,url : String )
		{
			service= 'metadata_metadata';
			action= 'addFromBulk';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('metadataProfileId');
			valueArr.push(metadataProfileId);
			keyArr.push('objectType');
			valueArr.push(objectType);
			keyArr.push('objectId');
			valueArr.push(objectId);
			keyArr.push('url');
			valueArr.push(url);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new MetadataAddFromBulkDelegate( this , config );
		}
	}
}
