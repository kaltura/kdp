package com.kaltura.commands.metadata
{
	import com.kaltura.delegates.metadata.MetadataAddFromUrlDelegate;
	import com.kaltura.net.KalturaCall;

	public class MetadataAddFromUrl extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param metadataProfileId int
		 * @param objectType int
		 * @param objectId String
		 * @param url String
		 **/
		public function MetadataAddFromUrl( metadataProfileId : int,objectType : int,objectId : String,url : String )
		{
			service= 'metadata_metadata';
			action= 'addFromUrl';

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
			delegate = new MetadataAddFromUrlDelegate( this , config );
		}
	}
}
