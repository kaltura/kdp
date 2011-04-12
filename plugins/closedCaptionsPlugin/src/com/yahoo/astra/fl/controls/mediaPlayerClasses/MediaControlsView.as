/*
Copyright (c) 2009 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
﻿package com.yahoo.astra.fl.controls.mediaPlayerClasses
{
	import com.yahoo.astra.fl.controls.mediaPlayerClasses.*;
	import fl.core.UIComponent;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	
	//--------------------------------------
	//  Styles
	//--------------------------------------	
	
	/**
	 * Horizontal padding between the controls.
     *
     * @default 4
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
     */	
	[Style(name="horizontalPadding", type="Number")]	
	
	/**
	 * Vertical padding between the media scrubber and the other controls.
     *
     * @default 0
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
     */	
	[Style(name="verticalPadding", type="Number")]	
	
	/**
	 * padding on the bottom of the view
     *
     * @default 4
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
     */	
	[Style(name="bottomPadding", type="Number")]		
	
	/**
	 * height of the media scrubber
     *
     * @default 16
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
     */	
	[Style(name="mediaScrubberHeight", type="Number")]		
	
	/**
	 * width of the play pause toggle button
     *
     * @default 25
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
     */	
	[Style(name="playPauseWidth", type="Number")]
	
	/**
	 * height of the play pause toggle button
     *
     * @default 15
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
     */	
	[Style(name="playPauseHeight", type="Number")]	
	
	/**
	 * width of the mute toggle button
     *
     * @default 15
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
     */	
	[Style(name="muteToggleWidth", type="Number")]	
	
	/**
	 * height of the mute toggle button
     *
     * @default 15
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
     */	
	[Style(name="muteToggleHeight", type="Number")]	
	
	/**
	 * width of the volume control
     *
     * @default 60
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
     */	
	[Style(name="volumeControlWidth", type="Number")]	
	
	/**
	 * height of the volume control
     *
     * @default 15
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
     */	
	[Style(name="volumeControlHeight", type="Number")]	
	
	/**
	 * horizontal padding for the icon in the play pause button
	 *
     * @default 8
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
     */	
	[Style(name="playPauseHorizontalPadding", type="Number")]	

	/**
	 * vertical padding between the edges of the play pause button and its
	 * icon
     *
     * @default 3
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
     */	
	[Style(name="playPauseVerticalPadding", type="Number")]	

	/**
	 * horizontal padding for the icon in the mute toggle button
     *
     * @default 1
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
     */	
	[Style(name="muteToggleHorizontalPadding", type="Number")]		
	/**
	 * vertical padding for the icon in the mute toggle button
     *
     * @default 1
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
     */	
	[Style(name="muteToggleVerticalPadding", type="Number")]	

	/**
	 * height of the info view
	 *
     * @default 15
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
     */	
	[Style(name="infoViewHeight", type="Number")]		
    
    //--------------------------------------
    //  Class Description
    //--------------------------------------	
	
	/**
	 * MediaControlsView extends UIComponent.  Assembles different views for a MediaClip
	 *
     * @see fl.core.UIComponent
	 *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
     * @author Dwight Bridges	 
	 */
	public class MediaControlsView extends UIComponent
	{		
    
    //--------------------------------------
    //  Constructor
    //--------------------------------------		
		/**
		 * Constructor
		 * @param container
		 * @param model
		 * @param controller
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0 
		 */
		public function MediaControlsView(container:DisplayObjectContainer, model:IMediaClip = null, controller:MediaController = null):void
		{
			_mediaClip = model;
			_mediaController = controller;
			if(container != null) container.addChild(this);
			_background = getDisplayObjectInstance(getStyleValue("background")) as Sprite;
			if(_background != null)
			{
				addChild(_background);
				_background.width = width;
				_background.height = height;		
			}

			var horizontalPadding:Number = Number(getStyleValue("horizontalPadding"));
			var verticalPadding:Number = Number(getStyleValue("verticalPadding"));
			var infoViewHeight:Number = Number(getStyleValue("infoViewHeight"));
			var volumeControlHeight:Number = Number(getStyleValue("volumeControlHeight"));
			var muteToggleButtonHeight:Number = Number(getStyleValue("muteToggleHeight"));
			var playPauseButtonHeight:Number = Number(getStyleValue("playPauseHeight"));
	
			var controlsHeight:Number = Math.max(playPauseButtonHeight, muteToggleButtonHeight, volumeControlHeight, infoViewHeight);
			
			_mediaScrubberView = new MediaScrubberView(this, _mediaClip, _mediaController);
			_mediaScrubberView.setSize(width - (horizontalPadding *2), Number(getStyleValue("mediaScrubberHeight")));

			_playPauseButton = new PlayPauseToggleButton(this, _mediaClip, _mediaController);
			_playPauseButton.width = Number(getStyleValue("playPauseWidth"));
			_playPauseButton.height = Number(getStyleValue("playPauseHeight"));
			_playPauseButton.x = horizontalPadding;
			_playPauseButton.y = _playPauseButton.height < controlsHeight?_mediaScrubberView.bottom + verticalPadding + ((controlsHeight-_playPauseButton.height)/2):_mediaScrubberView.bottom + verticalPadding;
			_playPauseButton.verticalPadding = Number(getStyleValue("playPauseVerticalPadding"));
			_playPauseButton.horizontalPadding = Number(getStyleValue("playPauseHorizontalPadding"));	
			
			_infoView = new MediaInfoView(this, _mediaClip, _mediaController);
			
			_muteToggleButton = new MuteToggleButton(this, _mediaClip, _mediaController);
					
			_volumeControl = new VolumeSlider(this, _mediaClip, _mediaController);
			
			_muteToggleButton.width = Number(getStyleValue("muteToggleWidth"));
			_muteToggleButton.height = Number(getStyleValue("muteToggleHeight"));
			_muteToggleButton.y = _muteToggleButton.height < controlsHeight?_mediaScrubberView.bottom + verticalPadding + ((controlsHeight-_muteToggleButton.height)/2):_mediaScrubberView.bottom + verticalPadding;
			_muteToggleButton.verticalPadding = Number(getStyleValue("muteToggleVerticalPadding"));
			_muteToggleButton.horizontalPadding = Number(getStyleValue("muteToggleHorizontalPadding"));
			_muteToggleButton.x = _volumeControl.x - _muteToggleButton.width - horizontalPadding;			
			
			_volumeControl.setSize(Number(getStyleValue("volumeControlWidth")), Number(getStyleValue("volumeControlHeight")));
			_volumeControl.x = width - (horizontalPadding + _volumeControl.width);
			_volumeControl.y = _volumeControl.height < controlsHeight?_mediaScrubberView.bottom + verticalPadding + ((controlsHeight-_volumeControl.height)/2):_mediaScrubberView.bottom + verticalPadding;	
		
			_infoView.x = _playPauseButton.right + horizontalPadding;
			_infoView.y = _infoView.height < controlsHeight?_mediaScrubberView.bottom + verticalPadding + ((controlsHeight-_infoView.height)/2):_mediaScrubberView.bottom + verticalPadding;
			_infoView.width = _muteToggleButton.x - (_infoView.x + horizontalPadding);
			_infoView.height = Number(getStyleValue("infoViewHeight"));				
						
			_background.height = height = _volumeControl.height + _mediaScrubberView.bottom + Number(getStyleValue("bottomPadding"));
		}	    
    
    //--------------------------------------
    //  Properties
    //--------------------------------------	
    
        /**
         * @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		private static var defaultStyles:Object = {
			background:"background",
			playPauseWidth:25,
			playPauseHeight:15,
			muteToggleWidth:15,
			muteToggleHeight:15,
			mediaScrubberHeight:16,
			volumeControlHeight:15,
			volumeControlWidth:60,
			muteToggleVerticalPadding:1,
			muteToggleHorizontalPadding:1,
			playPauseVerticalPadding:3,
			verticalPadding:0,
			horizontalPadding:4,
			bottomPadding:4,
			infoViewHeight:15,
			playPauseHorizontalPadding:8	
		}
		
		/**
		 * @private (protected)
		 */		
		protected var _mediaClip:IMediaClip;
		
		/**
		 * @private (protected)
		 */		
		protected var _mediaController:MediaController;

		/**
		 * @private (protected)
		 */
		protected var _playPauseButton:PlayPauseToggleButton;

		/**
		 * @private (protected)
		 */
		protected var _muteToggleButton:MuteToggleButton;

		/**
		 * @private (protected)
		 */
		protected var _volumeControl:VolumeSlider;

		/**
		 * @private (protected)
		 */
		protected var _mediaScrubberView:MediaScrubberView;
		
		/**
		 * @private (protected)
		 */
		public var _infoView:MediaInfoView;
		
		/**
		 * @private
		 */
		private var _mediaTypeMap:Object = 
		{
			audio:AudioClip
		};

		/**
		* @private (protected)
		*/
		protected var _background:Sprite;		
		
		/**
		 * @private (protected)
		 */
		override public function set width(value:Number):void
		{
			super.width = (value > minimumWidth)?value:minimumWidth;
			invalidate();
		}
		
		/**
		 * @private (protected)
		 */
		protected var _minimumWidth:Number; 
		
		/**
		 * Gets the minimum width for the MediaControlsView (read-only). The minimum width of the 
		 * MediaControlsView is determined by the sum of muteToggleWidth, playPauseWidth, volumeControlWidth
		 * minimumInfoViewWidth and total horizontal padding.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0 
		 */
		public function get minimumWidth():Number
		{
			_minimumWidth =  Number(getStyleValue("muteToggleWidth")) + Number(getStyleValue("playPauseWidth")) + Number(getStyleValue("volumeControlWidth")) + 80 + (Number(getStyleValue("horizontalPadding"))*5);
			return _minimumWidth;
		}
		
    //--------------------------------------
    //  Public Methods
    //--------------------------------------					
	
		/**
		 * getStyleDefinition - returns defaultStyles
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0 
		 */
		public static function getStyleDefinition():Object
		{
			return mergeStyles(defaultStyles, UIComponent.getStyleDefinition());
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
		override protected function draw():void
		{
			super.draw();
			drawLayout();
		}

		/**
		 * @private (protected)
		 *
		 * Sizes and positions all elements of the MediaControlsView.  
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0 
		 */
		protected function drawLayout():void
		{
			var horizontalPadding:Number = Number(getStyleValue("horizontalPadding"));
			var verticalPadding:Number = Number(getStyleValue("verticalPadding"));
			var infoViewHeight:Number = Number(getStyleValue("infoViewHeight"));
			var volumeControlHeight:Number = Number(getStyleValue("volumeControlHeight"));
			var muteToggleButtonHeight:Number = Number(getStyleValue("muteToggleHeight"));
			var playPauseButtonHeight:Number = Number(getStyleValue("playPauseHeight"));
			
			var controlsHeight:Number = Math.max(playPauseButtonHeight, muteToggleButtonHeight, volumeControlHeight, infoViewHeight);
			
			_mediaScrubberView.x = horizontalPadding;
			_mediaScrubberView.y = 0;			
			_mediaScrubberView.setSize(width - (horizontalPadding *2), Number(getStyleValue("mediaScrubberHeight")))

			_playPauseButton.width = Number(getStyleValue("playPauseWidth"));
			_playPauseButton.height = playPauseButtonHeight;		
			_playPauseButton.x = horizontalPadding;
			_playPauseButton.y = _playPauseButton.height < controlsHeight?_mediaScrubberView.bottom + verticalPadding + ((controlsHeight-_playPauseButton.height)/2):_mediaScrubberView.bottom + verticalPadding;
			_playPauseButton.verticalPadding = Number(getStyleValue("playPauseVerticalPadding"));
			_playPauseButton.horizontalPadding = Number(getStyleValue("playPauseHorizontalPadding"));	
			
			_volumeControl.width = Number(getStyleValue("volumeControlWidth"));
			_volumeControl.height = volumeControlHeight;			
			_volumeControl.x = width - (horizontalPadding + _volumeControl.width);
			_volumeControl.y = _volumeControl.height < controlsHeight?_mediaScrubberView.bottom + verticalPadding + ((controlsHeight-_volumeControl.height)/2):_mediaScrubberView.bottom + verticalPadding;	
			
			_muteToggleButton.width = Number(getStyleValue("muteToggleWidth"));
			_muteToggleButton.height = muteToggleButtonHeight; 			
			_muteToggleButton.y = _muteToggleButton.height < controlsHeight?_mediaScrubberView.bottom + verticalPadding + ((controlsHeight-_muteToggleButton.height)/2):_mediaScrubberView.bottom + verticalPadding;
			_muteToggleButton.verticalPadding = Number(getStyleValue("muteToggleVerticalPadding"));
			_muteToggleButton.horizontalPadding = Number(getStyleValue("muteToggleHorizontalPadding"));
			_muteToggleButton.x = _volumeControl.x - _muteToggleButton.width - horizontalPadding;		

			_infoView.x = _playPauseButton.right + horizontalPadding;
			_infoView.width = _muteToggleButton.x - (_infoView.x + horizontalPadding);
			_infoView.height = infoViewHeight;				
			_infoView.y = _infoView.height < controlsHeight?_mediaScrubberView.bottom + verticalPadding + ((controlsHeight-_infoView.height)/2):_mediaScrubberView.bottom + verticalPadding;
			_background.height = height = verticalPadding + controlsHeight + _mediaScrubberView.bottom + Number(getStyleValue("bottomPadding"));
			_background.width = width;		
		}			
	}	
}