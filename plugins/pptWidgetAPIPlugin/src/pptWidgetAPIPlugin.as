package
{
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.plugin.IPluginFactory;
	import com.kaltura.kdpfl.plugin.PPTWidgetAPIPlugin;
	
	import flash.display.Sprite;
	import flash.system.Security;
	
	public class pptWidgetAPIPlugin extends Sprite implements IPluginFactory
	{
		public function pptWidgetAPIPlugin()
		{
			Security.allowDomain("*");			
		}
		
		public function create(pluginName : String = null) : IPlugin	
		{
			return new PPTWidgetAPIPlugin();
		}
	}
}