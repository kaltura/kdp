package {
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.plugin.component.CaptureThumbnailMediator;
	
	import flash.display.Sprite;
	
	import org.puremvc.as3.interfaces.IFacade;

	public class captureThumbnailPluginCode extends Sprite implements IPlugin
	{
		public function captureThumbnailPluginCode()
		{
		}
		
		public function initializePlugin( facade : IFacade ) : void
		{
			var captureTumbnailMediator : CaptureThumbnailMediator = new CaptureThumbnailMediator( CaptureThumbnailMediator.NAME ); 
			facade.registerMediator( captureTumbnailMediator );
		}
		
		public function setSkin( styleName : String , setSkinSize : Boolean = false) : void{}
	}
}
