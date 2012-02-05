package
{
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.plugin.IPluginFactory;
	import flash.system.Security;
	import flash.display.Sprite;
	 
	public class doubleclickPlugin extends Sprite implements IPluginFactory
	{
		/**
		 * Constructor
		 * **/
		public function doubleclickPlugin()
		{
			Security.allowDomain("*");
		}
		
		/**
		 * create "real" plugin 
		 */		
		public function create(pluginName : String = null) : IPlugin	
		{
			return new doubleclickPluginCode();
		}
	}
}