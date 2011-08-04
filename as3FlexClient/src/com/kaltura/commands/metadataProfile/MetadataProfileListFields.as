package com.kaltura.commands.metadataProfile
{
	import com.kaltura.delegates.metadataProfile.MetadataProfileListFieldsDelegate;
	import com.kaltura.net.KalturaCall;

	public class MetadataProfileListFields extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param metadataProfileId int
		 **/
		public function MetadataProfileListFields( metadataProfileId : int )
		{
			service= 'metadata_metadataprofile';
			action= 'listFields';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('metadataProfileId');
			valueArr.push(metadataProfileId);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new MetadataProfileListFieldsDelegate( this , config );
		}
	}
}
