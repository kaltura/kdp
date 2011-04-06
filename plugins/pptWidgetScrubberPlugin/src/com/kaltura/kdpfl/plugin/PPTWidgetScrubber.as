package com.kaltura.kdpfl.plugin 
{
	import com.kaltura.KalturaClient;
	import com.kaltura.commands.baseEntry.BaseEntryGet;
	import com.kaltura.events.KalturaEvent;
	import com.kaltura.kdpfl.model.MediaProxy;
	import com.kaltura.kdpfl.model.ServicesProxy;
	import com.kaltura.kdpfl.view.controls.KScrubber;
	import com.kaltura.kdpfl.view.controls.ScrubberMediator;
	import com.kaltura.vo.KalturaBaseEntry;
	import com.kaltura.vo.KalturaDocumentEntry;
	import com.kaltura.vo.KalturaMediaEntry;
	import com.yahoo.astra.fl.charts.axes.NumericAxis;
	
	import fl.controls.Button;
	import fl.core.UIComponent;
	import fl.data.DataProvider;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.Video;
	import flash.net.URLRequest;
	import flash.system.Security;
	
	import org.puremvc.as3.interfaces.IFacade;
	
	/**
	 * Class PPTWidgetScrubberPlugin manages the custom scrubber of the player, which includes synchronization with the ppt swf. 
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
		
	}
}