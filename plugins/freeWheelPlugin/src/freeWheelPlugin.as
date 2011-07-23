package {
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.plugin.IPluginFactory;
	
	import flash.display.Sprite;

	public class freeWheelPlugin extends Sprite implements IPluginFactory
	{
		public function freeWheelPlugin()
		{
			Security.allowDomain("*");
		}
		
		public function create(pluginName : String = null) : IPlugin	
		{
			return new freeWheelPluginCode();
		}
	}
}
