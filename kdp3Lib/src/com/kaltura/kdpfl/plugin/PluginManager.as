package com.kaltura.kdpfl.plugin
{
	import com.kaltura.kdpfl.view.controls.KTrace;
	
	import flash.display.Loader;
	import flash.errors.IOError;
	import flash.events.AsyncErrorEvent;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.FullScreenEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	
	import mx.rpc.mxml.Concurrency;

	/**
	 * Singleton class which manages the loading of the KDP plugins according to the plugin's different loading policies. 
	 * @author Hila
	 * 
	 */	
	public class PluginManager extends EventDispatcher
	{
		public static const ALL_PLUGINS_LOADED : String = "allPluginsLoaded";

		private static var _instance : PluginManager;
		private var _url2PluginMap : Object = new Object();
		
		//currntly loading plugins counter
		private var _loadingQ : int = 0;
		private var _updateAllLoaded : Boolean ;
		
		private function dispatchAllPluginsLoaded():void
		{
			if (!_loadingQ && _updateAllLoaded)
			{
				_updateAllLoaded = false;
				dispatchEvent(new Event(ALL_PLUGINS_LOADED));
			}
		}
		
		public function updateAllLoaded(listener:Function):void
		{
			_updateAllLoaded = true;
			addEventListener(ALL_PLUGINS_LOADED, listener);
			dispatchAllPluginsLoaded();
		}
									
		public function get loadingQ() : int { return _loadingQ; } //read only
		
		/**
		 * Constructor 
		 */		
		public function PluginManager( single : Singleton )
		{
			
		}
		/**
		 *  
		 * @return 
		 * 
		 */		
		public static function getInstance() : PluginManager
		{
			if(!_instance)
				_instance = new PluginManager( new Singleton() );
				
			return _instance;
		}
			
		public function isPluginLoaded( url : String ) : void
		{
			//TODO: Check if it is loaded
		}
		/**
		 * loads a single KDP plugin 
		 * @param url the url from which the plugis is loaded
		 * @param pluginName the name of the plugin
		 * @param loadingPolicy the loading policy of the plugin (preInitialize, onDemand, wait, noWait).
		 * @param asyncInit flag indicating whether the Manager should wait until the plugin itself reports its initialize process as complete (if the plugin makes an async load on its <code>initializePlugin</code> function.
		 * @param fileSystemMode - flag indicating whether the KDP is running in the user's file system or from a remote server.
		 * @return Plugin
		 * 
		 */		
		public function loadPlugin( url : String , pluginName : String, loadingPolicy : String, asyncInit : Boolean = false, fileSystemMode : Boolean = false ) : Plugin
		{
			if(!_url2PluginMap[url])
			{
				var loader : PluginLoader = new PluginLoader(url);
				_url2PluginMap[url] = loader;
					
				//by defualt we wait for all plugins unless defined otherwise (in uiconf)
				loader.addEventListener(  IOErrorEvent.IO_ERROR , onPluginError );
				loader.addEventListener( SecurityErrorEvent.SECURITY_ERROR, onPluginError );
				loader.addEventListener( ErrorEvent.ERROR, onPluginError );
				loader.addEventListener( AsyncErrorEvent.ASYNC_ERROR, onPluginError );
				
				if(loadingPolicy == "wait" || loadingPolicy == "preInitialize" && !asyncInit) 
				{
					loader.addEventListener(  Event.COMPLETE , onPluginReady, false, int.MIN_VALUE );
					++_loadingQ;
				} 
			}
			
			
			var plugin:Plugin = new Plugin(_url2PluginMap[url], pluginName);
			
			if (asyncInit)
			{
				plugin.addEventListener(KPluginEvent.KPLUGIN_INIT_COMPLETE, onAsyncInitComplete);
				plugin.addEventListener(KPluginEvent.KPLUGIN_INIT_FAILED, onAsyncInitFailed );
				++_loadingQ;
			}
			
			if (loadingPolicy != "onDemand")
				plugin.load( fileSystemMode );
				
			return plugin;
		}
		/**
		 * method for unloading the plugin from the KDP. 
		 * @param url url which serves as a unique id of the plugin to the PluginManager.
		 * 
		 */		
		public function unloadPlugin( url : String ) : void
		{
			if(_url2PluginMap[url])
			{
				(_url2PluginMap[url] as Loader).unload();
				//TODO: remove all listeners
				_url2PluginMap[url] = null;
			}
			
		}
		/**
		 * Handler for the COMPLETE event.
		 * @param event
		 * 
		 */		
		public function onPluginReady( event : Event ) : void
		{
			
			//trace ("inner ready");
			//event.target.removeEventListener(  Event.COMPLETE , onPluginReady );
			--_loadingQ;
			
			//if all plugin loaded
			dispatchAllPluginsLoaded();
		}
		/**
		 * Handler for the KPLUGIN_INIT_COMPLETE event 
		 * @param e
		 * 
		 */		
		private function onAsyncInitComplete (e : Event ) : void
		{
			--_loadingQ;
			
			//if all plugin loaded
			dispatchAllPluginsLoaded();
		}
		/**
		 * Handler for the KPLUGIN_INIT_FAILED event
		 * @param e
		 * 
		 */		
		private function onAsyncInitFailed (e : Event) : void
		{
			--_loadingQ;
			
			//if all plugin loaded
			dispatchAllPluginsLoaded();
		}

		/**
		 * Handler for plugin load fail.
		 * @param event
		 * 
		 */		
		private function onPluginError( event:ErrorEvent ) :void
		{		
			removeAllListeners(event);
			//trace("error loading plug-in: " + event.text);
			KTrace.getInstance().log("error loading plug-in: " + event.text);
			--_loadingQ;

			//if all plugin loaded
			dispatchAllPluginsLoaded();
		}
		
		private function removeAllListeners(event:Event):void {
			event.target.removeEventListener(  IOErrorEvent.IO_ERROR, onPluginError );
			event.target.removeEventListener(  SecurityErrorEvent.SECURITY_ERROR, onPluginError );
			event.target.removeEventListener(  ErrorEvent.ERROR, onPluginError );
			event.target.removeEventListener(  AsyncErrorEvent.ASYNC_ERROR, onPluginError );
		}
	}
}
internal class Singleton{};