/*
Copyright (c) 2009 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
﻿package com.yahoo.astra.fl.controls.mediaPlayerClasses
{

	/**
	* The IMediaView interface provides the methods and properties that a media view requires.
	* All user defined media views should implement this interface.	
	*/	
	
	public interface IMediaView
	{
		/**
		 * Gets or sets the media clip
		 */
		function get model():IMediaClip;
		
		/**
		 * @private (setter)
		 */
		function set model(value:IMediaClip):void;	
		
		/**
		 * Gets or sets the media controller
		 */
		function get controller():IMediaController;
		
		/**
		 * @private (setter)
		 */
		function set controller(value:IMediaController):void;
	}
}
