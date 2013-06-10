package com.kaltura.kdpfl.view.media
{
	import com.kaltura.kdpfl.component.IComponent;
	import com.kaltura.kdpfl.view.controls.KTrace;
	
	import fl.core.UIComponent;
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.SecurityDomain;

	public dynamic class KThumbnail extends UIComponent implements IComponent
	{
		public static const THUMBNAIL_LOADED : String = "thumbnailLoaded";
		/**
		 * a loader to load the Image 
		 */		
		private var _loader : Loader;
		/**
		 * image URL 
		 */		
		private var _url : String;
		/**
		 * Only once try to load the defualt no image thumbnail 
		 */		
		private var _firstTimeIOError : Boolean = true;
		
		/**
		 *The flashvars of the KDP 
		 */		
		private var _flashvars : Object;
		
		/**
		 * if there is no thumbnail url load this
		 */		
		public var noThumbnailUrl : String = "assets/no_thumbnail.jpg";
		/**
		 *If the player is running from the file system, use a securityDomain in the loader context of the thumbnail. 
		 */		
		public var isFileSystemMode : Boolean;
		
		/**
		 * should keep original thumb aspect ratio 
		 */		
		public var keepAspectRatio : Boolean;
		
		public var originalWidth : Number;
		public var originalHeight : Number;
		
		/**
		 * Prepearing and adding the thumbnail to the displaylist 
		 * 
		 */			
		public function KThumbnail()
		{
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE , onThumbLoaded );
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR , onIOError );
			_loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR , onSecurityErrorEvent );
			addChild( _loader );
		}
		
		public function initialize() : void {}
		public function setSkin( styleName : String , setSkinSize : Boolean = false) : void {}	
		
		public function load( url : String ) : void
		{
			if(url)
			{
				_url = url;
				var loaderContext : LoaderContext;
				var urlReq : URLRequest = new URLRequest( url );
				if (isFileSystemMode)
					loaderContext = new LoaderContext(true,ApplicationDomain.currentDomain);
				else
					loaderContext = new LoaderContext(true,ApplicationDomain.currentDomain, SecurityDomain.currentDomain);
				_loader.load(urlReq, loaderContext);
			}
			else
				onIOError(); //load default thumbnail
		}
		
		public function unload() : void
		{
			_loader.unload();
		}

		[Bindable]
		public function set url( imageUrl : String ) : void
		{
			if(imageUrl && imageUrl!=_url)
			{
				_url = imageUrl;
				load( url );
			}
		}
		public function get url() : String
		{
			return( _url );
		}
		
		override public function set width( value : Number ) : void
		{
			super.width = value;
			if(_loader && _loader.content) 
				_loader.content.width = value;
		}
		
		override public function set height(value:Number) : void
		{
			super.height = value;
			
			if(_loader && _loader.content) 
				_loader.content.height = value;
		}
		
		private function onThumbLoaded( event : Event ) : void
		{
			if(_loader.content)
			{
				if (keepAspectRatio) 
				{
					originalWidth = _loader.content.width;
					originalHeight = _loader.content.height
				}
				else
				{
					_loader.content.width = this.width;
					_loader.content.height = this.height;
				}
			}
			dispatchEvent( new Event( THUMBNAIL_LOADED ) );
		}
				
		//We must implement IO Error to any case somwone is closing the browser in the middle of
		//Loading, if not it might crash the browser.
		private function onIOError( event : IOErrorEvent  = null ) : void
		{	
			if(_firstTimeIOError)
			{
				_firstTimeIOError = false;
				var loaderContext : LoaderContext = new LoaderContext(true,ApplicationDomain.currentDomain);
			}
		}
		
		private function onSecurityErrorEvent (event : SecurityErrorEvent = null) : void
		{
			KTrace.getInstance().log("Security error has occurred");
			//trace ("Security error has occurred");
		}
	}
}