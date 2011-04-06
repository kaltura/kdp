package com.kaltura.commands.metadata
{
	import flash.net.FileReference;
	import com.kaltura.net.KalturaFileCall;
	import com.kaltura.delegates.metadata.MetadataAddFromFileDelegate;

	public class MetadataAddFromFile extends KalturaFileCall
	{
		public var xmlFile:Object;

		/**
		 * @param metadataProfileId int
		 * @param objectType int
		 * @param objectId String
		 * @param xmlFile Object - FileReference or ByteArray
		 **/
		public function MetadataAddFromFile( metadataProfileId : int,objectType : int,objectId : String,xmlFile : Object )
		{
			service= 'metadata_metadata';
			action= 'addFromFile';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('metadataProfileId');
			valueArr.push(metadataProfileId);
			keyArr.push('objectType');
			valueArr.push(objectType);
			keyArr.push('objectId');
			valueArr.push(objectId);
			this.xmlFile = xmlFile;
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new MetadataAddFromFileDelegate( this , config );
		}
	}
}
