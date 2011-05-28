package com.kaltura.commands.media
{
	import com.kaltura.delegates.media.MediaUpdateThumbnailFromSourceEntryDelegate;
	import com.kaltura.net.KalturaCall;

	public class MediaUpdateThumbnailFromSourceEntry extends KalturaCall
	{
		public var filterFields : String;
		public function MediaUpdateThumbnailFromSourceEntry( entryId : String,sourceEntryId : String,timeOffset : int,flavorParamsId : int=undefined )
		{
			service= 'media';
			action= 'updateThumbnailFromSourceEntry';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push( 'entryId' );
			valueArr.push( entryId );
			keyArr.push( 'sourceEntryId' );
			valueArr.push( sourceEntryId );
			keyArr.push( 'timeOffset' );
			valueArr.push( timeOffset );
			keyArr.push( 'flavorParamsId' );
			valueArr.push( flavorParamsId );
			applySchema( keyArr , valueArr );
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields',filterFields);
			delegate = new MediaUpdateThumbnailFromSourceEntryDelegate( this , config );
		}
	}
}
