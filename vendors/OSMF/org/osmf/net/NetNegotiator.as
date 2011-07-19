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
*  Contributor(s): Akamai Technologies
*  
*****************************************************/
package org.osmf.net
{
	CONFIG::LOGGING
	{
		import org.osmf.logging.Logger;
	}
	
	import __AS3__.vec.Vector;
	
	import flash.errors.IOError;
	import flash.events.AsyncErrorEvent;
	import flash.events.EventDispatcher;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.NetConnection;
	import flash.utils.Timer;
	
	import org.osmf.events.MediaError;
	import org.osmf.events.MediaErrorCodes;
	import org.osmf.events.NetConnectionFactoryEvent;
	import org.osmf.media.URLResource;
	import org.osmf.utils.URL;
	
	/**
	 * Dispatched when the factory has successfully created and connected a NetConnection.
	 *
	 * @eventType org.osmf.events.NetConnectionFactoryEvent.CREATION_COMPLETE
	 * 
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */
	[Event(name="creationComplete", type="org.osmf.events.NetConnectionFactoryEvent")]
	
	/**
	 * Dispatched when the factory has failed to create and connect a NetConnection.
	 *
	 * @eventType org.osmf.events.NetConnectionFactoryEvent.CREATION_ERROR
	 * 
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */
	[Event(name="creationError", type="org.osmf.events.NetConnectionFactoryEvent")]

	/**
	 * The NetNegotiator class attempts to negotiate its way through firewalls and proxy
	 * servers, by trying multiple parallel connection attempts on differing port and protocol combinations.
	 * The first connection to succeed is kept and those still pending are shut down.
	 * 
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */
	internal class NetNegotiator extends EventDispatcher
	{
		/**
		 * Constructor.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function NetNegotiator():void
		{
			super();
		}
		
		/**
		 * @private
		 */
		public function createNetConnection(resource:URLResource, netConnectionURLs:Vector.<String>, netConnections:Vector.<NetConnection>):void
		{
			this.resource = resource;
			this.netConnectionURLs = netConnectionURLs;
			this.netConnections = netConnections;
			
			var streamingResource:StreamingURLResource = resource as StreamingURLResource;
			if (	streamingResource != null
				&&	streamingResource.connectionArguments != null
				&&	streamingResource.connectionArguments.length > 0)
			{
				this.netConnectionArguments = streamingResource.connectionArguments;
			}
		
			initializeConnectionAttempts();
			tryToConnect(null);
		}
		
		/** 
		 * Initializes properties and timers used during rtmp connection attempts.
		 * @private
		 */
		private function initializeConnectionAttempts():void
		{
			// Master timeout
			timeOutTimer = new Timer(DEFAULT_TIMEOUT, 1);
			timeOutTimer.addEventListener(TimerEvent.TIMER_COMPLETE, masterTimeout);
			timeOutTimer.start();
			
			// Individual attempt sequencer
			connectionTimer = new Timer(CONNECTION_ATTEMPT_INTERVAL);
			connectionTimer.addEventListener(TimerEvent.TIMER, tryToConnect);
			connectionTimer.start();
			
			// Initialize counters
			failedConnectionCount = 0;
			attemptIndex = 0;
		}
		
		/** 
		 * Attempts to connect to FMS using a particular connection string
		 * @private
		 */
		private function tryToConnect(evt:TimerEvent):void 
		{
			netConnections[attemptIndex].addEventListener(NetStatusEvent.NET_STATUS, onNetStatus, false, 0, true);
    		netConnections[attemptIndex].addEventListener(SecurityErrorEvent.SECURITY_ERROR, onNetSecurityError, false, 0, true);
    		netConnections[attemptIndex].addEventListener(AsyncErrorEvent.ASYNC_ERROR, onAsyncError, false, 0, true);
			netConnections[attemptIndex].client = new NetClient();
			try 
			{
				var host:String = netConnectionURLs[attemptIndex];
				var args:Array = [host];
				if (netConnectionArguments != null)
				{
					for each (var arg:Object in netConnectionArguments)
					{
						args.push(arg);
					}
				}
				
				CONFIG::LOGGING
				{
					logger.info("Attempting connection to " + netConnectionURLs[attemptIndex]);
				}
				
				NetConnection(netConnections[attemptIndex]).connect.apply(netConnections[attemptIndex], args);
				attemptIndex++;
				if (attemptIndex >= netConnectionURLs.length) 
				{
					connectionTimer.stop();
				}
			}
			catch (ioError:IOError) 
			{
				handleFailedConnectionSession
					( new MediaError(MediaErrorCodes.IO_ERROR, ioError.message)
					, netConnectionURLs[attemptIndex]
					);
			}
			catch (argumentError:ArgumentError) 
			{
				handleFailedConnectionSession
					( new MediaError(MediaErrorCodes.ARGUMENT_ERROR, argumentError.message)
					, netConnectionURLs[attemptIndex]
					);
			}
			catch (securityError:SecurityError) 
			{
				handleFailedConnectionSession
					( new MediaError(MediaErrorCodes.SECURITY_ERROR, securityError.message)
					, netConnectionURLs[attemptIndex]
					);
			}
		}
		
		/** 
		 * Monitors status events from the NetConnections
		 * @private
		 */
		private function onNetStatus(event:NetStatusEvent):void 
		{
			switch (event.info.code) 
			{
				case NetConnectionCodes.CONNECT_INVALIDAPP:
					handleFailedConnectionSession
						( new MediaError(MediaErrorCodes.NETCONNECTION_APPLICATION_INVALID, event.info.description)
						, NetConnection(event.target).uri
						);
					break;
				case NetConnectionCodes.CONNECT_REJECTED:
					handleFailedConnectionSession
						( new MediaError(MediaErrorCodes.NETCONNECTION_REJECTED, event.info.description)
						, NetConnection(event.target).uri
						);
    				break;
    			case NetConnectionCodes.CONNECT_FAILED:
    				failedConnectionCount++;
    				
 					CONFIG::LOGGING
					{
						if (failedConnectionCount < netConnectionURLs.length)
						{
							logger.info("NetConnection attempt failed: " + NetConnection(event.target).uri);
						}
					}

    				if (failedConnectionCount >= netConnectionURLs.length) 
    				{
    					handleFailedConnectionSession
    						( new MediaError(MediaErrorCodes.NETCONNECTION_FAILED)
    						, NetConnection(event.target).uri
    						);
    				}

    				break;
				case NetConnectionCodes.CONNECT_SUCCESS:
				
					CONFIG::LOGGING
					{
						if (	event.info.hasOwnProperty("data")
							&& 	event.info.data.hasOwnProperty("version")
						   )
						{
							logger.info("FMS Version: " + event.info.data.version);
						}
						else
						{
							logger.info("FMS Version unknown");
						}
					}
					
					shutDownUnsuccessfulConnections();
					dispatchEvent
						( new NetConnectionFactoryEvent
							( NetConnectionFactoryEvent.CREATION_COMPLETE
							, false
							, false
							, event.currentTarget as NetConnection
							, resource
							)
						);
					break;
			}
		}

  		/** 
		 * Closes down all parallel connections in the netConnections vector which are not connected.
		 * Also shuts down the master timeout and attempt timers. 
		 * @private
		 */
		private function shutDownUnsuccessfulConnections():void
		{
			timeOutTimer.stop();
			connectionTimer.stop();
			for (var i:int = 0; i < netConnections.length; i++) 
			{
				var nc:NetConnection = netConnections[i];
				if (!nc.connected)
				{
					nc.removeEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
					nc.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onNetSecurityError);
					nc.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, onAsyncError);
					nc.close();
					delete netConnections[i];
				}
			}
		}

		/** 
		 * Handles a failed connection session and dispatches a CONNECTION_FAILED event
		 * @private
		 */
		private function handleFailedConnectionSession(mediaError:MediaError, url:String):void
		{
			CONFIG::LOGGING
			{
				logger.info("NetConnection attempt failed: " + url + " (" + mediaError.errorID + "): " + mediaError.message);
			}
			shutDownUnsuccessfulConnections();
			dispatchEvent
				( new NetConnectionFactoryEvent
					( NetConnectionFactoryEvent.CREATION_ERROR
					, false
					, false
					, null
					, resource
					, mediaError
					)
				);
		}
		
		/** 
		 * Catches any netconnection net security errors
		 * @private
		 */
		private function onNetSecurityError(event:SecurityErrorEvent):void
		{
			handleFailedConnectionSession
				( new MediaError(MediaErrorCodes.SECURITY_ERROR, event.text)
				, NetConnection(event.target).uri
				);
		}

    	/** 
    	 * Catches any async errors
    	 * @private
    	 */
		private function onAsyncError(event:AsyncErrorEvent):void 
		{
			handleFailedConnectionSession
				( new MediaError(MediaErrorCodes.ASYNC_ERROR, event.text)
				, NetConnection(event.target).uri
				);
		}

		/** 
		 * Catches the master timeout when no connections have succeeded within _timeout.
		 * @private
		 */
		private function masterTimeout(event:TimerEvent):void 
		{
			handleFailedConnectionSession
				( new MediaError(MediaErrorCodes.NETCONNECTION_TIMEOUT, "" + DEFAULT_TIMEOUT)
				, ""
				);
		}
		
		private var resource:URLResource;
		private var netConnectionURLs:Vector.<String>;
		private var netConnections:Vector.<NetConnection>;
		private var netConnectionArguments:Vector.<Object>;
		
		private var failedConnectionCount:int;
		private var timeOutTimer:Timer;
		private var connectionTimer:Timer;
		private var attemptIndex:int;
		private var mediaError:MediaError;
		
		private static const DEFAULT_TIMEOUT:Number = 10000;
		private static const CONNECTION_ATTEMPT_INTERVAL:Number = 50;
		
		CONFIG::LOGGING private static const logger:org.osmf.logging.Logger = org.osmf.logging.Log.getLogger("org.osmf.net.NetNegotiator");
	}
}

