/*
Copyright (c) 2009 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
﻿package com.yahoo.astra.fl.controls.mediaPlayerClasses
{
	import com.yahoo.astra.fl.events.MediaEvent;
	/**
	 * Implements IMediaController.  Controller for media clips
	 */
	
	public class MediaController implements IMediaController
	{

	//--------------------------------------
	//  Constructor
	//--------------------------------------	
		
		/**
		 * Constructor
		 */
		public function MediaController(clip:IMediaClip = null)
		{
			if(clip != null) _media = clip;		
		}
		
		
	//--------------------------------------
	//  Properties
	//--------------------------------------
	
		/**
		 * @private (protected)
		 * media to act as _model
		 */
		protected var _media:IMediaClip;
		
		/**
		 * Gets or sets the media clip
		 */
		public function get media():IMediaClip
		{
			return _media;
		}
		
		/**
		 * @private (setter)
		 */
		public function set media(value:IMediaClip):void
		{
			_media = value;
		}
		
	//--------------------------------------
	//  Public Methods
	//--------------------------------------			
		
		/**
		 * sets the _media's position property the the received percentage times the _media's length
		 *
		 * @param pct position to seek 
		 */
		public function seek(pct:Number):void
		{
			_media.position = pct*_media.length;
		}
		
		/**
		 * calls the pause method on the _media
		 */
		public function stop():void
		{
			_media.stop();
		}
		
		/**
		 * calls pause and resume on the model
		 *
		 * @param pause Boolean indicating whether to call <code>pause()</code> or
		 * <code>play()</code> on the media clip
	 	 */
		public function setPause(pause:Boolean):void
		{
			if(pause)
			{
				_media.pause();
			}
			else
			{
				_media.play();
			}
		}
		
		/**
		 * sets the mute property on the model
		 *
		 * @param value Boolean to set to the media clip's <code>mute</code> property		 
		 */
		public function setMute(value:Boolean):void
		{
			_media.mute = value;
		}
		
		/**
		 * sets the volume property of the model
		 *
		 * @param value Number to set the media clip's <code>volume</code> property
		 */
		public function setVolume(value:Number):void
		{
			_media.volume = value;
		}
		
		/**
		 * Gets the volume property of the model
		 *
		 * @return The media clip's <code>volume</code> property
		 */
		public function getVolume():Number
		{
			return _media.volume;
		}
	}
}