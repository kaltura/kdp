package {
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.plugin.IPluginFactory;
	
	import fl.core.UIComponent;
	
	import flash.system.Security;

	public class starsPlugin extends UIComponent implements IPluginFactory
	{
		public var editable:Boolean;
		public var rating : Number;
		public function starsPlugin()
		{
			Security.allowDomain("*");
			
		}
		public function create(pluginName : String = null) : IPlugin
		{
			return new starsPluginCode(editable, rating);
		}
		
	}
}
