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
	
	public class wvPluginCode extends Sprite implements IPlugin
	{
		protected var _flashvars : Object;
		
		protected var _localMediaFactory : DefaultMediaFactory;
		public function wvPluginCode()
		{
			trace('Widevine plugin v2');
			super();
		}
		public function initializePlugin(facade:IFacade):void
		{
			_flashvars = (facade.retrieveProxy(ConfigProxy.NAME) as ConfigProxy).vo.flashvars;
			
			_localMediaFactory = (facade.retrieveProxy(MediaProxy.NAME) as MediaProxy).vo.mediaFactory;
			var wvpinfo: WVPluginInfo = new WVPluginInfo();

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
			
			
			//overriding media width/height if flashvar available
/*			if (_flashvars.widevinemediawidth)
				WVPluginInfo.mediaWidth = Number(_flashvars.widevinemediawidth);
			if (_flashvars.widevinemediaheight)
				WVPluginInfo.mediaHeight = Number(_flashvars.widevinemediaheight);*/
				
			_localMediaFactory.addEventListener(MediaFactoryEvent.PLUGIN_LOAD, onOSMFPluginLoaded);
			_localMediaFactory.addEventListener(MediaFactoryEvent.PLUGIN_LOAD_ERROR, onOSMFPluginLoadError);
			
			
			_localMediaFactory.loadPlugin(new PluginInfoResource(wvpinfo) );
			var wvm:WvMediator = new WvMediator(wvpinfo);
			facade.registerMediator(wvm);
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
	}
}