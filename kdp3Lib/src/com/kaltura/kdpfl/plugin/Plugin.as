package com.kaltura.kdpfl.plugin
{
	import com.kaltura.kdpfl.view.containers.KVBox;
	
	import flash.events.AsyncErrorEvent;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;

	public class Plugin extends KVBox
	{
		/**
		 * the loader that loades the plugin 
		 */		
		private var _loader : PluginLoader;
		
		/**
		 * name of plugin in case there are multiple plugins within the same swf 
		 */
		private var _pluginName : String;
		
		private var _content: IPlugin;
		
		/**
		 * This xml is saved in order to bind the current xml attributes of this plugin
		 * when the plug in has finish loaded
		 */		
		public var xml : XML;
		
		/**
		 * save the item renderer data scope if exist to pass it to the plug in when loaded
		 */		
		public var itemRendererData : Object;
		
		public function Plugin(loader:PluginLoader, pluginName : String = null)
		{	
			super();
			_loader = loader;
			_pluginName = pluginName;
			addLoaderListeners();
		}
		
		public function get content() : IPlugin
		{
			return _content;
		}
				
		public function get url() : String
		{
			return _loader.url;
		}
		
		public function load( byPass : Boolean = false) : void
		{
			_loader.addReference();
			if (_loader.loaded)
			{
				if (_loader.ready)
				{
					onPluginReady(new Event(Event.COMPLETE));	
			 	}
			}
			else
				_loader.load(byPass);
		}
		
		//protected functions
		/////////////////////////////////
		protected function onPluginReady(  event : Event ) : void
		{	
	        try
	        {
	        	_content = (_loader.content as IPluginFactory).create(_pluginName);
				removeLoaderListeners();
				var config : Object = new Object();
				config.target = _content;
				config.percentWidth = 100;
				config.percentHeight = 100;
				this.configuration = [config]; //add child and set config
				dispatchEvent( event );
	        }
	        catch(error:Error)
	        {
	        	trace("onPluginReady ", error);
	        }
		}
		
		
		protected function onError( event : ErrorEvent ) : void
		{
			 removeLoaderListeners();
			 dispatchEvent( event );
		}
		
		//private functions
		/////////////////////////////////
		private function addLoaderListeners() : void
		{
			_loader.addEventListener( Event.COMPLETE , onPluginReady );
			_loader.addEventListener( IOErrorEvent.IO_ERROR , onError );
			_loader.addEventListener( SecurityErrorEvent.SECURITY_ERROR , onError );
			_loader.addEventListener( ErrorEvent.ERROR , onError );
			_loader.addEventListener( AsyncErrorEvent.ASYNC_ERROR , onError );
		}
		
		private function removeLoaderListeners( ) : void
		{
			_loader.removeEventListener( Event.COMPLETE , onPluginReady );
			_loader.removeEventListener( IOErrorEvent.IO_ERROR , onError );
			_loader.removeEventListener( SecurityErrorEvent.SECURITY_ERROR , onError );
			_loader.removeEventListener( ErrorEvent.ERROR , onError );
			_loader.removeEventListener( AsyncErrorEvent.ASYNC_ERROR , onError );
		}
		
	}
}