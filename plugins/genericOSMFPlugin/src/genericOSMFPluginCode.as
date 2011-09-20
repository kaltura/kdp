package
{
	import com.kaltura.kdpfl.model.ConfigProxy;
	import com.kaltura.kdpfl.model.MediaProxy;
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.plugin.KPluginEvent;
	import com.kaltura.kdpfl.plugin.component.OSMFPluginMediator;
	import com.kaltura.kdpfl.util.URLUtils;
	
	import fl.core.UIComponent;
	
	import flash.display.DisplayObject;
	
	import org.osmf.events.MediaFactoryEvent;
	import org.osmf.media.DefaultMediaFactory;
	import org.osmf.media.URLResource;
	import org.puremvc.as3.interfaces.IFacade;

	/**
	 * Plugin which wraps the load of an OSMF plugin into the OSMF MediaFactory of the KDP 
	 * @author Hila
	 * 
	 */	
	public class genericOSMFPluginCode extends UIComponent implements IPlugin
	{
		public function genericOSMFPluginCode()
		{
			super();
		}
		
		protected var _pluginURL : String = "";
		protected var _localMediaFactory : DefaultMediaFactory;
		protected var _streamerType : String;
		protected var _mediaFactoryIds : String;
		
		protected var _mediator : OSMFPluginMediator;
		
		/**
		 * A-sync init of the Plugin - this function begins an a-sync load process of the 
		 * OSMF plugin into the MediaFactory contained by the KDP.  
		 * @param facade
		 * 
		 */		
		public function initializePlugin(facade:IFacade):void
		{
			_mediator =  new OSMFPluginMediator (null, this);
			
			facade.registerMediator( _mediator );
			
			if (pluginURL)
			{
				_localMediaFactory = (facade.retrieveProxy(MediaProxy.NAME) as MediaProxy).vo.mediaFactory;
				
				var configProxy : ConfigProxy = facade.retrieveProxy( ConfigProxy.NAME ) as ConfigProxy;
				var flashvars : Object = configProxy.vo.flashvars;
				var pluginDomain : String = flashvars.pluginDomain ? flashvars.pluginDomain : (facade['appFolder'] + 'plugins/');
				
				//	if a full path wasnt passed use either the cdn host or pluginDomain
				if (!URLUtils.isHttpURL(pluginURL)) {
					if (pluginURL.charAt(0) == "/")
						pluginURL = flashvars.httpProtocol + flashvars.cdnHost + pluginURL;
					else
						pluginURL = pluginDomain + pluginURL;
				}
				
				var pluginResource : URLResource = new URLResource(pluginURL);
				_localMediaFactory.addEventListener(MediaFactoryEvent.PLUGIN_LOAD, onOSMFPluginLoaded);
				_localMediaFactory.addEventListener(MediaFactoryEvent.PLUGIN_LOAD_ERROR, onOSMFPluginLoadError);
				_localMediaFactory.loadPlugin(pluginResource);
			}
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
		}
		
		[Bindable]
		/**
		 * Getter/Setter for the pluginURL property which specifies the URL
		 * from which to load the OSMF plugin to the MediaFactory. 
		 * @return 
		 * 
		 */		
		public function get pluginURL():String
		{
			return _pluginURL;
		}
		
		public function set pluginURL(value:String):void
		{
			_pluginURL = value;
		}
		[Bindable]
		public function get streamerType():String
		{
			return _streamerType;
		}

		public function set streamerType(value:String):void
		{
			_streamerType = value;
		}

		public function get localMediaFactory():DefaultMediaFactory
		{
			return _localMediaFactory;
		}
		[Bindable]
		public function get mediaFactoryIds():String
		{
			return _mediaFactoryIds;
		}

		public function set mediaFactoryIds(value:String):void
		{
			_mediaFactoryIds = value;
		}


	}
}