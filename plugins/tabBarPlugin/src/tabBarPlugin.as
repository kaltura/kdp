package
{
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.plugin.IPluginFactory;
	
	import flash.display.Sprite;
	import flash.system.Security;
	public class tabBarPlugin extends Sprite implements IPluginFactory
	{
		
		/**
		 * name of the indexChanged notification
		 */		
		public static const INDEX_CHANGED:String = "indexChanged";
		
		public function tabBarPlugin()
		{
			Security.allowDomain("*");			
		}
		
		public function create(pluginName : String = null) : IPlugin
		{
			return new tabBarCodePlugin();
		}
	}
}