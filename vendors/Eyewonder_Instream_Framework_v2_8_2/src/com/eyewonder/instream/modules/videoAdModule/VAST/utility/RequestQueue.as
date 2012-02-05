/*
RequestQueue.as

Universal Instream Framework
Copyright (c) 2006-2009, Eyewonder, Inc
All Rights Reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:
 * Redistributions of source code must retain the above copyright
  notice, this list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright
  notice, this list of conditions and the following disclaimer in the
  documentation and/or other materials provided with the distribution.
 * Neither the name of Eyewonder, Inc nor the
 names of contributors may be used to endorse or promote products
 derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY Eyewonder, Inc ''AS IS'' AND ANY
EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL Eyewonder, Inc BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

This file should be accompanied with supporting documentation and source code.
If you believe you are missing files or information, please 
contact Eyewonder, Inc (http://www.eyewonder.com)



Description
-----------

Use for calling tracking pixels.

*/
package com.eyewonder.instream.modules.videoAdModule.VAST.utility
{
	import com.eyewonder.instream.debugger.*;
	import com.eyewonder.instream.events.UIFEvent;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	
	/** @private */
	public dynamic class RequestQueue extends Sprite
	{
		public var requests:Array;
		public var postvars:Array;
		public var callbacks:Array;
		
		public var numRequests:int;
		
		/** @private */
		public function RequestQueue()
		{
			requests = new Array();
			postvars = new Array();
			callbacks = new Array();
			numRequests = 0;
		}
		
		public function addRequest( request:URLRequest, postvar:Object = null, callback:Function = null):void
		{
			requests.push( request );
			postvars.push( postvar );
			callbacks.push( callback );
			
			if( numRequests++ == 0 ) sendRequest();
		}
		
		public function sendRequest():void
		{
			var request:URLRequest = requests.shift() as URLRequest;
			var postvar:Array = postvars.shift() as Array;
			
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, finishRequest );
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			
			if( postvar != null )
			{
				request.method = "POST";
				
				var variableArray:URLVariables = new URLVariables();
				
				for( var property:String in postvar )
				{
					variableArray[property] = postvar[property];
				}
				
				request.data = variableArray;
				
			}
			
			loader.load( request );
		}
		
		public function finishRequest( event:Event ):void
		{
			var callback:Function = callbacks.shift() as Function;
			if( callback != null ) callback();
			
			
			
			numRequests--;
			if( requests.length > 0 ) sendRequest();
		}
		
		public function onIOError(e:IOErrorEvent):void
		{
			UIFDebugMessage.getInstance()._debugMessage(2, "Request failed. IOError: " + e.text, "VAST");
			dispatchEvent(new Event(UIFEvent.ERROR_EVENT));
		}
		
		
		public function onSecurityError(e:SecurityErrorEvent):void
		{
			UIFDebugMessage.getInstance()._debugMessage(2, "Request failed. SecutityError: " + e.text, "VAST");
			dispatchEvent(new Event(UIFEvent.ERROR_EVENT));
			
		}
		
	}
}