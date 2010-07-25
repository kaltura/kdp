package com.kaltura.commands.metadataProfile
{
	import com.kaltura.vo.File;
	import com.kaltura.delegates.metadataProfile.MetadataProfileUpdateDefinitionFromFileDelegate;
	import com.kaltura.net.KalturaCall;

	public class MetadataProfileUpdateDefinitionFromFile extends KalturaCall
	{
		public var filterFields : String;
		public function MetadataProfileUpdateDefinitionFromFile( id : int,xsdFile : file )
		{
			service= 'metadata_metadataprofile';
			action= 'updateDefinitionFromFile';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push( 'id' );
			valueArr.push( id );
 			keyValArr = kalturaObject2Arrays(xsdFile,'xsdFile');
			keyArr = keyArr.concat( keyValArr[0] );
			valueArr = valueArr.concat( keyValArr[1] );
			applySchema( keyArr , valueArr );
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields',filterFields);
			delegate = new MetadataProfileUpdateDefinitionFromFileDelegate( this , config );
		}
	}
}
