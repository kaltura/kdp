package
{
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.plugin.IPluginFactory;
	
	import fl.core.UIComponent;
	
	import flash.display.Sprite;
	import flash.system.Security;
	
	public class relatedViewPlugin extends UIComponent implements IPluginFactory
	{
		public function relatedViewPlugin()
		{
			Security.allowDomain("*");
		}
		
		public function create(pluginName : String = null) : IPlugin
		{
			return new relatedViewPluginCode();
		}
	}
}