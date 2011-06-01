package {
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.plugin.IPluginFactory;
	
	import flash.display.Sprite;
	import flash.system.Security;
	/**
	 * @author - Eitan Avgil
	 * This plugin can do advance seeks. It can seek X seconds forward/backwords,or seek to precentage of the movie.
	 * The plugins listen to :
	 * seekForward - argument X seconds
	 * seekBackwards - argument X seconds 
	 * seekPercentage - argument, a number from 0 to 100
	 * in case the outcome of the seek is greather than the duration of the current media - it will seek to the end of it. same behavior for less than 0  
	 */
	public class advanceSeekPlugin extends Sprite implements IPluginFactory
	{
		
		public function advanceSeekPlugin()
		{
			Security.allowDomain("*");
		}
		/**
		 * 
		 * @param pluginName
		 * @return IPlugin
		 * 
		 */		
		public function create(pluginName : String = null) : IPlugin	
		{
			return new advanceSeekPluginCode();
		}
	}
}
