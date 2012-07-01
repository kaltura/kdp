package
{
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.plugin.IPluginFactory;
	
	import flash.display.Sprite;
	import flash.system.Security;
	
	/**
	 * visibilatorPlugin controls the visibility of a uicomponent based on finding
	 * a given tag in given entry data (ie admin tags, metadata) 
	 * @author Atar
	 */	
	public class visibilatorPlugin extends Sprite implements IPluginFactory {
		
		
		public function visibilatorPlugin() {
			Security.allowDomain("*");	
		}
		
		
		public function create(pluginName : String = null) : IPlugin {
			return new visibilatorPluginCode();
		}
	}
}