package com.kaltura.commands.metadata
{
	import com.kaltura.delegates.metadata.MetadataAddDelegate;
	import com.kaltura.net.KalturaCall;

	public class MetadataAdd extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param metadataProfileId int
		 * @param objectType int
		 * @param objectId String
		 * @param xmlData String
		 **/
		public function MetadataAdd( metadataProfileId : int,objectType : int,objectId : String,xmlData : String )
		{
			service= 'metadata_metadata';
			action= 'add';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('metadataProfileId');
			valueArr.push(metadataProfileId);
			keyArr.push('objectType');
			valueArr.push(objectType);
			keyArr.push('objectId');
			valueArr.push(objectId);
			keyArr.push('xmlData');
			valueArr.push(xmlData);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new MetadataAddDelegate( this , config );
		}
	}
}
