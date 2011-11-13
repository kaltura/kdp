package com.kaltura.kdpfl.plugin
{
	import com.kaltura.kdpfl.util.KdpEmbeddedData;
	
	import flash.display.Loader;
	import flash.events.AsyncErrorEvent;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.SecurityDomain;
	import flash.utils.ByteArray;

	public class PluginLoader extends EventDispatcher
	{
		/**
		 * the loader that loades the plugin 
		 */		
		private var _loader : Loader;
		
		/**
		 * the url of the plugin
		 */
		private var _url:String;
		
		private var _loaded:Boolean;
		
	    /**
	     * 
	     * @return 
	     * 
	     */
	    public function get loaded():Boolean
	    {
	        return _loaded;
	    }

		/**
		 *  @private
		 *  Storage for the ready property.
		 */
		private var _ready:Boolean = false;
		
		/**
		 *  @private
		 */
		public function get ready():Boolean
		{
		return _ready;
		}
		
		/**
		 * reference count for managing multiple loads of same plugin
		 */
		private var numReferences:int;
		
	    /**
	     *  @private
	     */
	    public function addReference():void
	    {
	        ++numReferences;
	    }
	
	    /**
	     *  @private
	     */
	    public function removeReference():void
	    {
	        --numReferences;
	        //xxx if (numReferences == 0)
	            //xxx release();
	    }
		
		public function PluginLoader(url:String)
		{
			super();
			_url = url;
			_loader = new Loader();
			addLoaderListeners();
		}
		
		public function get content() : *//IPlugin
		{
			return _loader.content;// as IPlugin;
		}
				
		public function get url() : String
		{
			if(_loader && _loader.loaderInfo)
				return _loader.loaderInfo.url;
			return "";
		}
		
		public function load( byPass : Boolean = false) : void
		{
			if (_loaded)
				return;
				
			_loaded = true;
			
			var context:LoaderContext = new LoaderContext( true, ApplicationDomain.currentDomain );
		
			if(!byPass)
				context.securityDomain = SecurityDomain.currentDomain;
				
			//trace("load plug-in:" + _url);
			
			var ba:ByteArray = KdpEmbeddedData.getData(_url);
			if (ba) // if bytes are supplied, then load the bytes instead of loading from the url.
			{
				//trace("load from embedded data:" + _url);
				context.checkPolicyFile = false;
				_loader.loadBytes(ba, context );
			}
			else
			{
				var urlReq : URLRequest = new URLRequest( _url );

				_loader.load( urlReq, context );

			}
		}
		
		//protected functions
		/////////////////////////////////
		protected function onPluginReady(  event : Event ) : void
		{
			_ready = true;	
			removeLoaderListeners();
			dispatchEvent( event );
		}
		
		protected function onIoError( event : Event ) : void
		{
			 removeLoaderListeners();
			 dispatchEvent( event );
		}
		
		//private functions
		/////////////////////////////////
		private function addLoaderListeners() : void
		{
			_loader.contentLoaderInfo.addEventListener( Event.COMPLETE , onPluginReady );
			_loader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR , onIoError );
			_loader.contentLoaderInfo.addEventListener( SecurityErrorEvent.SECURITY_ERROR, onIoError );
			_loader.contentLoaderInfo.addEventListener( ErrorEvent.ERROR, onIoError );
			_loader.contentLoaderInfo.addEventListener( AsyncErrorEvent.ASYNC_ERROR, onIoError );
		}
		
		private function removeLoaderListeners( ) : void
		{
			_loader.contentLoaderInfo.removeEventListener( Event.COMPLETE , onPluginReady );
			_loader.contentLoaderInfo.removeEventListener( IOErrorEvent.IO_ERROR , onIoError );
			_loader.contentLoaderInfo.removeEventListener( SecurityErrorEvent.SECURITY_ERROR, onIoError );
			_loader.contentLoaderInfo.removeEventListener( AsyncErrorEvent.ASYNC_ERROR, onIoError );
			_loader.contentLoaderInfo.removeEventListener( ErrorEvent.ERROR, onIoError );
		}
		
	}
}