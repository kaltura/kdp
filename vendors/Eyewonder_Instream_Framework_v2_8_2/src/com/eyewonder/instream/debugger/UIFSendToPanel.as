/*
UIFSendToPanel.as

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

A custom trace output class for the Universal Instream Framework. Ouptut can be seen on EyeWonder's Reporting QA website.
http://apps.eyewonderlabs.com/adWdrVideoSpace/ad/QA/Reporting/receiving.html
*/
package com.eyewonder.instream.debugger {
	
	import flash.net.LocalConnection;
	import flash.events.StatusEvent;
	import flash.events.Event;
	
	public dynamic class UIFSendToPanel
	{
		
		private static var _instance:UIFSendToPanel;
		public var _QAConnection : LocalConnection ;
		public var _debugMessages:Number;
		
		public function UIFSendToPanel()
		{
			_QAConnection = new LocalConnection();
			_QAConnection.allowDomain("*");
			_QAConnection.addEventListener(StatusEvent.STATUS, handleLCEvents);
			
		}
		
		public static function getInstance():UIFSendToPanel
		{
			if(_instance == null) 
            {
                _instance = new UIFSendToPanel();
            }
            return _instance;
		}
		
	    public function _sendToPanel( message:Object ) : void
		{
			_QAConnection.send("_ewQAConnection", "ewDisplayText", message.toString());     // Send to common receiving
		    //trace(message);
		}
		
		public function handleLCEvents(event:Event) : void
		{
			//Keep this function
		}
		
		
	}


}