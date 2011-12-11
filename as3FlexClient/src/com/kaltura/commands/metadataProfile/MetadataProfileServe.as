package com.kaltura.commands.metadataProfile
{
	import com.kaltura.delegates.metadataProfile.MetadataProfileServeDelegate;
	import com.kaltura.net.KalturaCall;

	public class MetadataProfileServe extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param id int
		 **/
		public function MetadataProfileServe( id : int )
		{
			service= 'metadata_metadataprofile';
			action= 'serve';

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
			delegate = new MetadataProfileServeDelegate( this , config );
		}
	}
}
