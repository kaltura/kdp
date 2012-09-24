package
{
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.plugin.IPluginFactory;
	import com.kaltura.kdpfl.plugin.PPTWidgetScreenPluginCode;
	
	import flash.display.Sprite;
	import flash.system.Security;
	
	public class pptWidgetScreenPlugin extends Sprite implements IPluginFactory
	{
		public function pptWidgetScreenPlugin()
		{
			Security.allowDomain("*");			
		}
		
		public function create(pluginName : String = null) : IPlugin	
		{
			return new PPTWidgetScreenPluginCode();
		}
	}
}