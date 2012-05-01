package com.kaltura.kdpfl.plugin 
{
	import com.kaltura.kdpfl.model.MediaProxy;
	import com.kaltura.kdpfl.view.controls.KScrubber;
	
	import flash.events.*;
	
	import org.puremvc.as3.interfaces.IFacade;
	
	/**
	 * Class PPTWidgetScrubberPlugin manages the custom scrubber 
	 * of the player, which includes synchronization with the ppt swf. 
	 * @author Hila
	 * 
	 */	
	public dynamic class PPTWidgetScrubber extends KScrubber implements IPlugin
	{	
		
		
		
		protected var _facade:IFacade;
		
		/**
		 * Container of the individual markers of the sync points. 
		 */		
		protected var _videoMarksContainer:PPTWidgetVideoMarksContainer;
		
		/**
		 *  Boolean indicating that a marker (doesn't matter which) is currently selected. Used to indicate to the
		 * 	Removal button whether it should be enabled. 
		 */		
		protected var _hasSelectedMarker : Boolean = false;
		
		protected var _syncPointVisibility : Boolean = true;
		
		/**
		 *Constructor 
		 * 
		 */		
		public function PPTWidgetScrubber():void
		{
			super();
		}
		/**
		 * Initializes the ppt video markers (sync point markers) container and registers the plugin
		 * mediator. 
		 * @param facade
		 * 
		 */		
		public function initializePlugin(facade:IFacade):void
		{
			_facade = facade;
			var mediaProxy:MediaProxy = (_facade.retrieveProxy(MediaProxy.NAME) as MediaProxy);
			_videoMarksContainer = new PPTWidgetVideoMarksContainer();
			_facade.registerMediator(new PPTWidgetScrubberMediator(this));
			
			addChild(_videoMarksContainer);
			
			_videoMarksContainer.visible = _syncPointVisibility;
			
			//_loadIndicator
			//_progressIndicator
		}
		
		/**
		 * Override and change the y coordinates of the scrubber assets (bottom instead of middle)
		 */
		override protected function drawLayout():void
		{
			super.drawLayout();
			
			_progressIndicator.y = _durationIndicator.y = _loadIndicator.y = (height - _durationIndicator.height);
			_clickStrip.y = _durationIndicator.y;
			_thumb.y = (height - _thumb.height);	
			   
		}
			
		public function get videoMarksContainer():PPTWidgetVideoMarksContainer
		{
			return _videoMarksContainer;
		}
		
		[Bindable]
		public function get hasSelectedMarker():Boolean
		{
			return _hasSelectedMarker;
		}
		
		public function set hasSelectedMarker(value:Boolean):void
		{
			_hasSelectedMarker = value;
		}

		override public function set width(value:Number):void
		{
			super.width = value;
			_videoMarksContainer.width = value;
		}
		
		
		public function set syncPointVisibility (visible : String) : void
		{
			if ( visible == "false")
			{
				_syncPointVisibility = false;
			}
			else
			{
				_syncPointVisibility = true;
			}
		}
		
		public function get syncPointVisibility () : String
		{
			 return _syncPointVisibility.toString();
		}
		
	}
}