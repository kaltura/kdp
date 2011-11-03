package
{
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.plugin.IPluginFactory;
	
	import flash.display.Sprite;
	import flash.system.Security;
	
	public class cdnSwitchingPlugin extends Sprite implements IPluginFactory
	{
		public function cdnSwitchingPlugin()
		{
			Security.allowDomain("*");
		}
		
		public function create (pluginName : String = "") : IPlugin
		{
			return new cdnSwitchingPluginCode ();
		}
	}
}