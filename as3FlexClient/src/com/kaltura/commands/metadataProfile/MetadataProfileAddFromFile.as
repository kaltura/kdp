package com.kaltura.commands.metadataProfile
{
	import com.kaltura.vo.KalturaMetadataProfile;
	import com.kaltura.vo.File;
	import com.kaltura.vo.File;
	import com.kaltura.delegates.metadataProfile.MetadataProfileAddFromFileDelegate;
	import com.kaltura.net.KalturaCall;

	public class MetadataProfileAddFromFile extends KalturaCall
	{
		public var filterFields : String;
		public function MetadataProfileAddFromFile( metadataProfile : KalturaMetadataProfile,xsdFile : file,viewsFile : file=null )
		{
			if(viewsFile== null)viewsFile= new file();
			service= 'metadata_metadataprofile';
			action= 'addFromFile';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
 			keyValArr = kalturaObject2Arrays(metadataProfile,'metadataProfile');
			keyArr = keyArr.concat( keyValArr[0] );
			valueArr = valueArr.concat( keyValArr[1] );
 			keyValArr = kalturaObject2Arrays(xsdFile,'xsdFile');
			keyArr = keyArr.concat( keyValArr[0] );
			valueArr = valueArr.concat( keyValArr[1] );
 			keyValArr = kalturaObject2Arrays(viewsFile,'viewsFile');
			keyArr = keyArr.concat( keyValArr[0] );
			valueArr = valueArr.concat( keyValArr[1] );
			applySchema( keyArr , valueArr );
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields',filterFields);
			delegate = new MetadataProfileAddFromFileDelegate( this , config );
		}
	}
}
