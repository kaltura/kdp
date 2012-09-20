package
{
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.plugin.IPluginFactory;
	
	import flash.display.Sprite;
	import flash.system.Security;
	
	/**
	 * errorNotificationPlugin sends notifications on media errors 
	 * @author Michal
	 * 
	 */	
	public class errorNotificationPlugin extends Sprite implements IPluginFactory
	{
		/**
		 * Constructor
		 * 
		 */		
		public function errorNotificationPlugin()
		{
			Security.allowDomain("*");
		}
		
		/**
		 * Create an instance of errorNotificationPluginCode. 
		 * @param pluginName
		 * @return 
		 * 
		 */		
		public function create(pluginName:String = null):IPlugin {
			return new errorNotificationPluginCode();
		}
	}
}