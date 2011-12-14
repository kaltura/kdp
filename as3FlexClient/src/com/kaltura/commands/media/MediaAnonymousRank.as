package com.kaltura.commands.media
{
	import com.kaltura.delegates.media.MediaAnonymousRankDelegate;
	import com.kaltura.net.KalturaCall;

	public class MediaAnonymousRank extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param entryId String
		 * @param rank int
		 **/
		public function MediaAnonymousRank( entryId : String,rank : int )
		{
			service= 'media';
			action= 'anonymousRank';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('entryId');
			valueArr.push(entryId);
			keyArr.push('rank');
			valueArr.push(rank);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new MediaAnonymousRankDelegate( this , config );
		}
	}
}
