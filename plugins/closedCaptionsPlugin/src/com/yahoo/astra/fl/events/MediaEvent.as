/*
Copyright (c) 2009 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
﻿package com.yahoo.astra.fl.events
{
	import flash.events.Event;

	/**
	 * The MediaEvent class defines events for the IMediaClip components. 
	 * 
	 * These events include the following:
	 * <ul>
	 * <li><code>MediaEvent.MEDIA_POSITION</code>: dispatched when the MediaComponent's _playing property is true.</li>
	 * <li><code>MediaEvent.MEDIA_PLAY_PAUSE</code>: dispatched when the _playing state of the MediaComponent changes</li>
	 * <li><code>MediaEvent.VOLUME_CHANGE</code>: dispatched when the volume changes on the MediaComponent.</li>
	 * <li><code>MediaEvent.INFO_CHANGE</code>: dispatched when the info for the media has changed</li>
	 * <li><code>MediaEvent.MEDIA_LOADED</code>: dispatched when media source has loaded</li>
	 * <li><code>MediaEvent.MEDIA_ENDED</code>: dispatched when a media completes playback</li>
	 * </ul>
	 */	
	
	
	public class MediaEvent extends Event
	{
		
	//--------------------------------------
	//  Constants
	//--------------------------------------		
		/**
		 * Defines the value of the <code>type</code> property of an <code>mediaPosition</code> 
		 * event object. 
		 * 
		 * <p>This event has the following properties:</p>
		 *  <table class="innertable" width="100%">
		 *     <tr><th>Property</th><th>Value</th></tr>
		 *     <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
		 *     <tr><td><code>cancelable</code></td><td><code>true</code></td></tr>
		 *     <tr><td><code>currentTarget</code></td><td>The object that is actively processing 
		 *          the event object with an event listener.</td></tr>
		 * 	  <tr><td><code>position</code></td><td>The position of the playhead for the media
		 * 			clip</td></tr>
		 * 	  <tr><td><code>duration</code></td><td>The length of the media clip</td></tr>
		 *    <tr><td><code>volume</code></td><td>The volume of the media clip</tr></tr>
		 *    <tr><td><code>mute</code></td><td>The volume of the media clip</tr></tr>
		 * 	  <tr><td><code>target</code></td><td>The object that dispatched the event. The target is 
		 *           not always the object listening for the event. Use the <code>currentTarget</code>
		 * 			property to access the object that is listening for the event.</td></tr>
		 * 	  		</td></tr>
		 *  </table>
		 *
		 * @eventType mediaPosition
		 */
		public static const MEDIA_POSITION:String = "mediaPosition";
		
		/**
		 * Defines the value of the <code>type</code> property of an <code>mediaPlayPause</code> 
		 * event object. 
		 * 
		 * <p>This event has the following properties:</p>
		 *  <table class="innertable" width="100%">
		 *     <tr><th>Property</th><th>Value</th></tr>
		 *     <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
		 *     <tr><td><code>cancelable</code></td><td><code>true</code></td></tr>
		 *     <tr><td><code>currentTarget</code></td><td>The object that is actively processing 
		 *          the event object with an event listener.</td></tr>
		 * 	  <tr><td><code>position</code></td><td>The position of the playhead for the media
		 * 			clip</td></tr>
		 * 	  <tr><td><code>duration</code></td><td>The length of the media clip</td></tr>
		 *    <tr><td><code>volume</code></td><td>The volume of the media clip</tr></tr>
		 *    <tr><td><code>mute</code></td><td>The volume of the media clip</tr></tr>
		 * 	  <tr><td><code>target</code></td><td>The object that dispatched the event. The target is 
		 *           not always the object listening for the event. Use the <code>currentTarget</code>
		 * 			property to access the object that is listening for the event.</td></tr>
		 * 	  		</td></tr>
		 *  </table>
		 *
		 * @eventType mediaPlayPause
		 */		
		public static const MEDIA_PLAY_PAUSE:String = "mediaPlayPause";
		
		/**
		 * Defines the value of the <code>type</code> property of an <code>volumeChange</code> 
		 * event object. 
		 * 
		 * <p>This event has the following properties:</p>
		 *  <table class="innertable" width="100%">
		 *     <tr><th>Property</th><th>Value</th></tr>
		 *     <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
		 *     <tr><td><code>cancelable</code></td><td><code>true</code></td></tr>
		 *     <tr><td><code>currentTarget</code></td><td>The object that is actively processing 
		 *          the event object with an event listener.</td></tr>
		 * 	  <tr><td><code>position</code></td><td>The position of the playhead for the media
		 * 			clip</td></tr>
		 * 	  <tr><td><code>duration</code></td><td>The length of the media clip</td></tr>
		 *    <tr><td><code>volume</code></td><td>The volume of the media clip</tr></tr>
		 *    <tr><td><code>mute</code></td><td>The volume of the media clip</tr></tr>
		 * 	  <tr><td><code>target</code></td><td>The object that dispatched the event. The target is 
		 *           not always the object listening for the event. Use the <code>currentTarget</code>
		 * 			property to access the object that is listening for the event.</td></tr>
		 * 	  		</td></tr>
		 *  </table>
		 *
		 * @eventType volumeChange
		 */
		public static const VOLUME_CHANGE:String = "volumeChange";
		
		/**
		 * Defines the value of the <code>type</code> property of an <code>infoChange</code> 
		 * event object. 
		 * 
		 * <p>This event has the following properties:</p>
		 *  <table class="innertable" width="100%">
		 *     <tr><th>Property</th><th>Value</th></tr>
		 *     <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
		 *     <tr><td><code>cancelable</code></td><td><code>true</code></td></tr>
		 *     <tr><td><code>currentTarget</code></td><td>The object that is actively processing 
		 *          the event object with an event listener.</td></tr>
		 * 	  <tr><td><code>position</code></td><td>The position of the playhead for the media
		 * 			clip</td></tr>
		 * 	  <tr><td><code>duration</code></td><td>The length of the media clip</td></tr>
		 *    <tr><td><code>volume</code></td><td>The volume of the media clip</tr></tr>
		 *    <tr><td><code>mute</code></td><td>The volume of the media clip</tr></tr>
		 * 	  <tr><td><code>target</code></td><td>The object that dispatched the event. The target is 
		 *           not always the object listening for the event. Use the <code>currentTarget</code>
		 * 			property to access the object that is listening for the event.</td></tr>
		 * 	  		</td></tr>
		 *  </table>
		 *
		 * @eventType infoChange
		 */
		public static const INFO_CHANGE:String = "infoChange";
		
		/**
		 * Defines the value of the <code>type</code> property of an <code>mediaLoaded</code> 
		 * event object. 
		 * 
		 * <p>This event has the following properties:</p>
		 *  <table class="innertable" width="100%">
		 *     <tr><th>Property</th><th>Value</th></tr>
		 *     <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
		 *     <tr><td><code>cancelable</code></td><td><code>true</code></td></tr>
		 *     <tr><td><code>currentTarget</code></td><td>The object that is actively processing 
		 *          the event object with an event listener.</td></tr>
		 * 	  <tr><td><code>position</code></td><td>The position of the playhead for the media
		 * 			clip</td></tr>
		 * 	  <tr><td><code>duration</code></td><td>The length of the media clip</td></tr>
		 *    <tr><td><code>volume</code></td><td>The volume of the media clip</tr></tr>
		 *    <tr><td><code>mute</code></td><td>The volume of the media clip</tr></tr>
		 * 	  <tr><td><code>target</code></td><td>The object that dispatched the event. The target is 
		 *           not always the object listening for the event. Use the <code>currentTarget</code>
		 * 			property to access the object that is listening for the event.</td></tr>
		 * 	  		</td></tr>
		 *  </table>
		 *
		 * @eventType mediaLoaded
		 */
		public static const MEDIA_LOADED:String = "mediaLoaded";
		
		/**
		 * Defines the value of the <code>type</code> property of an <code>mediaEnded</code> 
		 * event object. 
		 * 
		 * <p>This event has the following properties:</p>
		 *  <table class="innertable" width="100%">
		 *     <tr><th>Property</th><th>Value</th></tr>
		 *     <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
		 *     <tr><td><code>cancelable</code></td><td><code>true</code></td></tr>
		 *     <tr><td><code>currentTarget</code></td><td>The object that is actively processing 
		 *          the event object with an event listener.</td></tr>
		 * 	  <tr><td><code>position</code></td><td>The position of the playhead for the media
		 * 			clip</td></tr>
		 * 	  <tr><td><code>duration</code></td><td>The length of the media clip</td></tr>
		 *    <tr><td><code>volume</code></td><td>The volume of the media clip</tr></tr>
		 *    <tr><td><code>mute</code></td><td>The volume of the media clip</tr></tr>
		 * 	  <tr><td><code>target</code></td><td>The object that dispatched the event. The target is 
		 *           not always the object listening for the event. Use the <code>currentTarget</code>
		 * 			property to access the object that is listening for the event.</td></tr>
		 * 	  		</td></tr>
		 *  </table>
		 *
		 * @eventType mediaEnded
		 */		
		public static const MEDIA_ENDED:String = "mediaEnded";
		

		
	//--------------------------------------
	//  Constructor
	//--------------------------------------
	
		/**
		 * Constructor. Creates a new MediaEvent object with the specified parameters. 
		 * 
         * @param type The event type; this value identifies the action that caused the event.
         *
         * @param bubbles Indicates whether the event can bubble up the display list hierarchy.
         *
         * @param cancelable Indicates whether the behavior associated with the event can be
		 *        prevented.
		 *
		 * @param position Indicates the position of the playhead
		 *
		 * @param duration Indicates the duration of the clip
		 *
		 * @param volume Indicates the volume of the clip
		 *
		 * @param mute Indicates whether the clip is muted
		 */
		public function MediaEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, position:Number = 0, duration:Number = 0, volume:Number = 1, mute:Boolean = false)
		{
			super(type, bubbles, cancelable);
			this.duration = duration;
			this.position = position;
			this.volume = volume;
			this.mute = mute;
		}
		
	//--------------------------------------
	//  Properties
	//--------------------------------------		
		
		/**
		 * The position of the playhead
		 */
		public var position:Number = 0;

		/**
		 * The length of the media object
		 */
		public var duration:Number = 0;
		
		/**
		 * The volume level of the media object
		 */
		public var volume:Number = 0;
		
		/**
		 * Boolean indicating whether or not the media object has been muted
		 */
		public var mute:Boolean = false;		
		
		/**
		 * Creates a copy of the MediaEvent object and sets the value of each parameter to match
		 * the original.
		 *
		 * @return A new MediaEvent object with parameter values that match those of the original.
		 */
		override public function clone():Event
		{
			return new MediaEvent(this.type, this.bubbles, this.cancelable, this.position, this.duration, this.volume, this.mute);
		}
	}
}