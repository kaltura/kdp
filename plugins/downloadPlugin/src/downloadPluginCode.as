package
{
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.plugin.component.DownloadMediator;
	
	import flash.display.Sprite;
	
	import org.puremvc.as3.interfaces.IFacade;
	
	
	public class downloadPluginCode extends Sprite implements IPlugin
	{
		public function downloadPluginCode()
		{
		}
        
        public function initializePlugin( facade : IFacade ) : void
		{
			var downloadMediator: DownloadMediator= new DownloadMediator();
			facade.registerMediator( downloadMediator );
		}
		
		public function setSkin( styleName : String , setSkinSize : Boolean = false) : void{}
	}
}