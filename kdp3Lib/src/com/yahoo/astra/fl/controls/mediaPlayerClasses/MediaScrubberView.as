/*
Copyright (c) 2009 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
﻿package com.yahoo.astra.fl.controls.mediaPlayerClasses
{
	import com.yahoo.astra.fl.events.MediaEvent;
	import flash.display.DisplayObjectContainer;
	import fl.core.UIComponent;
	import fl.controls.BaseButton;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;	
	import flash.events.ProgressEvent;
	import fl.events.ComponentEvent;

    //--------------------------------------
    //  Class Description
    //--------------------------------------	
    
    /**
     * MediaScrubber extends MediaView implements IMediaView and creates a slider to control 
     * cueing and rewinding for a media clip.
     *
     * @see com.yahoo.astra.fl.controls.mediaPlayerClasses.MediaView
     * @see com.yahoo.astra.fl.controls.mediaPlayerClasses.IMediaView
	 *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
     * @author Dwight Bridges	 
	 */
	public class MediaScrubberView extends MediaView implements IMediaView
	{			

    //--------------------------------------
    //  Constructor
    //--------------------------------------
    
		/**
		 * Constructor
		 * @param container display object container that the MediaScrubberView will be added to
		 * @param model media clip that the MediaScrubberView will observe
		 * @param controller media controller that will handle user input from the MediaScrubberView
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		public function MediaScrubberView(container:DisplayObjectContainer = null, model:IMediaClip = null, controller:IMediaController = null)
		{
			super(container, model, controller);

			_scrubbing = false;
			
			_durationIndicator = getDisplayObjectInstance(getStyleValue("durationIndicatorSkin")) as Sprite;
			_durationIndicator.width = width;
			addChild(_durationIndicator);
			_loadIndicator = getDisplayObjectInstance(getStyleValue("loadIndicator")) as Sprite;
			_loadIndicator.width = 0;
			addChild(_loadIndicator);
			_progressIndicator = getDisplayObjectInstance(getStyleValue("progressIndicator")) as Sprite;
			_progressIndicator.width = 0;
			addChild(_progressIndicator);
			_clickStrip = getDisplayObjectInstance(getStyleValue("progressIndicator")) as Sprite;
			_clickStrip.width = 0;
			_clickStrip.alpha = 0;
			_clickStrip.addEventListener(MouseEvent.MOUSE_DOWN, clickStripHandler);
			addChild(_clickStrip);
			_scrubButton = new BaseButton();
			setChildStyles(_scrubButton, defaultKnobStyles);
			_scrubButton.addEventListener(MouseEvent.MOUSE_DOWN, scrubButtonMouseDownHandler);
			addChild(_scrubButton);	
			addEventListener(ComponentEvent.RESIZE, resizeEventHandler);
		}
		
    //--------------------------------------
    //  Properties
    //--------------------------------------
    
		/**
		 * @private (protected)
		 * background bar for the MediaScrubber
		 */
		protected var _durationIndicator:Sprite;
		
		/**
		 * @private (protected)
		 * bar indicating the percentage of the media that has loaded
		 */		
		protected var _loadIndicator:Sprite;

		/**
		 * @private (protected)
		 * bar indicating the progress of the media's playback
		 */
		protected var _progressIndicator:Sprite;

		/**
		 * @private (protected)
		 * knob used to seek the media
		 */
		protected var _scrubButton:BaseButton;

		/**
		 * @private (protected)
		 * hot spot for clicking to seek the media
		 */
		protected var _clickStrip:Sprite;
		
		/**
		 * @private (protected)
		 * distance that the _scrubButton can travel  
		 * Equal to the _durationIndicator's width minus the _scrubButton
		 */
		protected var _range:Number;

		/**
		 * @private (protected)
		 * boolean indicating whether or not the user is scrubbing the media  
		 */
		protected var _scrubbing:Boolean;

		/**
		 * @private (protected)
		 * indicates the x coordinate of the _scrubButton that user pressed
		 */
		protected var _mouseDownX:Number;

		/**
		 * @private (protected)
		 * indicates the amount of space to the right of the cursor on the _scrubButton
		 */
		protected var _mouseDownRightPadding:Number;
		
		/**
		 * @private
		 */
		private static var defaultStyles:Object = {
			durationIndicatorSkin:"scrub_durationSkin",
			loadIndicator:"scrub_loadSkin",
			progressIndicator:"scrub_progressSkin"
		};			
		
		/**
		 * @private 
		 */
		protected static var defaultKnobStyles:Object = {
			upSkin:"scrubButton_upSkin",
			downSkin:"scrubButton_downSkin",
			overSkin:"scrubButton_overSkin",
			disabledSkin:"scrubButton_upSkin",
			selectedDisabledSkin:"scrubButton_upSkin",
			selectedUpSkin:"scrubButton_upSkin",
			selectedDownSkin:"scrubButton_downSkin",
			selectedOverSkin:"scrubButton_overSkin"						
		}

		/**
		 * @private (protected)
		 */
		protected var _loaded:Boolean = false;
		
    //--------------------------------------
    //  Public Methods
    //--------------------------------------
    
		/**
		 * Gets the styles for the component
		 *
		 * @return defaultStyles
		 */
		public static function getStyleDefinition():Object
		{
			return defaultStyles;
		}			
		
    //--------------------------------------
    //  Protected Methods
    //--------------------------------------
		
		/**
		 * @private (protected)
		 *
		 * Sizes and positions all elements of the MediaControlsView.  
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0 
		 */
		protected function resizeEventHandler(event:ComponentEvent):void
		{
			if(_loaded) _clickStrip.width = _loadIndicator.width = width;	
			_durationIndicator.width = width;	
			_range = width - _scrubButton.width;
			_progressIndicator.height = _durationIndicator.height =  _loadIndicator.height = height/4;
			_progressIndicator.y = _durationIndicator.y = _loadIndicator.y = (height - _durationIndicator.height)/2;
			_clickStrip.height = height;
			_clickStrip.y = 0;
			_scrubButton.height = _scrubButton.width = height/2;
			_scrubButton.y = (height - _scrubButton.height)/2;	
			_range = width - _scrubButton.width;
		}
    
		/**
		 * @private (protected)
		 *
		 * @param event MouseEvent
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		protected function clickStripHandler(event:MouseEvent):void
		{
			//move the _scrubButton to the area that was pressed
			//move the _progress indicator to the area that was pressed
			//pass event to the scrubButtonMouseHandler			
			_scrubButton.x = Math.max(0, Math.min(_range, mouseX - (_scrubButton.width/2)));
			_progressIndicator.width = _scrubButton.x + _scrubButton.width/2;
			scrubButtonMouseDownHandler(event);
		}
		
		/**
		 * @private (protected)
		 */
		override protected function addListeners():void
		{
		 	//attach event listeners to the after it has been set
			_model.addEventListener(ProgressEvent.PROGRESS , progressUpdateHandler);
			_model.addEventListener(MediaEvent.MEDIA_POSITION, mediaPositionUpdateHandler);
		}
		
		/**
		 * @private (protected)
		 */
		override protected function removeListeners():void
		{
		 	//remove event listeners from the _model before a new _model is set 			
			_model.removeEventListener(ProgressEvent.PROGRESS , progressUpdateHandler);
			_model.removeEventListener(MediaEvent.MEDIA_POSITION, mediaPositionUpdateHandler);
		}		
		
		/**
		 * @private (protected)
		 *
		 * @param event MediaEvent
		 */
		public function mediaPositionUpdateHandler(event:MediaEvent):void
		{
		 	//moves the _scrubButton and _progressIndicator to represent the correct position of the media's playhead
		 	//attached to the MEDIA_POSITION event dispatched by the _model		
			if(!_scrubbing) 
			{
				if(!isNaN(event.position/event.duration * _range))
				{
					_scrubButton.x = event.position/event.duration * _range;
					_progressIndicator.width = _scrubButton.x + _scrubButton.width/2;
				}
				else if(event.position == 0)
				{
					_scrubButton.x  = _progressIndicator.width = 0;
				}
			}
		}
		
		/**
		 * @private (protected)
		 *
		 * @param event MouseEvent
		 */		 
		protected function scrubButtonMouseDownHandler(event:MouseEvent):void
		{
		 	//set _scrubbing to true
		 	//set the value of _mouseDownX and _mouseDownRightPadding
		 	//pause the media through the controller
		 	//add MOUSE_UP and MOUSE_MOVE listeners			
			_scrubbing = true;
			_mouseDownX = _scrubButton.mouseX;
			_mouseDownRightPadding = _scrubButton.width - _mouseDownX;
			//_controller.stop();
			this.stage.addEventListener(MouseEvent.MOUSE_UP, scrubButtonMouseUpHandler, false, 0, true);
			this.stage.addEventListener(MouseEvent.MOUSE_MOVE, scrubButtonMouseMoveHandler, false, 0, true);
		}

		/**
		 * @private (protected)
		 *
		 * @param event MouseEvent
		 */	
		protected function scrubButtonMouseUpHandler(event:MouseEvent):void
		{
			//set _scrubbing to false
			//remove the MOUSE_UP and MOUSE_DOWN listeners 
			//seek the media through the controller			
			_scrubbing = false;
			this.stage.removeEventListener(MouseEvent.MOUSE_UP, scrubButtonMouseUpHandler);
			this.stage.removeEventListener(MouseEvent.MOUSE_MOVE, scrubButtonMouseMoveHandler);
			//_controller.seek(_scrubButton.x/_range);
		}
		
		/**
		 * @private (protected)
		 *
		 * @param event MouseEvent
		 */	
		protected function scrubButtonMouseMoveHandler(event:MouseEvent):void
		{
		 	//attached to the MOUSE_MOVE event of the _scrubButton
		 	//moves the _scrubButton and adjusts the _progressIndicator with the position of the mouse
			_scrubButton.x = Math.max(0, Math.min((_loadIndicator.width - _scrubButton.width), (mouseX - _mouseDownX)));
			_progressIndicator.width = _scrubButton.x + _scrubButton.width/2;
			event.updateAfterEvent();
		}
		
		/**
		 * @private (protected)
		 *
		 * @param event ProgressEvent
		 */	
		protected function progressUpdateHandler(event:ProgressEvent):void
		{
			//update the _loadIndicator and _clickStrip width with percentage of the media that has loaded	
			_clickStrip.width = _loadIndicator.width = Math.min((event.bytesLoaded/event.bytesTotal)*width, width);	
			if(event.bytesLoaded >= event.bytesTotal)
			{
				_loaded = true;
			}
			else
			{
				_loaded = false;
			}
		}		
	}	
}