package
{
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.plugin.IPluginFactory;
	import com.kaltura.kdpfl.plugin.ParallelElementMediator;
	
	import flash.display.Sprite;
	import flash.system.Security;
	
	import org.puremvc.as3.interfaces.IFacade;
	
	/**
	 * This plugin will create parallelElement as the player's media element, if the player dispatches the proper notifications:
	 * createParallelElement, restoreParallelElement
	 * Currently the parallel element will be created only for liveStream + freeWheel preroll 
	 * @author michalr
	 * 
	 */	
	public class parallelElementPlugin extends Sprite implements IPlugin, IPluginFactory
	{	
		public function parallelElementPlugin()
		{
			Security.allowDomain("*");
		}
		
		public function create(pluginName:String = null):IPlugin
		{
			return this;
		}
		
		public function initializePlugin(facade:IFacade):void
		{
			var mediator:ParallelElementMediator = new ParallelElementMediator(this);
			facade.registerMediator(mediator);
			
		}
		
		public function setSkin(styleName:String, setSkinSize:Boolean=false):void
		{
			//do nothing
		}
	}
}