package com.kaltura.commands.metadataProfile
{
	import flash.net.FileReference;
	import com.kaltura.net.KalturaFileCall;
	import com.kaltura.delegates.metadataProfile.MetadataProfileUpdateDefinitionFromFileDelegate;

	public class MetadataProfileUpdateDefinitionFromFile extends KalturaFileCall
	{
		public var xsdFile:Object;

		/**
		 * @param id int
		 * @param xsdFile Object - FileReference or ByteArray
		 **/
		public function MetadataProfileUpdateDefinitionFromFile( id : int,xsdFile : Object )
		{
			service= 'metadata_metadataprofile';
			action= 'updateDefinitionFromFile';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('id');
			valueArr.push(id);
			this.xsdFile = xsdFile;
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new MetadataProfileUpdateDefinitionFromFileDelegate( this , config );
		}
	}
}
