package
{
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.plugin.IPluginFactory;
	
	import flash.display.Sprite;
	import flash.system.Security;
	
	/**
	 * playlistAPIPlugin handles sequencial playing of memdia entries
	 */	
	public class playlistAPIPlugin extends Sprite implements IPluginFactory
	{
		
		/**
		 * name of the playlistDone notification.happens at the end of the playlist
		 */		
		public static const PLAYLIST_DONE:String = "playlistDone";
		/**
		 * name of the playlistReady notification.
		 */		
		public static const PLAYLIST_READY:String = "playlistReady";
		
		/**
		 * name of the playlistsListed notification.
		 */		
		public static const PLAYLISTS_LISTED:String = "playlistsListed";
		
		
		public function playlistAPIPlugin()
		{
			Security.allowDomain("*");			
		}
		
		/**
		 * @inheritDoc 
		 */		
		public function create(pluginName : String = null) : IPlugin	
		{
			return new playlistAPIPluginCode();
		}
	}
}