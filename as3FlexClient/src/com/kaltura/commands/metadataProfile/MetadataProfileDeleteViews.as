package com.kaltura.commands.metadataProfile
{
	import com.kaltura.delegates.metadataProfile.MetadataProfileDeleteViewsDelegate;
	import com.kaltura.net.KalturaCall;

	public class MetadataProfileDeleteViews extends KalturaCall
	{
		public var filterFields : String;
		public function MetadataProfileDeleteViews( id : int )
		{
			service= 'metadata_metadataprofile';
			action= 'deleteViews';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push( 'id' );
			valueArr.push( id );
			applySchema( keyArr , valueArr );
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields',filterFields);
			delegate = new MetadataProfileDeleteViewsDelegate( this , config );
		}
	}
}
