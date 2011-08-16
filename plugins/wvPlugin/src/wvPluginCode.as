package
{
	import com.kaltura.kdpfl.model.ConfigProxy;
	import com.kaltura.kdpfl.model.MediaProxy;
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.plugin.WVPluginInfo;
	
	import flash.display.Sprite;
	
	import org.osmf.media.MediaFactory;
	import org.osmf.media.PluginInfoResource;
	import org.puremvc.as3.interfaces.IFacade;
	
	public class wvPluginCode extends Sprite implements IPlugin
	{
		protected var _flashvars : Object;
		
		public function wvPluginCode()
		{
			super();
		}
		
		public function initializePlugin(facade:IFacade):void
		{
			_flashvars = (facade.retrieveProxy(ConfigProxy.NAME) as ConfigProxy).vo.flashvars;
			
			var mediaFactory : MediaFactory = (facade.retrieveProxy(MediaProxy.NAME) as MediaProxy).vo.mediaFactory;
			
			mediaFactory.loadPlugin(new PluginInfoResource(new WVPluginInfo()) );
		}
		
		public function setSkin(styleName:String, setSkinSize:Boolean=false):void
		{
		}
	}
}