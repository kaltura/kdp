package
{
	import com.kaltura.cuePointPluginCode;
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.plugin.IPluginFactory;
	
	import flash.display.Sprite;
	
	public class cuePointPlugin extends Sprite implements IPluginFactory
	{
		public function cuePointPlugin()
		{
			
		}
		
		public function create (pluginName : String=null) : IPlugin
		{
			return new cuePointPluginCode();
		}
	}
}