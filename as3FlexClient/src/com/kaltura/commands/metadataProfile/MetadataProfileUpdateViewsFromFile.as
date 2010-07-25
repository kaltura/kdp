package com.kaltura.commands.metadataProfile
{
	import com.kaltura.vo.File;
	import com.kaltura.delegates.metadataProfile.MetadataProfileUpdateViewsFromFileDelegate;
	import com.kaltura.net.KalturaCall;

	public class MetadataProfileUpdateViewsFromFile extends KalturaCall
	{
		public var filterFields : String;
		public function MetadataProfileUpdateViewsFromFile( id : int,viewsFile : file )
		{
			service= 'metadata_metadataprofile';
			action= 'updateViewsFromFile';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push( 'id' );
			valueArr.push( id );
 			keyValArr = kalturaObject2Arrays(viewsFile,'viewsFile');
			keyArr = keyArr.concat( keyValArr[0] );
			valueArr = valueArr.concat( keyValArr[1] );
			applySchema( keyArr , valueArr );
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields',filterFields);
			delegate = new MetadataProfileUpdateViewsFromFileDelegate( this , config );
		}
	}
}
