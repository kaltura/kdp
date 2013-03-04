package
{
	import com.kaltura.kdpfl.model.ConfigProxy;
	import com.kaltura.kdpfl.model.LayoutProxy;
	import com.kaltura.kdpfl.model.MediaProxy;
	import com.kaltura.kdpfl.model.type.EnableType;
	import com.kaltura.kdpfl.model.type.NotificationType;
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.plugin.KPluginEvent;
	import com.kaltura.kdpfl.plugin.WVPluginInfo;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	
	import org.osmf.events.MediaFactoryEvent;
	import org.osmf.media.DefaultMediaFactory;
	import org.osmf.media.PluginInfoResource;
	import org.puremvc.as3.interfaces.IFacade;
	
	public dynamic class widevinePluginCode extends Sprite implements IPlugin
	{
		protected var _flashvars : Object;
		protected var _localMediaFactory : DefaultMediaFactory;
		
		//Alerts texts, can be overriden from uiconf XML or flashvars.
		public var alert_title:String	= "Error";
		public var alert_emm_falied:String = "We're sorry, you don’t have a license to play this video.";
		public var alert_emm_error:String = "We're sorry, we failed to obtain a license for playing this video.";
		public var alert_emm_expired:String = "We're sorry, the license to play this video has expired.";
		public var alert_log_error:String = "Message Logging Error (error code: {0})";
		
		private var _wvPluginInfo:WVPluginInfo;
		private var _facade:IFacade;
		
		public function widevinePluginCode()
		{
			trace('Widevine plugin v3');
			super();
		}
		
		public function initializePlugin(facade:IFacade):void
		{
			_flashvars = (facade.retrieveProxy(ConfigProxy.NAME) as ConfigProxy).vo.flashvars;
			
			_localMediaFactory = (facade.retrieveProxy(MediaProxy.NAME) as MediaProxy).vo.mediaFactory;
			_wvPluginInfo = new WVPluginInfo();

			var lp:LayoutProxy = (facade.retrieveProxy(LayoutProxy.NAME) as LayoutProxy);
			for each( var i:Object in lp.components)
			{
				if(i.hasOwnProperty("className") && i.className == "KMediaPlayer" )
				{
					trace(i.ui.width,i.ui.height );
					WVPluginInfo.mediaWidth = i.ui.width;
					WVPluginInfo.mediaHeight = i.ui.height;
					break;
				}
			}
				
			_localMediaFactory.addEventListener(MediaFactoryEvent.PLUGIN_LOAD, onOSMFPluginLoaded);
			_localMediaFactory.addEventListener(MediaFactoryEvent.PLUGIN_LOAD_ERROR, onOSMFPluginLoadError);	
			_localMediaFactory.loadPlugin(new PluginInfoResource(_wvPluginInfo) );
			
			_wvPluginInfo.addEventListener(WVPluginInfo.WVMEDIA_ELEMENT_CREATED, onWVElementCreated);		
			var wvm:WvMediator = new WvMediator(_wvPluginInfo);
			facade.registerMediator(wvm);
			_facade = facade;
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
			
		private function onWVElementCreated(e : Event) : void
		{
			_wvPluginInfo.wvMediaElement.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
		}
		
		/**
		 * wvMediaElement bubbles up all netstatus event. Display proper KDP alerts accordingly.
		 * @param e
		 * 
		 */		
		private function onNetStatus(e: NetStatusEvent):void
		{
			var err:String;
			
			switch (e.info.code)
			{	
				case "NetStream.Wv.EmmError":
					err = alert_emm_error;
					break;
				case "NetStream.Wv.EmmExpired":
					err = alert_emm_expired;
					break;
				
				case "NetStream.Wv.LogError":
					err = alert_log_error;
					if (e.info.details)
						err = err.replace("{0}", e.info.details);
					break;
				
				case "NetStream.Wv.EmmFailed":
					err = alert_emm_falied;
					break;
			}
			
			if (err)
			{
				_facade.sendNotification( NotificationType.ALERT , {message: err, title: alert_title} );
				_facade.sendNotification(NotificationType.ENABLE_GUI, {guiEnabled: false, enableType : EnableType.CONTROLS});
				
			}
		}
	}
}