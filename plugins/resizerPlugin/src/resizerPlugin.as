package
{
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.plugin.IPluginFactory;
	
	import flash.display.Sprite;
	import flash.system.Security;
	
	public class resizerPlugin extends Sprite implements IPluginFactory
	{
		public function resizerPlugin()
		{
			Security.allowDomain("*");
		}
		
		public function create (pluginName : String = "") : IPlugin
		{
			return new ResizerPluginCode ();
		}
	}
}