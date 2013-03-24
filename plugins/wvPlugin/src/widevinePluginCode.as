package
{
	import com.kaltura.kdpfl.model.ConfigProxy;
	import com.kaltura.kdpfl.model.LayoutProxy;
	import com.kaltura.kdpfl.model.MediaProxy;
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.plugin.KPluginEvent;
	import com.kaltura.kdpfl.plugin.WVPluginInfo;
	
	import flash.display.Sprite;
	
	import org.osmf.events.MediaFactoryEvent;
	import org.osmf.media.DefaultMediaFactory;
	import org.osmf.media.PluginInfoResource;
	import org.puremvc.as3.interfaces.IFacade;
	
	public dynamic class widevinePluginCode extends Sprite implements IPlugin
	{
		protected var _localMediaFactory : DefaultMediaFactory;
		
		//Alerts texts, can be overriden from uiconf XML or flashvars.
		public var alert_title:String	= "Error";
		public var warning_title:String	= "Warning";
		public var alert_emm_falied:String = "We're sorry, you don’t have a valid license for this video.";
		public var alert_emm_error:String = "We're sorry, a license request for this video failed.";
		public var alert_emm_expired:String = "We're sorry, you don’t have a valid license for this video.";
		public var alert_log_error:String = "Message logging failed (error code: {0})";
		public var alert_dcp_stop:String = "Playback stopped due to the detection of copying attempt.";
		public var alert_dcp_alert:String = "A copying attempt was detected.";
		public var alert_missing_plugin:String = "Widevine Video Optimizer plugin is needed for enabling video playback in this player.";
		
		public var flavorTags:String;
		
		public function widevinePluginCode()
		{
			trace('Widevine plugin v3');
			super();
		}
		
		public function initializePlugin(facade:IFacade):void
		{
			if (flavorTags)
			{
				
				(facade.retrieveProxy(ConfigProxy.NAME) as ConfigProxy).vo.flashvars.flavorTags = flavorTags;
			}
			
			_localMediaFactory = (facade.retrieveProxy(MediaProxy.NAME) as MediaProxy).vo.mediaFactory;
			var wvPluginInfo:WVPluginInfo = new WVPluginInfo();

			/*var lp:LayoutProxy = (facade.retrieveProxy(LayoutProxy.NAME) as LayoutProxy);
			for each( var i:Object in lp.components)
			{
				if(i.hasOwnProperty("className") && i.className == "KMediaPlayer" )
				{
					trace(i.ui.width,i.ui.height );
					WVPluginInfo.mediaWidth = i.ui.width;
					WVPluginInfo.mediaHeight = i.ui.height;
					break;
				}
			}*/
				
			_localMediaFactory.addEventListener(MediaFactoryEvent.PLUGIN_LOAD, onOSMFPluginLoaded);
			_localMediaFactory.addEventListener(MediaFactoryEvent.PLUGIN_LOAD_ERROR, onOSMFPluginLoadError);	
			_localMediaFactory.loadPlugin(new PluginInfoResource(wvPluginInfo) );
			
				
			var wvm:WvMediator = new WvMediator(this, wvPluginInfo);
			facade.registerMediator(wvm);
			
			
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
		public function setSkin(styleName:String, setSkinSize:Boolean=false):void
		{
		}
		
	}
}