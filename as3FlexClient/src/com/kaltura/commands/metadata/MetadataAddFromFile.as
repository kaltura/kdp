package com.kaltura.commands.metadata
{
	import com.kaltura.vo.File;
	import com.kaltura.delegates.metadata.MetadataAddFromFileDelegate;
	import com.kaltura.net.KalturaCall;

	public class MetadataAddFromFile extends KalturaCall
	{
		public var filterFields : String;
		public function MetadataAddFromFile( metadataProfileId : int,objectType : int,objectId : String,xmlFile : file )
		{
			service= 'metadata_metadata';
			action= 'addFromFile';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push( 'metadataProfileId' );
			valueArr.push( metadataProfileId );
			keyArr.push( 'objectType' );
			valueArr.push( objectType );
			keyArr.push( 'objectId' );
			valueArr.push( objectId );
 			keyValArr = kalturaObject2Arrays(xmlFile,'xmlFile');
			keyArr = keyArr.concat( keyValArr[0] );
			valueArr = valueArr.concat( keyValArr[1] );
			applySchema( keyArr , valueArr );
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields',filterFields);
			delegate = new MetadataAddFromFileDelegate( this , config );
		}
	}
}
