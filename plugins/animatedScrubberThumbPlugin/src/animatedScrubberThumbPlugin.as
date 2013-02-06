package
{
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.plugin.IPluginFactory;
	
	import flash.display.Sprite;
	import flash.system.Security;
	
	public class animatedScrubberThumbPlugin extends Sprite implements IPluginFactory
	{
		public function animatedScrubberThumbPlugin()
		{
			Security.allowDomain("*");	
		}
		
		public function create(pluginName : String = null) : IPlugin{
			return new AnimatedScrubberThumbCode();
		}
	}
}