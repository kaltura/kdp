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
	import flash.utils.getDefinitionByName;
	import flash.display.DisplayObject;

	/**
	 * Class PPTWidgetScreenPlugin manages the ppt page to the right of the video.
	 * @author Hila
	 * 
	 */	
	public class PPTWidgetScreenPluginCode extends UIComponent implements IPlugin
	{
		protected var _facade:IFacade;
		
		//ppt widget changes - august 2011
		protected var _loader:Loader = new Loader();
		protected var _presentationPath : String;
		protected var _presentationMC : MovieClip;
		protected var _currentFrame : int;
		protected var _presentationLoaded : Boolean;
		
		private var _mediator:PPTWidgetScreenMediator;
		private var _isLoading:Boolean = false;
		/**
		 * skin className for the loading animation
		 * */
		public var spinnerClass : String = "kspin";
		/**
		 * loading animation
		 * */
		private var _animInst:DisplayObject;
		
		
		public function PPTWidgetScreenPluginCode():void
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
			setBufferingAnimation(spinnerClass);
			_mediator = new PPTWidgetScreenMediator(this);
			_facade.registerMediator (_mediator);
			
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
			if (_animInst)
			{
				_animInst.x = (parent.width - _animInst.width) / 2;
				_animInst.y = (parent.height - _animInst.height) / 2;
			}
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
		
		[Bindable]
		/**
		 * indicates if slides are being loaded,
		 * when false, slides are ready
		 * */
		public function get isLoading():Boolean
		{
			return _isLoading;
		}
		
		public function set isLoading(value:Boolean):void 
		{
			_isLoading = value;
			_loader.visible = !value;
			if (_animInst)
				_animInst.visible = value;
		}
		
		/**
		 * Creates loading animation according to given className
		 * Adds the loading animation
		 */
		private function setBufferingAnimation(className : String) : void
		{
			try {
				var anim:Class = getDefinitionByName(className) as Class;
			} catch ( e : Error ){
				trace("couldn't find needed class:", className);
				return; //if the class don't exist stay with the loading label when showing the loader
			}
			
			// add an animation instead
			_animInst = new anim();
			addChild (_animInst);
		}
		



	}
}