package 
{
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.plugin.component.AdvancePluginMediator;
	
	import flash.display.Sprite;
	
	import org.puremvc.as3.interfaces.IFacade;
	
	public class advanceSeekPluginCode extends Sprite implements IPlugin
	{
		public function advanceSeekPluginCode()
		{
		}
		public function initializePlugin( facade : IFacade ) : void
		{
 			var advancePluginMediator:AdvancePluginMediator = new AdvancePluginMediator( AdvancePluginMediator.NAME ); 
			facade.registerMediator( advancePluginMediator ); 
			
		}
		
		public function setSkin( styleName : String , setSkinSize : Boolean = false) : void{}
	}
}