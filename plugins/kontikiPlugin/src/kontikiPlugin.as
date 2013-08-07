package
{
	import com.kaltura.kdpfl.model.MediaProxy;
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.plugin.IPluginFactory;
	import com.kaltura.kdpfl.plugin.KPluginEvent;
	import com.kaltura.osmf.kontiki.KontikiPluginInfo;
	
	import flash.display.Sprite;
	
	import org.osmf.events.MediaFactoryEvent;
	import org.osmf.media.DefaultMediaFactory;
	import org.osmf.media.PluginInfoResource;
	import org.puremvc.as3.interfaces.IFacade;
	
	public class kontikiPlugin extends Sprite  implements IPluginFactory, IPlugin
	{
		private var _localMediaFactory : DefaultMediaFactory;
		
		/**
		 * js function to call in order to generate playback URL from kontiki URN
		 */		
		public var jsToCall:String = "kontikiAgent.getHttpUrl";
		
		public function kontikiPlugin()
		{	
		}
	
		public function create(pluginName : String = null) : IPlugin
		{
			return this;
		}
		
		public function initializePlugin(facade:IFacade):void 
		{
			var kontikiPluginInfo:KontikiPluginInfo = new KontikiPluginInfo();
			kontikiPluginInfo.jsToCall = jsToCall;
			_localMediaFactory = (facade.retrieveProxy(MediaProxy.NAME) as MediaProxy).vo.mediaFactory;	
			_localMediaFactory.addEventListener(MediaFactoryEvent.PLUGIN_LOAD, onOSMFPluginLoaded);
			_localMediaFactory.addEventListener(MediaFactoryEvent.PLUGIN_LOAD_ERROR, onOSMFPluginLoadError);	
			_localMediaFactory.loadPlugin(new PluginInfoResource(kontikiPluginInfo) );
			
		}
		
		/**
		 * Listener for the LOAD_COMPLETE event.
		 * @param e - MediaFactoryEvent
		 * 
		 */		
		protected function onOSMFPluginLoaded (e : MediaFactoryEvent) : void
		{
			_localMediaFactory.removeEventListener(MediaFactoryEvent.PLUGIN_LOAD, onOSMFPluginLoaded);
			dispatchEvent( new KPluginEvent (KPluginEvent.KPLUGIN_INIT_COMPLETE) );
		}
		/**
		 * Listener for the LOAD_ERROR event.
		 * @param e - MediaFactoryEvent
		 * 
		 */		
		protected function onOSMFPluginLoadError (e : MediaFactoryEvent) : void
		{
			_localMediaFactory.removeEventListener(MediaFactoryEvent.PLUGIN_LOAD_ERROR, onOSMFPluginLoadError);
			dispatchEvent( new KPluginEvent (KPluginEvent.KPLUGIN_INIT_FAILED) );
		}
		
		
		public function setSkin( styleName : String , setSkinSize : Boolean = false) : void {}
	}
}