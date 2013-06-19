package
{
	import com.akamai.playeranalytics.osmf.OSMFCSMALoaderInfo;
	import com.kaltura.KalturaClient;
	import com.kaltura.kdpfl.model.MediaProxy;
	import com.kaltura.kdpfl.model.ServicesProxy;
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.plugin.KPluginEvent;
	import com.kaltura.kdpfl.plugin.akamaiMediaAnalyticsMediator;
	
	import fl.core.UIComponent;
	
	import flash.utils.getDefinitionByName;
	
	import org.osmf.events.MediaFactoryEvent;
	import org.osmf.media.MediaFactory;
	import org.osmf.media.MediaResourceBase;
	import org.osmf.media.PluginInfoResource;
	import org.puremvc.as3.interfaces.IFacade;

	/**
	 * AkamaiMediaAnalytics pluging will send statistics to akamai. These statistics can be shown in Akamai Control: : https://control.akamai.com..
	 * The plugin receives two mandatory fields: swfPath and configPath.
	 * For example:
	 * <Plugin id="akamaiMediaAnalytics" width="0%" height="0%" includeInLayout="false" asyncInit="true" swfPath="http://79423.analytics.edgesuite.net/csma/plugin/csma.swf" configPath="http://79423.analytics.edgesuite.net/csma/configuration/CSMASampleConfiguration.xml"/> 
	 * @author michalr
	 * 
	 */	
	public class akamaiMediaAnalyticsPluginCode extends UIComponent implements IPlugin
	{
		
		private var _swfPath:String;
		private var _configPath:String;
		public var securedConfigPath:String;
		public var securedSwfPath:String;
		public var title:String;
		public var category:String;
		public var subCategory:String;
		public var playerId:String;
		public var eventName:String;
		
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
			var mediator:akamaiMediaAnalyticsMediator = new akamaiMediaAnalyticsMediator(this);
			facade.registerMediator(mediator);
			
			//Getting Static reference to Plugin.
			var pluginInfoRef:Class = getDefinitionByName("com.akamai.playeranalytics.osmf.OSMFCSMALoaderInfo") as Class;
			var pluginResource:MediaResourceBase = new PluginInfoResource(new pluginInfoRef);
			var kc:KalturaClient = (facade.retrieveProxy(ServicesProxy.NAME) as ServicesProxy).kalturaClient;
			var secured:Boolean = kc.protocol == "https://";
			//Setting CSMA Plugin & Configuration data
			pluginResource.addMetadataValue("csmaPluginPath", secured && securedSwfPath ? securedSwfPath : _swfPath);
			pluginResource.addMetadataValue("csmaConfigPath",secured && securedConfigPath ? securedConfigPath : _configPath);
	
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
			dispatchEvent( new KPluginEvent (KPluginEvent.KPLUGIN_INIT_COMPLETE) );
		}
		/**
		 * Listener for the LOAD_ERROR event.
		 * @param e - MediaFactoryEvent
		 * 
		 */		
		protected function onOSMFPluginLoadError (e : MediaFactoryEvent) : void
		{
			e.target.removeEventListener(MediaFactoryEvent.PLUGIN_LOAD_ERROR, onOSMFPluginLoaded);
			dispatchEvent( new KPluginEvent (KPluginEvent.KPLUGIN_INIT_FAILED) );
		}
		
		public function setSkin(styleName:String, setSkinSize:Boolean=false):void
		{
			// Do nothing here
		}
	}
}