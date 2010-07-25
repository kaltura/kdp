package {
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.plugin.IPluginFactory;
	
	import flash.display.Sprite;
	import flash.system.Security;

	/**
	 * playlistListPlugin is the visible playlist.
	 * it uses PlaylistAPIPlugin to manipulate playlist data.
	 */	
	public class playlistListPlugin extends Sprite implements IPluginFactory
	{
		public function playlistListPlugin()
		{
			Security.allowDomain("*");	
		}
		
		/**
		 * @inheritDoc 
		 */		
		public function create(pluginName : String = null) : IPlugin	
		{
			return new playlistListPluginCode();
		}
	}
}
