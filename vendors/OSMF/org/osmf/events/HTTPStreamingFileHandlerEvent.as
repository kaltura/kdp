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
package org.osmf.events
{
	import flash.events.Event;
	
	import org.osmf.net.httpstreaming.f4f.AdobeBootstrapBox;
	import org.osmf.net.httpstreaming.flv.FLVTagScriptDataObject;

	[ExcludeClass]
	
	/**
	 * @private
	 */
	public class HTTPStreamingFileHandlerEvent extends Event
	{
		public static const NOTIFY_SEGMENT_DURATION:String = "notifySegmentDuration";
		public static const NOTIFY_SCRIPT_DATA:String = "notifyScriptData";
		public static const NOTIFY_BOOTSTRAP_BOX:String = "notifyBootstrapBox";
		public static const NOTIFY_ERROR:String = "notifyError";
		
		public function HTTPStreamingFileHandlerEvent(
			type:String, 
			bubbles:Boolean=false, 
			cancelable:Boolean=false, 
			segmentDuration:Number=0,
			scriptDataObject:FLVTagScriptDataObject = null,
			scriptDataFirst:Boolean = false,
			scriptDataImmediate:Boolean = false,
			abst:AdobeBootstrapBox = null,
			error:Boolean = false)	// TODO: scriptDataFirst and scriptDataImmediate could instead be a three-entry enumeration (normal, first-in-timeline, immediate)
		{
			super(type, bubbles, cancelable);
			
			_segmentDuration = segmentDuration;
			_scriptDataObject = scriptDataObject;
			_scriptDataFirst = scriptDataFirst;
			_scriptDataImmediate = scriptDataImmediate
			_abst = abst;
			_error = error;
		}

		public function get segmentDuration():Number
		{
			return _segmentDuration;
		}

	
		public function get scriptDataObject():FLVTagScriptDataObject
		{
			return _scriptDataObject;
		}
		
		public function get scriptDataFirst():Boolean
		{
			return _scriptDataFirst;
		}
		
		public function get scriptDataImmediate():Boolean
		{
			return _scriptDataImmediate;
		}
		
		public function get bootstrapBox():AdobeBootstrapBox
		{
			return _abst;
		}
		
		public function get error():Boolean
		{
			return _error;				
		}
	
		override public function clone():Event
		{
			return new HTTPStreamingFileHandlerEvent(
				type, 
				bubbles, 
				cancelable, 
				segmentDuration, 
				scriptDataObject, 
				scriptDataFirst, 
				scriptDataImmediate, 
				bootstrapBox, 
				error);
		}
				
		// Internal
		//
		
		private var _segmentDuration:Number;
		private var _scriptDataObject:FLVTagScriptDataObject;
		private var _scriptDataFirst:Boolean;
		private var _scriptDataImmediate:Boolean;	
		private var _abst:AdobeBootstrapBox;
		private var _error:Boolean;
	}
}