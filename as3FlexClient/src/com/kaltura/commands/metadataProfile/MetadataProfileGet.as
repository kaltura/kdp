package com.kaltura.commands.metadataProfile
{
	import com.kaltura.delegates.metadataProfile.MetadataProfileGetDelegate;
	import com.kaltura.net.KalturaCall;

	public class MetadataProfileGet extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param id int
		 **/
		public function MetadataProfileGet( id : int )
		{
			service= 'metadata_metadataprofile';
			action= 'get';

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
			delegate = new MetadataProfileGetDelegate( this , config );
		}
	}
}
