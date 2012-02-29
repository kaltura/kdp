/*
Copyright (c) 2009 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
﻿package com.yahoo.astra.fl.controls.mediaPlayerClasses
{
	/**
	* The IMediaController interface provides the methods and properties that a media controller requires.
	* All user defined media controllers should implement this interface.	
	*/	
	
	public interface IMediaController
	{
		/**
		 * Gets or sets an IMediaClip
		 */
		function get media():IMediaClip;
		
		/**
		 * @private (protected)
		 */
		function set media(value:IMediaClip):void;	
		
		/**
		 * Seeks to specified position on the media clip
		 * 
		 * @param pct position to seek
		 */
		function seek(pct:Number):void
		
		/**
		 * Stops playback on a media clip
		 */
		function stop():void
		
		/**
		 * Handles pausing a media clip
		 *
		 * @param pause Boolean indicating whether or pause or play
		 */
		function setPause(pause:Boolean):void
		
		/**
		 * Handles the muting of media clip
		 *
		 * @param value Boolean indicating whether to mute or unmute
		 */
		function setMute(value:Boolean):void
		
		/**
		 * Sets the volume of a clip
		 *
		 * @param value the level to set the volume 
		 */
		function setVolume(value:Number):void

		/**
		 * Gets the volume of a clip
		 */
		function getVolume():Number
	}
}
