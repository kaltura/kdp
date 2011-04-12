package
{
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.plugin.IPluginFactory;
	
	import flash.display.Sprite;
	import flash.system.Security;
	
	/**
	 * The plugin can affect other display objects and add effects. Available effects: 
	 * - Drop Shadow
	 * - Glow
	 * and implements IPluginFactory so a plugin can be created.
	 * @author Eitan Avgil
	 */	
	public class shadowFilterPlugin extends Sprite implements IPluginFactory
	{
		
		/**
		 * Constructor. 
		 */		
		public function shadowFilterPlugin():void {
			// must write this if you want the plugin to communicate with the KDP
			Security.allowDomain("*");			
		} 
		
		
		/**
		 * This function creates an instance of nonvisualDemoCode, which is the actual plugin.
		 * This way KDP can create multiple instances of the same class.  
		 * @param pluginName	name of a plugin. used to differentiate between different 
		 * 						instances of the same plugin.
		 * @return 	instance of the actual plugin class.
		 */		
		public function create(pluginName : String = null) : IPlugin	
		{
			return new ShadowFilterPluginCode();
		}
	}
}