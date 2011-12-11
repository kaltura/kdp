package
{
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.plugin.IPluginFactory;
	
	import flash.display.Sprite;
	import flash.system.Security;
	
	/**
	 * This is the project main class. It extends Sprite and implements IPluginFactory
	 * @author Eitan
	 * 
	 */	
	public class visualDemoPlugin extends Sprite implements IPluginFactory
	{
		
		/**
		 * Constructor. 
		 */		
		public function visualDemoPlugin():void
		{
			//must write this if you want the plugin to communicate with the KDP
			Security.allowDomain("*");			
		} 
		
		
		/**
		 * This function creates an instance of visualDemoCode, which is the actual plugin.
		 * This way KDP can create multiple instances of the same class.  
		 * @param pluginName	name of a plugin. used to differentiate between different 
		 * 						instances of the same plugin.
		 * @return 	instance of the actual plugin class.
		 * 
		 */		
		public function create(pluginName : String = null) : IPlugin	
		{
			return new visualDemoCode();
		}
	}
}