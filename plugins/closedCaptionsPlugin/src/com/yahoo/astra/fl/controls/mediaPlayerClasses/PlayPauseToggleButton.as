/*
Copyright (c) 2009 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
﻿package com.yahoo.astra.fl.controls.mediaPlayerClasses
{
	import com.yahoo.astra.fl.events.MediaEvent;
	
	import fl.events.ComponentEvent;
	
	import flash.accessibility.Accessibility;
	import flash.accessibility.AccessibilityProperties;
	import flash.display.DisplayObjectContainer;

    //--------------------------------------
    //  Class Description
    //--------------------------------------
    
    /**
     * PlayPauseToggleButton extends MediaView and creates an IconButton to toggle
     * the playing state of a media clip.
	 *
	 * @see com.yahoo.astra.fl.controls.mediaPlayerClasses.MediaView
	 * @see com.yahoo.astra.fl.controls.mediaPlayerClasses.IconButton
	 *
	 * @langversion 3.0
	 * @playerversion Flash 9.0.28.0
	 */
	public class PlayPauseToggleButton extends MediaView
	{						

    //--------------------------------------
    //  Constructor
    //--------------------------------------
    
		/**
		 * Constructor
		 * @param container display object container that the PlayPauseToggleButton will be added to
		 * @param model media clip that the PlayPauseToggleButton will observe
		 * @param controller media controller that will handle user input from the PlayPauseToggleButton
		 */
		public function PlayPauseToggleButton(container:DisplayObjectContainer, model:IMediaClip, controller:MediaController)
		{
			super(container, model, controller);
			_button = new IconButton();
			_button.width = width;
			_button.height = height;
			
			_button.accessibilityProperties = getCurrentAccessibilityProperties();
			
			addChild(_button);
			setChildStyles(_button, getStyleDefinition());
			_button.addEventListener(ComponentEvent.BUTTON_DOWN, dispatchToggleChange);			
		}
		
    //--------------------------------------
    //  Properties
    //--------------------------------------		
		 
		
		/**
		 * @private (protected)
		 */
		protected var _button:IconButton;
		
		/**
		 * Gets or sets the vertical padding of the button
		 */
		 public function get verticalPadding():Number
		 {
			 return _button.verticalPadding;
		 }
		 
		/**
		 * @private (setter)
		 */
		public function set verticalPadding(value:Number):void
		{
			_button.verticalPadding = value;
		}
		
		/**
		 * Gets or set the amount of horizontal space between the icon and the sides of the button
		 */
		public function get horizontalPadding():Number
		{
			return _button.horizontalPadding;
		}
		
		/**
		 * @private (setter)
		 */		
		public function set horizontalPadding(value:Number):void
		{
			_button.horizontalPadding = value;
		}
		
		/**
		 * @private
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 */
		private static var defaultStyles:Object = {
			  icon:null,
			  upIcon:"play_upIcon",
			  downIcon:"play_downIcon",
			  overIcon:"play_overIcon",
			  disabledIcon:null,
			  selectedDisabledIcon:null,
			  selectedUpIcon:"pause_upIcon",
			  selectedDownIcon:"pause_downIcon",
			  selectedOverIcon:"pause_overIcon",
			  textFormat:null, 
			  disabledTextFormat:null,
			  textPadding:5, 
			  embedFonts:false
		}; 
		
		/**
		 * @private (protected)
		 */		
		override public function set height(value:Number):void
		{
			super.height = _button.height = value;
			invalidate();
		}

		/**
		 * @private (protected)
		 */		
		override public function set width(value:Number):void
		{
			super.width = _button.width = value;
			invalidate();
		}
    //--------------------------------------
    //  Public Methods
    //--------------------------------------   		

		/**
		 * Gets the styles for the component
		 * @return Object created from defaultStyle and the BaseButton styles. 
		 */
		public static function getStyleDefinition():Object 
		{ 
			//return mergeStyles(defaultStyles, BaseButton.getStyleDefinition());
			return defaultStyles;
		}		
		
    //--------------------------------------
    //  Protected Methods
    //--------------------------------------  
		
		/**
		 * @private (protected)
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 */		
		override protected function addListeners():void
		{
			//add listeners to the _model
			_model.addEventListener(MediaEvent.MEDIA_PLAY_PAUSE, toggleState);
		}
		
		/**
		 * @private (protected)
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 */				
		override protected function removeListeners():void
		{
			//remove listeners from the _model
			_model.removeEventListener(MediaEvent.MEDIA_PLAY_PAUSE, toggleState);			
		}		
		
		/**
		 * @private (protected)
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 */		
		protected function dispatchToggleChange(event:ComponentEvent):void
		{
			//pass the selected value to the _controller's togglePlayPause function
			_controller.setPause(_button.selected);	
			//TODO: Accessibility.active check and 2 sec timeout
			setAccessibilityProperties();
			
			invalidate();
		}

		/**
 		 * @private (protected)
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 */	
		protected function toggleState(event:MediaEvent):void
		{
			//sets the _selected property of _button based on the state of the media
			_button.selected = event.target.playing;
		}
		
		 /**
		 * @private 
		 * 
		 * Get the accessibility properties depending on the button state
		 */
		 protected function getCurrentAccessibilityProperties():AccessibilityProperties
		 {
		 	var accProps= new AccessibilityProperties();
			accProps.name = _button.selected? "Pause" :"Play";
			accProps.description = _button.selected? "Click to Pause" :"Click to Play";
			return accProps;
		 }
		 
		 /**
		 * @private 
		 * 
		 * Set the accessibility properties depending on the button state
		 */		
		protected function setAccessibilityProperties():void
		 {
		 	if(Accessibility.active)
		 	{
		 		_button.accessibilityProperties = getCurrentAccessibilityProperties();
				Accessibility.updateProperties();
			}
		 }
			
	
	}
}