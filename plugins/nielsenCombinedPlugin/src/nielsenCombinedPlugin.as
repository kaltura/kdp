package
{
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.plugin.IPluginFactory;
	
	import flash.display.Sprite;
	import flash.system.Security;
	
	public class nielsenCombinedPlugin extends Sprite implements IPluginFactory
	{
		public function nielsenCombinedPlugin()
		{
			Security.allowDomain("*");
		}
		
		/**
		 * create "real" plugin 
		 */		
		public function create(pluginName : String = null) : IPlugin	
		{
			return new nielsenCombinedPluginCode();
		}
	}
}