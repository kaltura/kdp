package
{
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.plugin.IPluginFactory;
	import com.kaltura.metaDataPluginCode;
	
	import flash.display.Sprite;
	
	public class metaDataPlugin extends Sprite implements IPluginFactory
	{
		public function metaDataPlugin()
		{
			
		}
		public function create (pluginName:String=null) : IPlugin
		{
			return new metaDataPluginCode();
		}
	}
}