package
{
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.plugin.IPluginFactory;
	
	import flash.display.Sprite;
	import flash.system.Security;
	
	public class doubleclickPlugin extends Sprite implements IPluginFactory
	{
		public function doubleclickPlugin()
		{
			Security.allowDomain("*");
		}
		
		public function create(pluginName : String = null) : IPlugin
		{
			return new doubleclickPluginCode();
		}
	}
}
