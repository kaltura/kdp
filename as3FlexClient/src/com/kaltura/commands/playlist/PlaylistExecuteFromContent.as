package com.kaltura.commands.playlist
{
	import com.kaltura.delegates.playlist.PlaylistExecuteFromContentDelegate;
	import com.kaltura.net.KalturaCall;

	public class PlaylistExecuteFromContent extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param playlistType int
		 * @param playlistContent String
		 * @param detailed String
		 **/
		public function PlaylistExecuteFromContent( playlistType : int,playlistContent : String,detailed : String='' )
		{
			service= 'playlist';
			action= 'executeFromContent';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('playlistType');
			valueArr.push(playlistType);
			keyArr.push('playlistContent');
			valueArr.push(playlistContent);
			keyArr.push('detailed');
			valueArr.push(detailed);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new PlaylistExecuteFromContentDelegate( this , config );
		}
	}
}
