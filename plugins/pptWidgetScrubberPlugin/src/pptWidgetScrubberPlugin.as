package
{
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.plugin.IPluginFactory;
	import com.kaltura.kdpfl.plugin.PPTWidgetScrubber;
	
	import flash.display.Sprite;
	import flash.system.Security;
	
	public class pptWidgetScrubberPlugin extends Sprite implements IPluginFactory
	{
		public function pptWidgetScrubberPlugin()
		{
			Security.allowDomain("*");			
		}
		
		public function create(pluginName : String = null) : IPlugin	
		{
			return new PPTWidgetScrubber();
		}
	}
}