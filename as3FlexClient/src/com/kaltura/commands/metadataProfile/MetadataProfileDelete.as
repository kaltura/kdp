package com.kaltura.commands.metadataProfile
{
	import com.kaltura.delegates.metadataProfile.MetadataProfileDeleteDelegate;
	import com.kaltura.net.KalturaCall;

	public class MetadataProfileDelete extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param id int
		 **/
		public function MetadataProfileDelete( id : int )
		{
			service= 'metadata_metadataprofile';
			action= 'delete';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('id');
			valueArr.push(id);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new MetadataProfileDeleteDelegate( this , config );
		}
	}
}
