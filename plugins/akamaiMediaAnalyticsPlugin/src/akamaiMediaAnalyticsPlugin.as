package
{
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.plugin.IPluginFactory;
	
	import flash.display.Sprite;
	import flash.system.Security;
	
	public class akamaiMediaAnalyticsPlugin extends Sprite implements IPluginFactory
	{
		public function akamaiMediaAnalyticsPlugin()
		{
			Security.allowDomain("*");
		}
		
		public function create (pluginName : String =null) : IPlugin
		{
			return new akamaiMediaAnalyticsPluginCode();
		}
	}
}