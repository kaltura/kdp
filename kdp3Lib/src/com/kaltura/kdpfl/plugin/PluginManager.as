package com.kaltura.kdpfl.plugin
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.FullScreenEvent;
	import flash.events.IOErrorEvent;
	
	import mx.rpc.mxml.Concurrency;

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
		
		public function loadPlugin( url : String , pluginName : String, loadingPolicy : String, asyncInit : Boolean = false, fileSystemMode : Boolean = false ) : Plugin
		{
			if(!_url2PluginMap[url])
			{
				var loader : PluginLoader = new PluginLoader(url);
				_url2PluginMap[url] = loader;
					
				//by defualt we wait for all plugins unless defined otherwise (in uiconf)
				loader.addEventListener(  IOErrorEvent.IO_ERROR , onPluginError );
				
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
		
		public function unloadPlugin( url : String ) : void
		{
			if(_url2PluginMap[url])
			{
				(_url2PluginMap[url] as Loader).unload();
				//TODO: remove all listeners
				_url2PluginMap[url] = null;
			}
			
		}
		
		public function onPluginReady( event : Event ) : void
		{
			//trace ("inner ready");
			//event.target.removeEventListener(  Event.COMPLETE , onPluginReady );
			--_loadingQ;
			
			//if all plugin loaded
			dispatchAllPluginsLoaded();
		}
		
		private function onAsyncInitComplete (e : Event ) : void
		{
			--_loadingQ;
			
			//if all plugin loaded
			dispatchAllPluginsLoaded();
		}
		
		private function onAsyncInitFailed (e : Event) : void
		{
			--_loadingQ;
			
			//if all plugin loaded
			dispatchAllPluginsLoaded();
		}
		
		private function onPluginError( event : IOErrorEvent ) :void
		{
			event.target.removeEventListener(  IOErrorEvent.IO_ERROR  , onPluginError );
			trace("error loading plug-in: " + event.text);
			--_loadingQ;
			
			//if all plugin loaded
			dispatchAllPluginsLoaded();
		}
	}
}
internal class Singleton{};