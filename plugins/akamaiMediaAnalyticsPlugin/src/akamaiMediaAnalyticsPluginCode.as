package
{
	import com.akamai.playeranalytics.osmf.OSMFCSMALoaderInfo;
	import com.kaltura.kdpfl.model.MediaProxy;
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.plugin.KPluginEvent;
	
	import fl.core.UIComponent;
	
	import flash.utils.getDefinitionByName;
	
	import org.osmf.events.MediaFactoryEvent;
	import org.osmf.media.MediaFactory;
	import org.osmf.media.MediaResourceBase;
	import org.osmf.media.PluginInfoResource;
	import org.puremvc.as3.interfaces.IFacade;

	public class akamaiMediaAnalyticsPluginCode extends UIComponent implements IPlugin
	{
		
		private var _swfPath:String;
		private var _configPath:String;
		private static const forceReference:OSMFCSMALoaderInfo = null;
		
		public function akamaiMediaAnalyticsPluginCode()
		{
			super();
		}
		
		public function get configPath():String
		{
			return _configPath;
		}

		public function set configPath(value:String):void
		{
			_configPath = value;
		}

		public function get swfPath():String
		{
			return _swfPath;
		}

		public function set swfPath(value:String):void
		{
			_swfPath = value;
		}

		public function initializePlugin(facade:IFacade):void
		{
			
			//Getting Static reference to Plugin.
			var pluginInfoRef:Class = getDefinitionByName("com.akamai.playeranalytics.osmf.OSMFCSMALoaderInfo") as Class;
			var pluginResource:MediaResourceBase = new PluginInfoResource(new pluginInfoRef);
			//Setting CSMA Plugin & Configuration data
			pluginResource.addMetadataValue("csmaPluginPath",_swfPath);
			pluginResource.addMetadataValue("csmaConfigPath",_configPath);
	
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
			dispatchEvent( new KPluginEvent (KPluginEvent.KPLUGIN_INIT_COMPLETE) );
		}
		/**
		 * Listener for the LOAD_ERROR event.
		 * @param e - MediaFactoryEvent
		 * 
		 */		
		protected function onOSMFPluginLoadError (e : MediaFactoryEvent) : void
		{
			dispatchEvent( new KPluginEvent (KPluginEvent.KPLUGIN_INIT_FAILED) );
		}
		
		public function setSkin(styleName:String, setSkinSize:Boolean=false):void
		{
			// Do nothing here
		}
	}
}