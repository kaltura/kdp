package
{
	import com.akamai.osmf.AkamaiAdvancedStreamingPluginInfo;
	import com.kaltura.kdpfl.model.ConfigProxy;
	import com.kaltura.kdpfl.model.MediaProxy;
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.plugin.IPluginFactory;
	import com.kaltura.kdpfl.plugin.KPluginEvent;
	import com.kaltura.kdpfl.plugin.akamaiHDMediator;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.Security;
	import flash.utils.getDefinitionByName;
	
	import org.osmf.events.MediaFactoryEvent;
	import org.osmf.media.MediaFactory;
	import org.osmf.media.MediaResourceBase;
	import org.osmf.media.PluginInfoResource;
	import org.puremvc.as3.interfaces.IFacade;
	
	public class akamaiHDPlugin extends Sprite implements IPluginFactory, IPlugin
	{
		
		private static const AKAMAI_PLUGIN_INFO:String = "com.akamai.osmf.AkamaiAdvancedStreamingPluginInfo";
		private static const dummyRef:AkamaiAdvancedStreamingPluginInfo = null;
		
		public var hitUrl:String="";
		private var _hitReady:Boolean;
		private var _pluginReady:Boolean;
		private var _hasFailedLoadingOSMFPlugin:Boolean;
		private var _loader:URLLoader; 
		
		private var _facade:IFacade; 
		private var _cp:ConfigProxy; 
		
		public function akamaiHDPlugin()
		{
			Security.allowDomain("*");
		}
		
		public function create (pluginName : String =null) : IPlugin
		{
			return this;
		}
		
		private function raceCondition(): void{
			
			if(_hitReady && _hasFailedLoadingOSMFPlugin){
				dispatchEvent( new KPluginEvent (KPluginEvent.KPLUGIN_INIT_FAILED) );
			}
			
			if(_hitReady && _pluginReady ){
				dispatchEvent( new KPluginEvent (KPluginEvent.KPLUGIN_INIT_COMPLETE) );
			}
		}
		private function goodResponce(e:Event): void{
			_hitReady = true;
			_cp.vo.flashvars.serveRtmfp = true;
			raceCondition();
		}
		private function badResponce(e:Event): void{
			_hitReady = true;
			raceCondition();
		}
		
		public function initializePlugin(facade:IFacade):void
		{
			
			_facade = facade;
			_cp = _facade.retrieveProxy(ConfigProxy.NAME) as ConfigProxy;
			
			if (hitUrl){
				_loader = new URLLoader();
				var urlReq:URLRequest = new URLRequest(hitUrl);
				_loader.addEventListener(Event.COMPLETE, goodResponce);
				_loader.addEventListener(IOErrorEvent.IO_ERROR, badResponce);
				_loader.load(urlReq);
			}
			
			var mediator:akamaiHDMediator = new akamaiHDMediator();
			_facade.registerMediator(mediator);
			
			//Getting Static reference to Plugin.
			var pluginInfoRef:Class = getDefinitionByName(AKAMAI_PLUGIN_INFO) as Class;
			var pluginResource:MediaResourceBase = new PluginInfoResource(new pluginInfoRef);
			
			var mediaFactory:MediaFactory = (facade.retrieveProxy(MediaProxy.NAME) as MediaProxy).vo.mediaFactory;
			mediaFactory.addEventListener(MediaFactoryEvent.PLUGIN_LOAD, onOSMFPluginLoaded);
			mediaFactory.addEventListener(MediaFactoryEvent.PLUGIN_LOAD_ERROR, onOSMFPluginLoadError);
			mediaFactory.loadPlugin(pluginResource);		
		}
		
		/**
		 * Listener for the LOAD_COMPLETE event.
		 * @param e - MediaFactoryEvent
		 * 
		 */		
		protected function onOSMFPluginLoaded (e : MediaFactoryEvent) : void
		{
			e.target.removeEventListener(MediaFactoryEvent.PLUGIN_LOAD, onOSMFPluginLoaded);
			_pluginReady = true;
			raceCondition();
		}
		/**
		 * Listener for the LOAD_ERROR event.
		 * @param e - MediaFactoryEvent
		 * 
		 */		
		protected function onOSMFPluginLoadError (e : MediaFactoryEvent) : void
		{
			e.target.removeEventListener(MediaFactoryEvent.PLUGIN_LOAD_ERROR, onOSMFPluginLoadError);
			_hasFailedLoadingOSMFPlugin = true;
			raceCondition();
		}
		
		public function setSkin(styleName:String, setSkinSize:Boolean=false):void
		{
			// Do nothing here
		}
	}
}