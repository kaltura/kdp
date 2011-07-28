package
{
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.plugin.IPluginFactory;
	
	import flash.display.Sprite;
	import flash.system.Security;
	
	public class chaptersPlugin extends Sprite implements IPluginFactory
	{
		public function chaptersPlugin()
		{
			Security.allowDomain("*");
		}
		
		public function create (pluginName : String=null) : IPlugin
		{
			return new ChaptersPluginCode();
		}
	}
}