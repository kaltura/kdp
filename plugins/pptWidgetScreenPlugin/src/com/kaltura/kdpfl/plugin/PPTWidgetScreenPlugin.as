package com.kaltura.kdpfl.plugin 
{
	import com.kaltura.kdpfl.model.type.NotificationType;
	
	import fl.core.UIComponent;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.SecurityDomain;
	
	import org.puremvc.as3.interfaces.IFacade;

	/**
	 * Class PPTWidgetScreenPlugin manages the ppt page to the right of the video.
	 * @author Hila
	 * 
	 */	
	public class PPTWidgetScreenPlugin extends UIComponent implements IPlugin
	{
		protected var _facade:IFacade;
		
		//ppt widget changes - august 2011
		protected var _loader:Loader = new Loader();
		protected var _presentationPath : String;
		protected var _presentationMC : MovieClip;
		protected var _currentFrame : int;
		protected var _presentationLoaded : Boolean;
		
		public function PPTWidgetScreenPlugin():void
		{
		}
	
		public function setSkin(styleName:String, setSkinSize:Boolean=false):void { }
		/**
		 * Initialize process of the plugin. Sets the facade and ads the ppt bitmap image to the stage. 
		 * @param facade the facade of the application.
		 * 
		 */		
		public function initializePlugin(facade:IFacade):void
		{
			_facade = facade;
			addChild(_loader);
			
		}
		
		protected function onPresentationLoaded (e : Event) : void
		{
			presentationLoaded = true;
			_loader.width = this.width;
			_loader.height = this.height;
			repositionDocument();
			(_loader.content as MovieClip).gotoAndStop(currentFrame);
		}
		
		protected function onPresentationLoadError (e : IOErrorEvent) : void
		{
			_facade.sendNotification (NotificationType.ALERT, {title: "An error occured", message: "The document could not be loaded."});
		}

		/**
		 * Function to reposition the bitmap image when its width or height are changed. 
		 * 
		 */		
		private function repositionDocument() : void
		{
			_loader.x = (parent.width - _loader.width) / 2;
			_loader.y = (parent.height - _loader.height) / 2;
		}
		/**
		 * The override of the width setter also sets the size of the bitmap image. 
		 * @param value new width of the plugin.
		 * 
		 */		
		override public function set width(value:Number):void
		{
			super.width = value;
			if (_loader.width != parent.width)
			{
				_loader.width = parent.width;
			}
			repositionDocument();
		}
		/**
		 * The override of the height setter also sets the height of the bitmap image. 
		 * @param value the new height of the plugin.
		 * 
		 */		
		override public function set height(value:Number):void
		{
			super.height = value;
			if (_loader.height != parent.height)
			{
				_loader.height = parent.height;
			}
			repositionDocument();
		}
		
		[Bindable]
		public function get presentationPath():String
		{
			return _presentationPath;
		}

		public function set presentationPath(value:String):void
		{
			if (value == _presentationPath)
			{
				return;
			}
			
			_presentationPath = value;
			
			if (_presentationPath && _presentationPath != "")
			{
				presentationLoaded = false;
				_loader.contentLoaderInfo.addEventListener( Event.COMPLETE, onPresentationLoaded );
				_loader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, onPresentationLoadError );
				_loader.load( new URLRequest(presentationPath) ,new LoaderContext(true, ApplicationDomain.currentDomain, SecurityDomain.currentDomain));
			}
		}
		[Bindable]
		public function get currentFrame():int
		{
			return _currentFrame;
		}

		public function set currentFrame(value:int):void
		{
			_currentFrame = value;
			
			if (_currentFrame && (_loader.content as MovieClip) && (_loader.content as MovieClip).totalFrames)
			{
				(_loader.content as MovieClip).gotoAndStop(_currentFrame);
			}
		}
		
		
		public function get presentationLoaded():Boolean
		{
			return _presentationLoaded;
		}
		[Bindable]
		public function set presentationLoaded(value:Boolean):void
		{
			_presentationLoaded = value;
		}
		[Bindable]
		public function get presentationMC():MovieClip
		{
			return _presentationMC;
		}

		public function set presentationMC(value:MovieClip):void
		{
			_presentationMC = value;
			
			if (_presentationMC)
			{
				presentationLoaded = false;
				_loader.contentLoaderInfo.addEventListener( Event.COMPLETE, onPresentationLoaded );
				_loader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, onPresentationLoadError );
				_loader.loadBytes( _presentationMC.loaderInfo.bytes );
			}
		}
		



	}
}