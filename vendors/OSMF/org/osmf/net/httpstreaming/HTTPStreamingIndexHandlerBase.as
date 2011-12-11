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
	import flash.errors.IllegalOperationError;
	import flash.events.EventDispatcher;

	/**
	 * Dispatched when the bootstrap information has been downloaded and parsed.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */
	[Event(name="notifyIndexReady", type="org.osmf.events.HTTPStreamingFileIndexHandlerEvent")]
	
	/**
	 * Dispatched when rates information becomes available. The rates usually becomes available
	 * when the bootstrap information has been parsed.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */
	[Event(name="notifyRates", type="org.osmf.events.HTTPStreamingFileIndexHandlerEvent")]

	/**
	 * Dispatched when total duration value becomes available. The total duration usually becomes available
	 * when the bootstrap information has been parsed.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */
	[Event(name="notifyTotalDuration", type="org.osmf.events.HTTPStreamingFileIndexHandlerEvent")]

	/**
	 * Dispatched when the index handler needs the index to be downloaded.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */
	[Event(name="requestLoadIndex", type="org.osmf.events.HTTPStreamingFileIndexHandlerEvent")]
	
	/**
	 * Dispatched when the index handler encounters an unrecoverable error, such as an invalid 
	 * bootstrap box or an empty server base url.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */
	[Event(name="notifyError", type="org.osmf.events.HTTPStreamingFileIndexHandlerEvent")]

	/**
	 * Dispatched whenever the index handler learns of (new) DVR metadata 
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */
	[Event(name="DVRStreamInfo", type="org.osmf.events.DVRStreamInfoEvent")]
	
	[ExcludeClass]
	
	/**
	 * @private
	 * 
	 * Base class for HTTP streaming index handlers.
	 * 
	 * An index handler is responsible for mapping a media playback time to the
	 * URL from which the corresponding media fragment can be retrieved.
	 */
	public class HTTPStreamingIndexHandlerBase extends EventDispatcher
	{
		/**
		 * Constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function HTTPStreamingIndexHandlerBase()
		{
		}
		
		/**
		 * Initializes this index with information about the media to be played.
		 * 
		 * Subclasses must override to provide a specific implementation.
		 * 
		 * @param indexInfo The info object used to initialize the index.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function initialize(indexInfo:Object):void
		{	
			throw new IllegalOperationError("The initialize() method must be overridden by the derived class.");
		}
		
		/**
		 * Called when the index file has been loaded and is ready to be processed.
		 * 
		 * Subclasses must override to provide a specific implementation.  When the
		 * index file is processed, that implementation should dispatch the
		 * notifyIndexReady event.
		 * 
		 * @param data The data from the loaded index file.
		 * @param indexContext An arbitrary context object which describes the loaded
		 * index file.  Useful for index handlers which load multiple index files
		 * (and thus need to know which one to process).
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function processIndexData(data:*, indexContext:Object):void
		{
			throw new IllegalOperationError("The processIndexData() method must be overridden by the derived class.");
		}
		
		/**
		 * Returns the HTTPStreamRequest which encapsulates the file for the given
		 * playback time and quality.  If no such file exists for the specified time
		 * or quality, then this method should return null. 
		 * 
		 * Subclasses must override to provide a specific implementation.
		 * 
		 * @param time The time for which to retrieve a request object.
		 * @param quality The quality of the requested stream.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function getFileForTime(time:Number, quality:int):HTTPStreamRequest
		{
			throw new IllegalOperationError("The getFileForTime() method must be overridden by the derived class.");
		}
		
		/**
		 * Returns the HTTPStreamRequest which encapsulates the file that follows the
		 * previously retrieved file.  If no next file exists, or if the specified
		 * quality is out of range, then this method should return null. 
		 * 
		 * Subclasses must override to provide a specific implementation.
		 * 
		 * @param quality The quality of the requested stream.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */	
		public function getNextFile(quality:int):HTTPStreamRequest
		{
			throw new IllegalOperationError("The getNextFile() method must be overridden by the derived class.");
		}			

		/**
		 * Called when HTTPNetStream and/or its derived class needs to obtain DVR information. When information 
		 * is ready available, it dispatches DVRStreamInfoEvent to pass the value back to HTTPNetStream.
		 * 
		 * Subclasses must override to provide a specific implementation.
		 * 
		 * @param the index information from which DVR information can be retrieve.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */	
		public function dvrGetStreamInfo(indexInfo:Object):void
		{
			throw new IllegalOperationError("The dvrGetStreamInfo() method must be overridden by the derived class.");
		}
	}
}