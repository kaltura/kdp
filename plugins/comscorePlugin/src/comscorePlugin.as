package
{
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.plugin.IPluginFactory;
	
	import flash.display.Sprite;
	import flash.system.Security;
	
	public class comscorePlugin extends Sprite implements IPluginFactory
	{
		public function comscorePlugin()
		{
			Security.allowDomain("*");
			
		}
		
		public function create (name : String = null) : IPlugin
		{
			return new ComscorePluginCode();	 
		}
	}
}