package com.kaltura.kdpfl.plugin.type
{
	/**
	 * This class represents playlist notification types 
	 * @author michalr
	 * 
	 */	
	public class PlaylistNotificationType
	{
		/**
		 * play previous item in playlist 
		 */		
		public static const PLAYLIST_PLAY_PREVIOUS : String 	= "playlistPlayPrevious";
		/**
		 * play next item in playlist 
		 */		
		public static const PLAYLIST_PLAY_NEXT : String		 	= "playlistPlayNext";
		/**
		 * load playlist
		 * Body: kplName=kaltura playlist name, kplUrl=kaltura playlist URL 
		 */		
		public static const LOAD_PLAYLIST : String				= "loadPlaylist";
		
		/**
		 * The playlist is now playing the 1st entry
		 */		
		public static const PLAYLIST_FIRST_ENTRY:String = "playlistFirstEntry";
		
		/**
		 * The playlist is now playing the last entry
		 */		
		public static const PLAYLIST_LAST_ENTRY:String = "playlistLastEntry";
		/**
		 * The playlist is now playing one of the middle
		 */		
		public static const PLAYLIST_MIDDLE_ENTRY:String = "playlistMiddleEntry";		
		
		/**
		 * happens when we've reached the last entry in the playlist
		 */		
		public static const PLAYLIST_DONE:String = "playlistDone";
		/**
		 * Dispatched when the playlist data provider is ready
		 */		
		public static const PLAYLIST_READY:String = "playlistReady";
		
		/**
		 * Dispatched when playlistAPIMediator was registered
		 */		
		public static const PLAYLISTS_LISTED:String = "playlistsListed";
		
		/**
		 * The playlist is now auto moving to the next item 
		 */		
		public static const PLAYLIST_AUTO_MOVE_NEXT:String = "playlistAutoMoveNext";
	}
}