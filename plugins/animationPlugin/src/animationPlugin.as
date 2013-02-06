package
{
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.plugin.IPluginFactory;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.Security;
	
	public class animationPlugin extends Sprite implements IPluginFactory
	{
		public function animationPlugin()
		{
			Security.allowDomain("*");
		}
		
		public function create(pluginName : String = null) : IPlugin{
			return new AnimationCode();
		}
		
	}
}