package com.kaltura.commands.metadataProfile
{
	import flash.net.FileReference;
	import com.kaltura.net.KalturaFileCall;
	import com.kaltura.delegates.metadataProfile.MetadataProfileUpdateViewsFromFileDelegate;

	public class MetadataProfileUpdateViewsFromFile extends KalturaFileCall
	{
		public var viewsFile:Object;

		/**
		 * @param id int
		 * @param viewsFile Object - FileReference or ByteArray
		 **/
		public function MetadataProfileUpdateViewsFromFile( id : int,viewsFile : Object )
		{
			service= 'metadata_metadataprofile';
			action= 'updateViewsFromFile';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('id');
			valueArr.push(id);
			this.viewsFile = viewsFile;
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new MetadataProfileUpdateViewsFromFileDelegate( this , config );
		}
	}
}
