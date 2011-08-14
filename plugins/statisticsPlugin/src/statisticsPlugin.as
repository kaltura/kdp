package
{
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.plugin.IPluginFactory;
	
	import flash.display.Sprite;
	
	public class statisticsPlugin extends Sprite implements IPluginFactory
	{
		/**
		 * set to true to disable statistics notifications 
		 */		
		public var statsDis : Boolean;
		
		/**
		 * Constructor. 
		 * 
		 */		
		public function statisticsPlugin()
		{

		}
		
		
		public function create(pluginName : String = null) : IPlugin	
		{
			return new statisticsPluginCode(statsDis);
		}

	}
}