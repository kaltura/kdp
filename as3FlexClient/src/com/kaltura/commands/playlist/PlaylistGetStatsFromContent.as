package com.kaltura.commands.playlist
{
	import com.kaltura.delegates.playlist.PlaylistGetStatsFromContentDelegate;
	import com.kaltura.net.KalturaCall;

	public class PlaylistGetStatsFromContent extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param playlistType int
		 * @param playlistContent String
		 **/
		public function PlaylistGetStatsFromContent( playlistType : int,playlistContent : String )
		{
			service= 'playlist';
			action= 'getStatsFromContent';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('playlistType');
			valueArr.push(playlistType);
			keyArr.push('playlistContent');
			valueArr.push(playlistContent);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new PlaylistGetStatsFromContentDelegate( this , config );
		}
	}
}
