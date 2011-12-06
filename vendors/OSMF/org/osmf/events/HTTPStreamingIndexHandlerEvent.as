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
	import flash.net.URLRequest;
	
	import org.osmf.net.httpstreaming.flv.FLVTagScriptDataObject;

	[ExcludeClass]
	
	/**
	 * @private
	 */
	public class HTTPStreamingIndexHandlerEvent extends Event
	{
		public static const NOTIFY_INDEX_READY:String = "notifyIndexReady";
		public static const NOTIFY_RATES:String = "notifyRates";
		public static const REQUEST_LOAD_INDEX:String = "requestLoadIndex";
		public static const NOTIFY_ERROR:String = "notifyError";
		public static const NOTIFY_SEGMENT_DURATION:String = "notifySegmentDuration";
		public static const NOTIFY_SCRIPT_DATA:String = "notifyScriptData";

		public function HTTPStreamingIndexHandlerEvent(
			type:String, 
			bubbles:Boolean=false, 
			cancelable:Boolean=false,
			live:Boolean = false,
			offset:Number = NaN,
			streamNames:Array = null, 
			rates:Array = null, 
			request:URLRequest = null,
			requestContext:Object = null,
			binaryData:Boolean = true,
			segmentDuration:Number = 0,
			scriptDataObject:FLVTagScriptDataObject = null,
			scriptDataFirst:Boolean = false,
			scriptDataImmediate:Boolean = false)	// TODO: scriptDataFirst and scriptDataImmediate could instead be a three-entry enumeration (normal, first-in-timeline, immediate)
		{
			super(type, bubbles, cancelable);
			
			_live = live;
			_offset = offset;
			_streamNames = streamNames;
			_rates = rates;
			_request = request;
			_requestContext = requestContext;
			_binaryData = binaryData;
			_segmentDuration = segmentDuration;
			_scriptDataObject = scriptDataObject;
			_scriptDataFirst = scriptDataFirst;
			_scriptDataImmediate = scriptDataImmediate
		}
		
		public function get live():Boolean
		{
			return _live;
		}

		public function get offset():Number
		{
			return _offset;
		}
		
		public function get streamNames():Array
		{
			return _streamNames;
		}
		
		public function get rates():Array
		{
			return _rates;
		}

		public function get request():URLRequest
		{
			return _request;
		}

		public function get requestContext():Object
		{
			return _requestContext;
		}
		
		public function get binaryData():Boolean
		{
			return _binaryData;
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

		override public function clone():Event
		{
			return new HTTPStreamingIndexHandlerEvent
				( type
				, bubbles
				, cancelable
				, live
				, offset
				, streamNames
				, rates
				, request
				, requestContext
				, binaryData
				, segmentDuration
				, scriptDataObject
				, scriptDataFirst
				, scriptDataImmediate
				);
		}
		
		// Internal
		//
		
		private var _streamNames:Array;
		private var _rates:Array;
		private var _request:URLRequest;
		private var _requestContext:Object;
		private var _binaryData:Boolean;
		private var _segmentDuration:Number;
		private var _scriptDataObject:FLVTagScriptDataObject;
		private var _scriptDataFirst:Boolean;
		private var _scriptDataImmediate:Boolean;	
		private var _live:Boolean;
		private var _offset:Number;
	}
}