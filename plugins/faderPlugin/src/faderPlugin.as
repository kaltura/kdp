package {
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.plugin.IPluginFactory;
	
	import flash.display.Sprite;
	import flash.system.Security;

	/**
	 * The Fader Plugin makes a DisplayObject (target) fade in when the mouse is over 
	 * another DisplayObject (hoverTarget) and fade out when the mouse leaves the hoverTarget.  
	 */	
	public class faderPlugin extends Sprite implements IPluginFactory
	{
		public function faderPlugin()
		{
			Security.allowDomain("*");	
		}
		
		public function create(pluginName : String = null) : IPlugin	
		{
			return new faderPluginCode();
		}
	}
}
