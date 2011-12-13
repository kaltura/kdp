package com.kaltura.commands.metadataProfile
{
	import com.kaltura.delegates.metadataProfile.MetadataProfileRevertDelegate;
	import com.kaltura.net.KalturaCall;

	public class MetadataProfileRevert extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param id int
		 * @param toVersion int
		 **/
		public function MetadataProfileRevert( id : int,toVersion : int )
		{
			service= 'metadata_metadataprofile';
			action= 'revert';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('id');
			valueArr.push(id);
			keyArr.push('toVersion');
			valueArr.push(toVersion);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new MetadataProfileRevertDelegate( this , config );
		}
	}
}
