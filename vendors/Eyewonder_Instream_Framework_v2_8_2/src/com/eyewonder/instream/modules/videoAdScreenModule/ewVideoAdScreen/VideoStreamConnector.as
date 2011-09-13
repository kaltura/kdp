/*
VideoStreamConnector.as

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

Handles HTTP calls, NetConnection, and bandwidth logic.

*/
package com.eyewonder.instream.modules.videoAdScreenModule.ewVideoAdScreen
{
	import com.eyewonder.instream.debugger.*;
	import com.eyewonder.instream.modules.videoAdModule.VAST.events.*;
	import flash.errors.IOError;
	import flash.errors.MemoryError;
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	/** @private */
	public dynamic class VideoStreamConnector extends EventDispatcher
	{
		public var connectStream:NetConnection;
		public var connectTunnel:NetConnection;
		public var connectSuccess:Boolean;
		
		public var streamXMLLoader:URLLoader;
		public var streamXML:XML;
		
		public var server:String = null;
		public var applicationName:String = "ondemand";
		public var streamMode:int = 0;
		public var port:Number;
		
		public var directIdent:Boolean;
		public var tunnelIdent:Boolean;
		
		public function VideoStreamConnector(_server:String = "default", _applicationName:String = "default", _port:Number = 1935)
		{
			connectSuccess = false;
			// Setup parameters
			server = _server;
			applicationName = _applicationName;
			if(isNaN(_port))
				port = 1935;
			else
				port = _port;
					
			// Direct Ident
			if(streamMode == 0 || streamMode == 2) directIdent = false;
			else directIdent = true;
			
			// Tunnel Idnet		
			if(streamMode == 0 || streamMode == 3) tunnelIdent = false;
			else tunnelIdent = true;
			
			connectStream = new NetConnection("stream");
			connectStream.addEventListener(NetStatusEvent.NET_STATUS, connectStream_Status);
			connectStream.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			connectStream.addEventListener(AsyncErrorEvent.ASYNC_ERROR , onAsyncError);
			connectStream.addEventListener(SecurityErrorEvent.SECURITY_ERROR , onSecurityError);
			connectStream.addEventListener(BandwidthEvent.BW_DETECT, bandwidth_Callback);
			
			if(!directIdent)
			{
				try
				{
					connectStream.connect("rtmp://" + server + ":" + port + "/" + applicationName + "?_fcs_vhost=" + server,true);
				}
				catch(e:Error)
				{
					UIFDebugMessage.getInstance()._debugMessage(2, "Connection Error: " + e.message, "VAST", "VideoStreamConnector");
					dispatchEvent(new Event("sOnError", true));
				}
				catch(e:IOError)
				{
					UIFDebugMessage.getInstance()._debugMessage(2, "Connection Error: " + e.message, "VAST", "VideoStreamConnector");
					dispatchEvent(new Event("sOnError", true));
				}
				catch(e:SecurityError)
				{
					UIFDebugMessage.getInstance()._debugMessage(2, "Connection Error: " + e.message, "VAST", "VideoStreamConnector");
					dispatchEvent(new Event("sOnError", true));
				}
				catch(e:ArgumentError)
				{
					UIFDebugMessage.getInstance()._debugMessage(2, "Connection Error: " + e.message, "VAST", "VideoStreamConnector");
					dispatchEvent(new Event("sOnError", true));
				}
			} 
			
			connectTunnel = new NetConnection("tunnel");
			connectTunnel.addEventListener(NetStatusEvent.NET_STATUS, connectTunnel_Status);
			connectTunnel.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			connectTunnel.addEventListener(AsyncErrorEvent.ASYNC_ERROR , onAsyncError);
			connectTunnel.addEventListener(SecurityErrorEvent.SECURITY_ERROR , onSecurityError);
			connectTunnel.addEventListener(BandwidthEvent.BW_DETECT, bandwidth_Callback);
			
			if(!tunnelIdent)
			{
				try
				{
					
					connectTunnel.connect("rtmpt://" + server + ":80/" + applicationName +"?_fcs_vhost=" + server,true);
				}
				catch(e:Error)
				{
					UIFDebugMessage.getInstance()._debugMessage(2, "Connection Error: IO" + e.message, "VAST", "VideoStreamConnector");
					dispatchEvent(new Event("sOnError", true));
				}
				catch(e:IOError)
				{
					UIFDebugMessage.getInstance()._debugMessage(2, "Connection Error: " + e.message, "VAST", "VideoStreamConnector");
					dispatchEvent(new Event("sOnError", true));
				}
				catch(e:SecurityError)
				{
					UIFDebugMessage.getInstance()._debugMessage(2, "Connection Error: " + e.message, "VAST", "VideoStreamConnector");
					dispatchEvent(new Event("sOnError", true));
				}
				catch(e:ArgumentError)
				{
					UIFDebugMessage.getInstance()._debugMessage(2, "Connection Error: " + e.message, "VAST", "VideoStreamConnector");
					dispatchEvent(new Event("sOnError", true));
				}
			} 
			
			if(directIdent || tunnelIdent)
			{
				try
				{
					
					streamXMLLoader = new URLLoader( new URLRequest("http://" + server + "/fcs/ident"));
				}
				catch(e:Error)
				{
					UIFDebugMessage.getInstance()._debugMessage(2, "Connection Error: IO" + e.message, "VAST", "VideoStreamConnector");
					dispatchEvent(new Event("sOnError", true));
				}
				catch(e:MemoryError)
				{
					UIFDebugMessage.getInstance()._debugMessage(2, "Connection Error: " + e.message, "VAST", "VideoStreamConnector");
					dispatchEvent(new Event("sOnError", true));
				}
				catch(e:SecurityError)
				{
					UIFDebugMessage.getInstance()._debugMessage(2, "Connection Error: " + e.message, "VAST", "VideoStreamConnector");
					dispatchEvent(new Event("sOnError", true));
				}
				catch(e:ArgumentError)
				{
					UIFDebugMessage.getInstance()._debugMessage(2, "Connection Error: " + e.message, "VAST", "VideoStreamConnector");
					dispatchEvent(new Event("sOnError", true));
				}
				catch(e:TypeError)
				{
					UIFDebugMessage.getInstance()._debugMessage(2, "Connection Error: " + e.message, "VAST", "VideoStreamConnector");
					dispatchEvent(new Event("sOnError", true));
				}
				
				streamXMLLoader.addEventListener("complete", streamXML_Complete);
				streamXMLLoader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
				streamXMLLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			}
		}
		
		public function connectStream_Status( event:NetStatusEvent):void
		{
			if ( event.info.code == "NetConnection.Connect.Success" && connectSuccess == false )
			{
				
				connectSuccess = true;
				if( connectTunnel != null )
				{
					connectTunnel.close();
					connectTunnel = null;
				}
				
				dispatchEvent(new VideoStreamConnectorEvent(VideoStreamConnectorEvent.STREAM_CONNECTED, connectStream));
			} else if ( event.info.code == "NetStream.Play.StreamNotFound" )  {
				dispatchEvent(new Event("sOnError", true));
			}
		}
		
		public function connectTunnel_Status( event:NetStatusEvent):void
		{

			if ( event.info.code == "NetConnection.Connect.Success" && connectSuccess == false )
			{

				connectSuccess = true;
				if( connectStream != null )
				{
					connectStream.close();
					connectStream = null;
				}
				dispatchEvent(new VideoStreamConnectorEvent(VideoStreamConnectorEvent.STREAM_CONNECTED, connectTunnel));
			} else if ( event.info.code == "NetStream.Play.StreamNotFound" )  {
				dispatchEvent(new Event("sOnError", true));
			}	
		}
		
		public function bandwidth_Callback( event:BandwidthEvent ):void
		{
			
			dispatchEvent(new BandwidthEvent(BandwidthEvent.BW_DETECT,event.bandwidth));
		}
		
		public function streamXML_Complete( event:Event ):void
		{
			
			
			if(!connectSuccess)
			{
				streamXML = XML( streamXMLLoader.data );
				var serverIP:String = streamXML.ip[0];
				
				// Connect directly and via tunnelling
				try
				{	
					if(directIdent) connectStream.connect("rtmp://" + serverIP + "/" + applicationName + "?_fcs_vhost=" + server,true);
					if(tunnelIdent) connectTunnel.connect("rtmpt://" + serverIP + ":80/" + applicationName  + "?_fcs_vhost=" + server,true);
				}
				catch(e:Error)
				{
					UIFDebugMessage.getInstance()._debugMessage(2, "Connection Error: IO" + e.message, "VAST", "VideoStreamConnector");
					dispatchEvent(new Event("sOnError", true));
				}
				catch(e:IOError)
				{
					UIFDebugMessage.getInstance()._debugMessage(2, "Connection Error: " + e.message, "VAST", "VideoStreamConnector");
					dispatchEvent(new Event("sOnError", true));
				}
				catch(e:SecurityError)
				{
					UIFDebugMessage.getInstance()._debugMessage(2, "Connection Error: " + e.message, "VAST", "VideoStreamConnector");
					dispatchEvent(new Event("sOnError", true));
				}
				catch(e:ArgumentError)
				{
					UIFDebugMessage.getInstance()._debugMessage(2, "Connection Error: " + e.message, "VAST", "VideoStreamConnector");
					dispatchEvent(new Event("sOnError", true));
				}
				
				
			}
		}
		
		public function onIOError(e:IOErrorEvent):void
		{
			UIFDebugMessage.getInstance()._debugMessage(2, "Connection Error: " + e.text, "VAST", "VideoStreamConnector");
			dispatchEvent(new Event("sOnError", true));
		}
		
		public function onAsyncError(e:AsyncErrorEvent):void
		{
			UIFDebugMessage.getInstance()._debugMessage(2, "Connection Error: " + e.text, "VAST", "VideoStreamConnector");
			dispatchEvent(new Event("sOnError", true));	
		}
		
		public function onSecurityError(e:SecurityErrorEvent):void
		{
			UIFDebugMessage.getInstance()._debugMessage(2, "Connection Error: " + e.text, "VAST", "VideoStreamConnector");
			dispatchEvent(new Event("sOnError", true));
			
		}
		
	}
}
