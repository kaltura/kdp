/*
ADTagService.as

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

Loads in the ad tag XML file to UIF.

*/
package com.eyewonder.instream.modules.videoAdModule.VAST.utility
{
	
	import flash.display.Sprite;
	import flash.errors.IOError;
	import flash.errors.MemoryError;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	import com.eyewonder.instream.debugger.UIFDebugMessage;
	
	//XML data service class -- access to xml is obtained through adTagData property 
	public dynamic class AdTagService extends Sprite
	{
		public static const ERROR_LOADING_XML:String = "errorLoadingXML"
		public var _adTagData:XML;
		public var _dataLoader:URLLoader;
		
		public var _completeEventDelayTimerID:Number = -1;
		
		public function AdTagService() 
		{
			_adTagData = new XML();
		}
		
		public function loadAdXMLURL( url:String ):void
        {
        	
            _dataLoader = new URLLoader(); 
            _dataLoader.addEventListener( Event.COMPLETE, onDataLoadComplete );
            _dataLoader.addEventListener( IOErrorEvent.IO_ERROR, onIOError );
			_dataLoader.addEventListener( SecurityErrorEvent.SECURITY_ERROR, onSecurityError );
            
            try
            {
            	_dataLoader.load( new URLRequest( url ) );
            }
            catch(e:ArgumentError)
            {
            	UIFDebugMessage.getInstance()._debugMessage(2, "URLLoader Error" + e.message);
            	dispatchEvent(new Event(AdTagService.ERROR_LOADING_XML, true));
            }
            catch(e:SecurityError)
            {
            	UIFDebugMessage.getInstance()._debugMessage(2, "URLLoader Error" + e.message);
            	dispatchEvent(new Event(AdTagService.ERROR_LOADING_XML, true));
            }
            catch(e:MemoryError)
            {
            	UIFDebugMessage.getInstance()._debugMessage(2, "URLLoader Error" + e.message);
            	dispatchEvent(new Event(AdTagService.ERROR_LOADING_XML, true));
            }
           
        }
        
        public function onDataLoadComplete( event:Event ):void
        {
    		try {
        	
				_adTagData = new XML(_dataLoader.data);
	          	dispatchEvent(new Event(Event.COMPLETE, true));	
				} catch (e:Error){
				UIFDebugMessage.getInstance()._debugMessage(2, "URLLoader Error" + e.message);	
				dispatchEvent(new Event(AdTagService.ERROR_LOADING_XML, true));
			}
			
        }
        
        public function onIOError( event:IOErrorEvent ):void
        {  
			UIFDebugMessage.getInstance()._debugMessage(2, "URLLoader Error (IOError) " + event.text );	
          	dispatchEvent(new Event(AdTagService.ERROR_LOADING_XML, true));
        }
		
		public function onSecurityError( event:SecurityErrorEvent ):void
        {  
			UIFDebugMessage.getInstance()._debugMessage(2, "URLLoader Error (SecurityError) " + event.text );	
          	dispatchEvent(new Event(AdTagService.ERROR_LOADING_XML, true));
        }
		
		public function get adTagData():XML
        {

            return _adTagData;
        }
        
		public function dispatchComplete():void {
			clearInterval( _completeEventDelayTimerID );
			
			dispatchEvent( new Event(Event.COMPLETE, true ) );
		}
		
        public function setXMLData(value:XML):void
        {
        	try {
        		
			_adTagData = new XML(value);
			
			/**
			 * workaround: reminder inline happens to fast, so we add a small delay to "simulate" xml loading and parsing
			 */
			clearInterval( _completeEventDelayTimerID );
			
			_completeEventDelayTimerID = setInterval(dispatchComplete, 500);
			
          	//dispatchEvent(new Event(Event.COMPLETE, true));	
			} catch (e:Error) {
			dispatchEvent(new Event(AdTagService.ERROR_LOADING_XML, true));
			}
        	
        	
        }
	}
}

