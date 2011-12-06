/*****************************************************
*  
*  Copyright 2009 Adobe Systems Incorporated.  All Rights Reserved.
*  
*****************************************************
*  The contents of this file are subject to the Mozilla Public License
*  Version 1.1 (the "License"); you may not use this file except in
*  compliance with the License. You may obtain a copy of the License at
*  http://www.mozilla.org/MPL/
*   
*  Software distributed under the License is distributed on an "AS IS"
*  basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
*  License for the specific language governing rights and limitations
*  under the License.
*   
*  
*  The Initial Developer of the Original Code is Adobe Systems Incorporated.
*  Portions created by Adobe Systems Incorporated are Copyright (C) 2009 Adobe Systems 
*  Incorporated. All Rights Reserved. 
*  
*****************************************************/
package org.osmf.net.httpstreaming
{
	[ExcludeClass]
	
	/**
	 * @private
	 * 
	 * Enumeration of states that an HTTPNetStream can cycle through.
	 * 
	 * In general, the HTTPNetStream cycles through the following categories
	 * of states:
	 * 1) LOAD
	 * 2) PLAY
	 * 3) END_SEGMENT
	 * 
	 * The LOAD and PLAY states have several sub-states to distinguish between
	 * operations triggered by seeks, and operations triggered by normal playback.
	 */ 
	internal class HTTPStreamingState
	{
		/**
		 * Indicates the HTTPNetStream is in its initial state.  No media
		 * has been passed-in yet.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		internal static const INIT:String = "init";
		
		/**
		 * Indicates the HTTPNetStream is about to load a new file in
		 * response to a seek (or upon startup).
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		internal static const LOAD_SEEK:String = "loadSeek";

		internal static const LOAD_SEEK_RETRY_WAIT:String = "loadSeekRetryWait";
		
		/**
		 * Indicates the HTTPNetStream is loading a new file.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		internal static const LOAD:String = "load";
		
		/**
		 * Indicates the HTTPNetStream is waiting for conditions to be
		 * appropriate to load a new file.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		internal static const LOAD_WAIT:String = "loadWait";
		
		/**
		 * Indicates the HTTPNetStream is about to load a new file as
		 * a result of completing playback of the previous file.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		internal static const LOAD_NEXT:String = "loadNext";
		
		internal static const LOAD_NEXT_RETRY_WAIT:String = "loadNextRetryWait";
		

		
		/**
		 * Indicates the HTTPNetStream is preparing to play a new file in
		 * response to a seek (or upon startup).
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		internal static const PLAY_START_SEEK:String = "playStartSeek";
		
		/**
		 * Indicates the HTTPNetStream is preparing to play a new file as
		 * a result of completing playback of the previous file.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		internal static const PLAY_START_NEXT:String = "playStartNext";
	
		/**
		 * Indicates the HTTPNetStream is about to play a new file.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		internal static const PLAY_START_COMMON:String = "playStartCommon";	
		
		
		/**
		 * Indicates the HTTPNetStream is playing the current file.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		internal static const PLAY:String = "play";
		
		/**
		 * Indicates the HTTPNetStream has finished playing the current file.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		internal static const END_SEGMENT:String = "endSegment";
		
		/**
		 * Indicates the HTTPNetStream is currently seeking.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		internal static const SEEK:String = "seek";

		/**
		 * Indicates the HTTPNetStream is stopping playback.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		internal static const STOP:String = "stop";
		
		/**
		 * Indicates the HTTPNetStream is not playing back.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		internal static const HALT:String = "halt";	
	}
}