/*
Copyright (c) 2009 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
﻿package com.yahoo.astra.fl.controls
{
	import com.yahoo.astra.fl.controls.mediaPlayerClasses.*;
	import com.yahoo.astra.fl.events.MediaEvent;
	
	import fl.core.UIComponent;
	import fl.managers.IFocusManagerComponent;
	
	import flash.display.DisplayObjectContainer;
	import flash.text.TextFormat;
	
	//--------------------------------------
	//  Styles
	//--------------------------------------	
	
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
	 * height of the media scrubber
     *
     * @default 16
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
     */	
	[Style(name="mediaScrubberHeight", type="Number")]		
	
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
	 * width of the volume control
     *
     * @default 60
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
     */	
	[Style(name="volumeControlWidth", type="Number")]
	
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
	 * horizontal padding for the icon in the mute toggle button
     *
     * @default 1
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
     */	
	[Style(name="muteToggleHorizontalPadding", type="Number")]	

	/**
	 * vertical padding for the icon in the play pause button
	 *
     * @default 3
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
     */	
	[Style(name="playPauseVerticalPadding", type="Number")]
	
	/**
	 * horizontal padding for the icon in the play pause button
	 *
     * @default 8
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
     */	
	[Style(name="playPauseHorizontalPadding", type="Number")]		
	
	
	//--------------------------------------
	//  Class description
	//--------------------------------------
	
	/**	
	 * The AudioPlayback class extends the UIComponent class and creates a set of controls for 
	 * audio playback.
	 *
     * @see com.yahoo.astra.fl.controls.mediaPlayerClasses.MediaView
     * @see com.yahoo.astra.fl.controls.mediaPlayerClasses.IMediaView
	 *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
     * @author Dwight Bridges	 
	 */
	public class AudioPlayback extends UIComponent //implements IFocusManagerComponent
	{	

	//--------------------------------------
	//  Constructor
	//--------------------------------------

		/**
		 * Constructor
		 * Creates a new AudioPlayback instance
		 * @param container the parent display object
		 */
		public function AudioPlayback(container:DisplayObjectContainer = null)
		{
			super();
			width = 400;
			initialize();
			if(container != null) 
			{
				container.addChild(this);
			}			
		}		
		
	//--------------------------------------
	//  Properties
	//--------------------------------------
	
		/**
		 * @private (protected)
		 */
		protected var _mute:Boolean;
		
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
		protected var _mediaControlsView:MediaControlsView;
		
		/**
		 * @private
		 */
		private var _mediaTypeMap:Object = 
		{
			audio:AudioClip
		};
		
		/**
		 * @private
		 */
		private static var defaultStyles:Object = 
		{
			background:"background"
		}
		
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
		 * @private (protected)
		 */
		protected var _mediaClass:Class;
		
		/**
		 * @private (protected)
		 * Volume of the player
		 */
		protected var _volume:Number = 1; 
		
		/**
		 * @private (protected)
		 */
		//Default to "audio" since only AudioClip exists now. 
		protected var _mediaType:String = "audio";	
		
		//Not exposing.  Only AudioClip exists now.
		//[Inspectable(defaultValue="audio",type=String)]
		/**
		 * @private
		 * Gets or sets type of media that the component will play
		 */		
		public function get mediaType():String
		{
			return _mediaType;	
		}
		
		/**
		 * @private (setter)
		 */
		public function set mediaType(value:String):void
		{
			//set the value of _mediaType and sets the _mediaClass from the _mediaTypeMap
			_mediaType = value;
			_mediaClass = _mediaTypeMap[value];	
		}
		
		/**
		 * Gets or sets the volume, ranging from 0 (silent) to 1 (full volume).
		 */
		public function get volume():Number
		{
			if(_mediaClip != null) _volume = _mediaClip.volume;
			return _volume;
		}

		/**
		 * @private (setter)
		 */		
		public function set volume(value:Number):void
		{
			_volume = value;
			if(_mediaClip != null) _mediaClip.volume = _volume;
		}
		
		/**
		 * Gets or sets mute
		 */	
		 public function get mute():Boolean
		 {
			 if(_mediaClip != null) _mute = _mediaClip.mute;
			 return _mute;
		 }
		 
		/**
		 * Gets or sets the media info.
		 */
		public function get info():String
		{
			if(_mediaClip != null) ;
			return _mediaControlsView._infoView.text;
		}

		
			 
		/**
		 * @private (setter)
		 */
		public function set mute(value:Boolean):void
		{
			_mute = value;
			if(_mediaClip != null) _mediaClip.mute = _mute;
		}
		
		[Inspectable(defaultValue=400,type=Number)]
		/**
		 * @private (override)
		 */
		override public function set width(value:Number):void
		{
			super.width = _width = value;
			if(_mediaControlsView != null) _mediaControlsView.width = width;
		}
		
		/**
		 * @private (protected)
		 */
		protected var _infoViewHeight:Number = 15;	 
		
		/**
		 * @private (protected)
		 */
		protected var _bufferTime:Number = 1000;
		
		/**
		 * Gets or sets buffer time (milliseconds) of the AudioClip.
		 */
		public function get bufferTime():Number
		{
			if(_mediaClip != null) _bufferTime = _mediaClip.bufferTime;
			return _bufferTime;
		}
		
		/**
		 * @private (setter)
		 */
		public function set bufferTime(value:Number):void
		{
			_bufferTime = value;
			if(_mediaClip != null) _mediaClip.bufferTime = value;
		}
		
		/**
		 * @private (protected)
		 */
		protected var _checkForPolicyFile:Boolean = true;
		
		/**
		 * Gets or sets checkForPolicyFile property of the AudioClip.  Specifies whether Flash Player should check 
		 * for the existence of a cross-domain policy file upon loading the object (true) or not.   
		 *
		 */
		public function get checkForPolicyFile():Boolean
		{
			if(_mediaClip != null) _checkForPolicyFile = _mediaClip.checkForPolicyFile;
			return _checkForPolicyFile;
		}
		
		/**
		 * @private (setter)
		 */
		public function set checkForPolicyFile(value:Boolean):void
		{
			_checkForPolicyFile = value;
			if(_mediaClip != null) _mediaClip.checkForPolicyFile = value;
		}
		
	//--------------------------------------------------------------------------
	//
	//  Class mixins
	//
	//--------------------------------------------------------------------------
	
	/**
	* Placeholder for mixin by AudioPlaybackAccImpl.
	*/
	public static var createAccessibilityImplementation:Function;	
				
	//--------------------------------------
	//  Public Methods
	//--------------------------------------	
			
		/**
		 * Loads media into the AudioClip
		 *
		 * @param urlValue string indicating the url of the audio file
		 * @param autoStart boolena indicating whether the clip starts playing when it loads.  The default values
		 * is true
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		public function loadMedia(urlValue:String, autoStart:Boolean = true):void
		{
			_mediaClip.loadMedia(urlValue, autoStart);
		}
		
        /**
         * @private (override)
         * 
         * Sets a style property on this component instance. This style may 
         * override a style that was set globally.
         *
         * <p>Calling this method can result in decreased performance. 
         * Use it only when necessary.</p>
         *
         * @param style The name of the style property.
         *
         * @param value The value of the style.
         *
         * @includeExample examples/UIComponent.setStyle.1.as -noswf
         * @includeExample examples/UIComponent.setStyle.2.as -noswf
         *
         * @see #getStyle()
         * @see #clearStyle()
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		override public function setStyle(style:String, value:Object):void {
			//Use strict equality so we can set a style to null ... so if the instanceStyles[style] == undefined, null is still set.
			//We also need to work around the specific use case of TextFormats
			if (instanceStyles[style] === value && !(value is TextFormat)) { return; }
			instanceStyles[style] = value;
			_mediaControlsView.setStyle(style, value);
		}		

	//--------------------------------------
	//  Protected Methods
	//--------------------------------------	
	
		/**
		 * @private (protected)
		 * dispatches MediaEvents
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 */
		protected function dispatchEvents(event:MediaEvent):void
		{
			dispatchEvent(event);
		}

		/**
		 * @private (protected)
		 * Sets the values and initializes components. 
		 */
		protected function initialize():void
		{
			//set the mediaType because only the AudioClip exists now and user should not have to specify audio.
			mediaType = _mediaType;
			_mediaClip = new _mediaClass();
			_mediaClip.volume = _volume;
			_mediaClip.mute = _mute;
			_mediaClip.addEventListener(MediaEvent.MEDIA_POSITION, dispatchEvents);
			_mediaClip.addEventListener(MediaEvent.MEDIA_PLAY_PAUSE, dispatchEvents);
			_mediaClip.addEventListener(MediaEvent.VOLUME_CHANGE, dispatchEvents);
			_mediaClip.addEventListener(MediaEvent.INFO_CHANGE, dispatchEvents);
			_mediaClip.addEventListener(MediaEvent.MEDIA_LOADED, dispatchEvents);
			_mediaClip.addEventListener(MediaEvent.MEDIA_ENDED, dispatchEvents);			
			_mediaController = new MediaController(_mediaClip);
			_mediaControlsView = new MediaControlsView(this, _mediaClip, _mediaController);
			_mediaControlsView.width = width;
			_mediaControlsView.height = height;
		}		
		
		/**
	     *  @inheritDoc
	     */
	    override protected function initializeAccessibility():void
	    {
			if (AudioPlayback.createAccessibilityImplementation != null)
	            AudioPlayback.createAccessibilityImplementation(this);
	    }
	}	
	
}

