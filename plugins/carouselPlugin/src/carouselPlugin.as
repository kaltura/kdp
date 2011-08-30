package {
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.plugin.IPluginFactory;
	
	import flash.display.Sprite;
	import flash.system.Security;
	import com.kaltura.kdpfl.plugin.CarouselPluginCode;

	public class carouselPlugin extends Sprite implements IPluginFactory
	{
		public function carouselPlugin()
		{
			Security.allowDomain("*");	
		}
		
		public function create(pluginName : String = null) : IPlugin	
		{
			return new CarouselPluginCode();
		}
	}
}
