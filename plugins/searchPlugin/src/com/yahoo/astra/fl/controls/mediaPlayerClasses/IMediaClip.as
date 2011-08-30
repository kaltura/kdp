/*
Copyright (c) 2009 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
﻿package com.yahoo.astra.fl.controls.mediaPlayerClasses
{
	import flash.events.IEventDispatcher;
	/**
	 * The IMediaClip interface provides the methods and properties that a media clip requires.
	 * All user defined media clips should implement this interface.	
	 */
	
	public interface IMediaClip extends IEventDispatcher
	{		
		
	//--------------------------------------
	//  Properties
	//--------------------------------------			
		/**
		 * Gets the source url for the media clip (read-only)
		 */
		function get url():String;
				
		/**
		 * Gets or sets the position of the media clip
		 */
		function get position():Number;
		
		/**
		 * @private (setter) 
		 */		
		function set position(value:Number):void;
		
		/**
		 * Gets or sets the volume of the media clip
		 */
		function get volume():Number;
		
		/**
		 * @private (setter) 
		 */		
		function set volume(value:Number):void;
		
		/**
		 * Gets or sets the mute value of the media clip (read-only)
		 */
		function get mute():Boolean;
		
		/**
		 * @private (setter) 
		 */		
		function set mute(value:Boolean):void;
		
		/**
		 * Gets or sets the auto start property of the media clip
		 */
		function get autoStart():Boolean;
		/**
		 * @private (setter) 
		 */
		function set autoStart(value:Boolean):void;
				
		/**
		 * Gets the playing value of the media clip (read-only)
		 */
		function get playing():Boolean;		
		
		/**
		 * Gets the length of the media clip (read-only)
		 */
		function get length():Number;		
		
		/**
		 * Gets the artist for the media clip (read-only)
		 */
		function get artist():String;
		
		/**
		 * Gets the title of the media clip (read-only)
		 */
		function get title():String;	
		
		/**
		 * Gets or sets the bufferTime of the clip
		 */
		function get bufferTime():Number;
		
		/**
		 * @private (setter)
		 */
		function set bufferTime(value:Number):void;
		
		/**
		 * Gets or sets the checkForPolicyFile boolean
		 */
		 function get checkForPolicyFile():Boolean;
		 
		/**
		 * @private (setter)
		 */
		function set checkForPolicyFile(value:Boolean):void;
		

	//--------------------------------------
	//  Public Methods
	//--------------------------------------			
				
	  	/**
	  	 * Loads a media clip from a url string
	  	 */
	  	function loadMedia(urlValue:String, autoStart:Boolean = true):void;
	  	
		/**
		 * Pauses the media clip
		 */
		function pause():void;	  	
	  	
		/**
		* Plays the media clip
		*/
		function play():void;	
		
		/**
		* Stops the media clip
		*/
		function stop():void;		
	}

}