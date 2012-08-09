/*
Copyright (c) 2009 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
﻿package com.yahoo.astra.fl.controls.mediaPlayerClasses
{
	import com.yahoo.astra.fl.events.MediaEvent;
	
	import fl.controls.BaseButton;
	import fl.core.UIComponent;
	import fl.events.ComponentEvent;
	import fl.managers.IFocusManagerComponent;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;

    //--------------------------------------
    //  Class Description
    //--------------------------------------	
    
    /**
     * VolumeSlider extends MediaView implements IMediaView and creates a slider to control 
     * volume for a media clip.
	 *
     * @see com.yahoo.astra.fl.controls.mediaPlayerClasses.MediaView
     * @see com.yahoo.astra.fl.controls.mediaPlayerClasses.IMediaView
	 *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
     * @author Dwight Bridges	 
	 */
	
	public class VolumeSlider extends MediaView implements IMediaView, IFocusManagerComponent
	{		

    //--------------------------------------
    //  Constructor
    //--------------------------------------
    
		/**
		 * Constructor
		 * @param container display object container that the VolumeSlider will be added to
		 * @param model media clip that the VolumeSlider will observe
		 * @param controller media controller that will handle user input from the VolumeSlider
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		public function VolumeSlider(container:DisplayObjectContainer = null, model:IMediaClip = null, controller:IMediaController = null)
		{
			super(container, model, controller);
			_background = getDisplayObjectInstance(getStyleValue("background_skin")) as Sprite;
			addChild(_background);

			_indicator = getDisplayObjectInstance(getStyleValue("indicator_skin")) as Sprite;
			_indicator.addEventListener(MouseEvent.MOUSE_DOWN, indicatorMouseDownHandler);
			addChild(_indicator);

			_clickStrip = getDisplayObjectInstance(getStyleValue("background_skin")) as Sprite;
			_clickStrip.addEventListener(MouseEvent.MOUSE_DOWN, indicatorMouseDownHandler);
			addChild(_clickStrip);

			_slider = new BaseButton();
			setChildStyles(_slider, defaultKnobStyles);
			_slider.addEventListener(MouseEvent.MOUSE_DOWN, sliderMouseDownHandler);
			addChild(_slider);

			_backgroundMask = getDisplayObjectInstance(getStyleValue("backgroundMaskSkin")) as Sprite;

			if(_backgroundMask != null)
			{
				addChild(_backgroundMask);
				_background.cacheAsBitmap = _backgroundMask.cacheAsBitmap = true;
				_background.mask = _backgroundMask;	
			}
			_indicatorMask = getDisplayObjectInstance(getStyleValue("indicatorMaskSkin")) as Sprite;
			if(_indicatorMask != null)
			{
				addChild(_indicatorMask);
				_indicator.cacheAsBitmap = _indicatorMask.cacheAsBitmap = true;
				_indicator.mask = _indicatorMask;			
			}
			_knobMask = getDisplayObjectInstance(getStyleValue("knobMaskSkin")) as Sprite;
			if(_knobMask != null)
			{
				addChild(_knobMask);
				_slider.cacheAsBitmap = _knobMask.cacheAsBitmap = true;
				_slider.mask = _knobMask;
			}
			addEventListener(ComponentEvent.RESIZE, resizeEventHandler);
			
			
		}
		
    //--------------------------------------
    //  Properties
    //--------------------------------------			
		 
		/**
		 * @private (protected)
		 */
		protected var _background:Sprite;

		/**
		 * @private (protected)
		 */		
		protected var _slider:BaseButton;

		/**
		 * @private (protected)
		 */
		protected var _indicator:Sprite;
		
		/**
		 * @private (protected)
		 */
		protected var _clickStrip:Sprite;
		
		/**
		 * @private (protected)
		 */
		protected var _backgroundMask:Sprite;
		
		/**
		 * @private
		 */
		protected var _indicatorMask:Sprite;
		
		/**
		 * @private
		 */
		protected var _knobMask:Sprite;		
		
		/**
		 * @private (protected)
		 * indicates the x coordinate of the _slider that user pressed
		 */
		protected var _mouseDownX:Number;

		/**
		 * @private (protected)
		 * indicates the amount of space to the right of the cursor on the _slider
		 */
		protected var _mouseDownRightPadding:Number;
		
		/**
		 * @private (protected)
		 */
		protected var _range:Number;
		
		/**
		 * @private
		 */
		private static var defaultStyles:Object = {
			background_skin:"volumeBackground_skin",
			indicator_skin:"volumeIndicator_skin",
			backgroundMaskSkin:"volumeBackground_mask",
			indicatorMaskSkin:"volumeIndicator_mask",
			knobMaskSkin:"volumeKnob_mask"
		};		
		
		/**
		 * @private 
		 */
		protected static var defaultKnobStyles:Object = {
			upSkin:"volumeKnob_upSkin",
			downSkin:"volumeKnob_downSkin",
			overSkin:"volumeKnob_overSkin",
			disabledSkin:"volumeKnob_upSkin",
			selectedDisabledSkin:"volumeKnob_upSkin",
			selectedUpSkin:"volumeKnob_upSkin",
			selectedDownSkin:"volumeKnob_downSkin",
			selectedOverSkin:"volumeKnob_overSkin"						
		}
		
	//--------------------------------------------------------------------------
	//
	//  Class mixins
	//
	//--------------------------------------------------------------------------
	
	/**
	* Placeholder for mixin by VolumeSliderAccImpl.
	*/
	public static var createAccessibilityImplementation:Function;	

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
			return mergeStyles(defaultStyles, UIComponent.getStyleDefinition());
		}			
		
		/**
		 * Sets the volume 
		 *
		 * @param value Number A number between 0 and 1
		 */
		public function set volume(value:Number):void
		{
			//_controller.setVolume(value);
			var changeEvent:Event = new Event(Event.CHANGE);
			dispatchEvent(changeEvent );
		}
		
		/**
		 * Gets the volume 
		 *
		 * @return The media clip's volume, from 0 to 1
		 */
		public function get volume():Number
		{
			return _controller.getVolume();
		}
		/**
		 * @private (protected)
		 */
		override protected function addListeners():void
		{
			//attach listener to the MediaEvent.VOLUME_CHANGE
			_model.addEventListener(MediaEvent.VOLUME_CHANGE, volumeChangeHandler);
		}
		
		/**
		 * @private (protected)
		 */
		override protected function removeListeners():void
		{
			//remove listener
			_model.removeEventListener(MediaEvent.VOLUME_CHANGE, volumeChangeHandler);
		}
		
		/**
		 * @private (protected)
		 */
		protected function sliderMouseDownHandler(event:MouseEvent):void
		{
			_mouseDownX = _slider.mouseX;
			_mouseDownRightPadding = _slider.width - _mouseDownX;
			this.stage.addEventListener(MouseEvent.MOUSE_UP, sliderMouseUpHandler, false, 0, true);
			this.stage.addEventListener(MouseEvent.MOUSE_MOVE, sliderMouseMoveHandler, false, 0, true);			
		}

		/**
		 * @private (protected)
		 */
		protected function sliderMouseUpHandler(event:MouseEvent):void
		{
			this.stage.removeEventListener(MouseEvent.MOUSE_UP, sliderMouseUpHandler);
			this.stage.removeEventListener(MouseEvent.MOUSE_MOVE, sliderMouseMoveHandler);				
		}
		
		/**
		 * @private (protected)
		 */
		protected function sliderMouseMoveHandler(event:MouseEvent):void
		{
			if(mouseX - _mouseDownX <= 0)
			{	
				_slider.x = 0;
				_indicator.width = 0;
			}
			else if(mouseX - _mouseDownRightPadding >= _range)
			{
				_slider.x = _range;
				_indicator.width = width;
			}
			else
			{
				_slider.x = mouseX - _mouseDownX;
				_indicator.width = _slider.x + _slider.width/2;
			}	
			event.updateAfterEvent();
			volume = Math.round((_slider.x/_range)*100)/100;
		}
		
		/**
		 * @private (protected)
		 */
		protected function volumeChangeHandler(event:MediaEvent):void
		{
			_slider.x = event.volume * _range;
			_indicator.width = _slider.x + _slider.width/2;			
		}
		
		/**
		 * @private (protected)
		 */
		protected function indicatorMouseDownHandler(event:MouseEvent):void
		{
			_slider.x = Math.max(0, Math.min(_range, mouseX - (_slider.width/2)));			
			volume = Math.round((_slider.x/_range)*100)/100;
			_indicator.width = _slider.x + _slider.width/2;
			_mouseDownX = _slider.mouseX;
			_mouseDownRightPadding = _slider.width - _mouseDownX;
			this.stage.addEventListener(MouseEvent.MOUSE_UP, sliderMouseUpHandler, false, 0, true);
			this.stage.addEventListener(MouseEvent.MOUSE_MOVE, sliderMouseMoveHandler, false, 0, true);						
		}	

		/**
		 * Add the ability to change volume using keyboard navigation.
		 * 
		 */
		override protected function keyDownHandler(event:KeyboardEvent):void 
		{
			switch(event.keyCode)
			{
				case Keyboard.LEFT:
				case Keyboard.DOWN:
					volume = Math.max(0, _model.volume - .1);
				
					break;
				
				case Keyboard.RIGHT:
				case Keyboard.UP:
					volume = Math.min(1, _model.volume + .1);
				
					break;
			}
		}
		/**
		 * @private (protected)
		 * 
		 * Sizes and positions elements.
		 */
		protected function resizeEventHandler(event:ComponentEvent):void
		{
			_background.width = width;
			_background.height = height;
			_indicator.width = width;
			_indicator.height = height;	
			_clickStrip.width = width;
			_clickStrip.height = height;
			_clickStrip.alpha = 0;	
			_slider.width = width/20;
			_slider.height = height;			
			if(_backgroundMask != null)
			{
				_backgroundMask.width = width;
				_backgroundMask.height = height;
			}
			if(_indicatorMask != null)
			{
				_indicatorMask.width = width;
				_indicatorMask.height = height;
			}
			if(_knobMask != null)
			{
				_knobMask.width = width;
				_knobMask.height = height;
			}	
			_range = width - _slider.width;		
			//_slider.x = _model.volume * _range;
			_slider.x = 10 * _range;
			_indicator.width = _slider.x + _slider.width/2;		
		}		
		
		/**
	     *  @inheritDoc
	     */
	    override protected function initializeAccessibility():void
	    {
			if (VolumeSlider.createAccessibilityImplementation != null)
	            VolumeSlider.createAccessibilityImplementation(this);
	    }	
	}
}