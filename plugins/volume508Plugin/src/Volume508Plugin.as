package
{
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.plugin.IPluginFactory;
	
	import flash.display.Sprite;
	import flash.system.Security;
	
	public class Volume508Plugin extends Sprite implements IPluginFactory
	{
		public function Volume508Plugin():void
		{
			Security.allowDomain("*");			
		}
		
		public function create(pluginName : String = null) : IPlugin	
		{
			return new Volume508PluginCode();
		}
	}
}