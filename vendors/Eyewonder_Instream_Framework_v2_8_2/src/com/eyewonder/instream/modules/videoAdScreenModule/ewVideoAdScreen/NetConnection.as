/*
NetConnection.as

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




*/
package com.eyewonder.instream.modules.videoAdScreenModule.ewVideoAdScreen
{
	import com.eyewonder.instream.modules.videoAdModule.VAST.events.*;
	import flash.events.EventDispatcher;
	import flash.net.NetConnection;
	import flash.net.ObjectEncoding;
	
/**
* Dispatched when the streaming server determins the bandwidth
*
* @eventType com.eyewonder.events.BandwidthEvent
*/
[Event(name="bwDetect", type="com.eyewonder.events.BandwidthEvent")]	

	/** @private This class is an implementation detail for VideoScreen */
	public dynamic class NetConnection extends flash.net.NetConnection
	{
		public var type:String;
		public var bandwidth:int;
		
		public function NetConnection( type:String )
		{
			bandwidth = -1;	
			this.type = type;
			this.objectEncoding = ObjectEncoding.AMF0; // FMS2 uses AMF0, not the default AMF3
			super();
		}
		
		/** @private */
		public function onBWCheck( ... rest ):Number
		{
			return 0;
		}

		/** @private */	
		public function onBWDone( bandwidth:Number, ... rest ):void
		{			
			this.bandwidth = bandwidth;
			dispatchEvent( new BandwidthEvent( BandwidthEvent.BW_DETECT, bandwidth) );
		}
	}
}