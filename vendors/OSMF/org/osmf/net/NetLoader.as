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
	import __AS3__.vec.Vector;
	
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.utils.Dictionary;
	
	import org.osmf.events.MediaError;
	import org.osmf.events.MediaErrorCodes;
	import org.osmf.events.MediaErrorEvent;
	import org.osmf.events.NetConnectionFactoryEvent;
	import org.osmf.media.MediaResourceBase;
	import org.osmf.media.MediaType;
	import org.osmf.media.MediaTypeUtil;
	import org.osmf.media.URLResource;
	import org.osmf.traits.LoadState;
	import org.osmf.traits.LoadTrait;
	import org.osmf.traits.LoaderBase;
	import org.osmf.utils.URL;

	/**
	 * The NetLoader class extends LoaderBase to provide
	 * loading support to the AudioElement and VideoElement classes.
	 * <p>Supports both streaming and progressive media resources.
	 * If the resource URL is RTMP, connects to an RTMP server by invoking a NetConnectionFactoryBase. 
	 * NetConnections may be shared between LoadTrait instances.
	 * If the resource URL is HTTP, performs a <code>connect(null)</code>
	 * for progressive downloads.</p>
	 * The NetLoader supports Flash Media Token Authentication,  
	 * for passing authentication tokens through the NetConnection.
	 *
	 * @includeExample NetLoaderExample.as -noswf
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */
	public class NetLoader extends LoaderBase
	{
		/**
		 * Constructor.
		 * 
		 * @param factory The NetConnectionFactoryBase instance to use for managing NetConnections.
		 * If factory is null, a NetConnectionFactory will be created and used. Since the
		 * NetConnectionFactory class facilitates connection sharing, this is an easy way of
		 * enabling global sharing, by creating a single NetConnectionFactory instance within
		 * the player and then handing it to all NetLoader instances.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function NetLoader(factory:NetConnectionFactoryBase=null)
		{
			super();

			netConnectionFactory = factory || new NetConnectionFactory();
			netConnectionFactory.addEventListener(NetConnectionFactoryEvent.CREATION_COMPLETE, onCreationComplete);
			netConnectionFactory.addEventListener(NetConnectionFactoryEvent.CREATION_ERROR, onCreationError);
		}
		
		/**
		 * @private
		 * 
		 * The NetLoader returns true for URLResources which support the media and mime-types
		 * (or file extensions) for streaming audio and streaming or progressive video, or
		 * implement one of the following schemes: http, https, file, rtmp, rtmpt, rtmps,
		 * rtmpe or rtmpte.
		 * 
		 * @param resource The URL of the source media.
		 * @return Returns <code>true</code> for URLResources which it can load
		 * @inheritDoc
		**/
		override public function canHandleResource(resource:MediaResourceBase):Boolean
		{
			var rt:int = MediaTypeUtil.checkMetadataMatchWithResource(resource, MEDIA_TYPES_SUPPORTED, MIME_TYPES_SUPPORTED);
			if (rt != MediaTypeUtil.METADATA_MATCH_UNKNOWN)
			{
				return rt == MediaTypeUtil.METADATA_MATCH_FOUND;
			}			

			/*
			 * The rules for URL checking is outlined as below:
			 * 
			 * If the URL is null or empty, we assume being unable to handle the resource
			 * If the URL has no protocol, we check for file extensions
			 * If the URL has protocol, we have to make a distinction between progressive and stream
			 * 		If the protocol is progressive (file, http, https), we check for file extension
			 *		If the protocol is stream (the rtmp family), we assume that we can handle the resource
			 *
			 * We assume being unable to handle the resource for conditions not mentioned above
			 */
			var res:URLResource = resource as URLResource;
			var extensionPattern:RegExp = new RegExp("\.flv$|\.f4v$|\.mov$|\.mp4$|\.mp4v$|\.m4v$|\.3gp$|\.3gpp2$|\.3g2$", "i");
			var url:URL = res != null ? new URL(res.url) : null;
			if (url == null || url.rawUrl == null || url.rawUrl.length <= 0)
			{
				return false;
			}
			if (url.protocol == "")
			{
				return extensionPattern.test(url.path);
			}
			if (NetStreamUtils.isRTMPStream(url.rawUrl))
			{
				return true;
			}
			if (url.protocol.search(/file$|http$|https$/i) != -1)
			{
				
				return (url.path == null ||
						url.path.length <= 0 ||
						url.path.indexOf(".") == -1 ||
						extensionPattern.test(url.path));
			}
			
			return false;
		}
		
		/**
		 *
		 * The factory function for creating a NetStream.
		 * 
		 * @param connection The NetConnection to associate with the new NetStream.
		 * @param resource The resource whose content will be played in the NetStream.
		 * 
		 * @return A new NetStream associated with the NetConnection.
		**/
		protected function createNetStream(connection:NetConnection, resource:URLResource):NetStream
		{
			return new NetStream(connection);
		}

		/**
		 * The factory function for creating a NetStreamSwitchManagerBase.
		 * 
		 * @param connection The NetConnection that's associated with the NetStreamSwitchManagerBase.
		 * @param netStream The NetStream upon which the NetStreamSwitchManagerBase will operate.
		 * @param dsResource The resource upon which the NetStreamSwitchManagerBase will operate.
		 * 
		 * @return The NetStreamSwitchManagerBase for the NetStream, null if multi-bitrate switching
		 * is not enabled for the NetStream.
		 **/
 		protected function createNetStreamSwitchManager(connection:NetConnection, netStream:NetStream, dsResource:DynamicStreamingResource):NetStreamSwitchManagerBase
		{
			return null;
		}
				
		/**
		 * @private
		 * 
		 * Subclass stub that can be used to do special processing just upfront
		 * the loader finishing loading. Also, the overriding method must 
		 * call the updateLoadTrait method at the end.
		 *  
		 * @param loadTrait
		 */		
		protected function processFinishLoading(loadTrait:NetStreamLoadTrait):void
		{	
			updateLoadTrait(loadTrait, LoadState.READY);
		}

		/**
		 * @private
		 * 
		 * Validates the LoadTrait to verify that this class can in fact load it. Examines the protocol
		 * associated with the LoadTrait's resource. If the protocol is HTTP, calls the <code>startLoadingHTTP()</code>
		 * method. If the protocol is RTMP-based, calls the  <code>startLoadingRTMP()</code> method. If the URL protocol is invalid,
		 * dispatches a mediaErroEvent against the LoadTrait and updates the LoadTrait's state to LoadState.LOAD_ERROR.
	     *
	     * @param loadTrait LoadTrait requesting this load operation.
	     * @see org.osmf.traits.LoadTrait
	     * @see org.osmf.traits.LoadState
	     * @see org.osmf.events.MediaErrorEvent
		 * @inheritDoc
		**/
		override protected function executeLoad(loadTrait:LoadTrait):void
		{	
			updateLoadTrait(loadTrait, LoadState.LOADING);
			var url:URL = new URL((loadTrait.resource as URLResource).url);
			switch (url.protocol)
			{
				case PROTOCOL_RTMP:
				case PROTOCOL_RTMPS:
				case PROTOCOL_RTMPT:
				case PROTOCOL_RTMPE:
				case PROTOCOL_RTMPTE:
					startLoadingRTMP(loadTrait);
					break;
				case PROTOCOL_HTTP:
				case PROTOCOL_HTTPS:
				case PROTOCOL_FILE:
				case PROTOCOL_EMPTY: 
					startLoadingHTTP(loadTrait);
					break;
				default:
					updateLoadTrait(loadTrait, LoadState.LOAD_ERROR);
					loadTrait.dispatchEvent
						( new MediaErrorEvent
							( MediaErrorEvent.MEDIA_ERROR
							, false
							, false
							, new MediaError(MediaErrorCodes.URL_SCHEME_INVALID)
							)
						);
					break;
			}
		}
		
		/**
		 * @private
		 * 
	     * Unloads the media after validating the unload operation against the LoadTrait.
	     * Closes the NetStream defined within the NetStreamLoadTrait object,
	     * as well as the NetConnection defined within the trait object.  Dispatches the
	     * loadStateChange event with every state change.
	     * 
	     * @throws IllegalOperationError if the parameter is <code>null</code>.
	     * @param loadTrait LoadTrait to be unloaded.
	     * @see org.osmf.loaders.LoaderBase#event:loadStateChange	
		**/
		override protected function executeUnload(loadTrait:LoadTrait):void
		{
			var netLoadTrait:NetStreamLoadTrait = loadTrait as NetStreamLoadTrait;			
			
			updateLoadTrait(loadTrait, LoadState.UNLOADING); 			
			netLoadTrait.netStream.close();
			if (netLoadTrait.netConnectionFactory != null)
			{
				netLoadTrait.netConnectionFactory.closeNetConnection(netLoadTrait.connection);
			}
			else
			{
				netLoadTrait.connection.close();
			}
			updateLoadTrait(loadTrait, LoadState.UNINITIALIZED); 				
		}
		
		/**
		 *  Establishes a new NetStream on the connected NetConnection and signals that loading is complete.
		 *
		 *  @private
		**/
		private function finishLoading(connection:NetConnection, loadTrait:LoadTrait, factory:NetConnectionFactoryBase = null):void
		{
			var netLoadTrait:NetStreamLoadTrait = loadTrait as NetStreamLoadTrait;
			if (netLoadTrait != null)
			{
				netLoadTrait.connection = connection;
				var netStream:NetStream = createNetStream(connection, netLoadTrait.resource as URLResource);				
				netStream.client = new NetClient();
				netLoadTrait.netStream = netStream;
				netLoadTrait.switchManager = createNetStreamSwitchManager(connection, netStream, netLoadTrait.resource as DynamicStreamingResource);
				netLoadTrait.netConnectionFactory = factory;
				
				processFinishLoading(loadTrait as NetStreamLoadTrait);
			}
		}	
		
		/**
		 * Initiates the process of creating a connected NetConnection
		 * 
		 * @private
		 */
		private function startLoadingRTMP(loadTrait:LoadTrait):void
		{
			addPendingLoad(loadTrait);
			
			netConnectionFactory.create(loadTrait.resource as URLResource);
		}
		
		/**
		 * Called once the NetConnectionFactoryBase has successfully created a NetConnection
		 * 
		 * @private
		 */
		private function onCreationComplete(event:NetConnectionFactoryEvent):void
		{
			finishLoading
				( event.netConnection
				, findAndRemovePendingLoad(event.resource)
				, event.currentTarget as NetConnectionFactoryBase
				);
		}
		
		/**
		 * Called once the NetConnectionFactoryBase has failed to create a NetConnection
		 * TBD - error dispatched at lower level.
		 * 
		 * @private
		 */
		private function onCreationError(event:NetConnectionFactoryEvent):void
		{
			var loadTrait:LoadTrait = findAndRemovePendingLoad(event.resource);
			if (loadTrait != null)
			{
				loadTrait.dispatchEvent(new MediaErrorEvent(MediaErrorEvent.MEDIA_ERROR, false, false, event.mediaError));
				updateLoadTrait(loadTrait, LoadState.LOAD_ERROR);
			}
		}
		
		/**
		 * Initiates a HTTP connection.
		 * 
		 * @private
		 * 
		 */
		private function startLoadingHTTP(loadTrait:LoadTrait):void
		{
			var connection:NetConnection = new NetConnection();
			connection.client = new NetClient();
			connection.connect(null);
			finishLoading(connection, loadTrait);
		}
		
		private function addPendingLoad(loadTrait:LoadTrait):void
		{
			// It's an edge case, but we don't want to assume that we'll never
			// have two LoadTraits that use the same URLResource, so we have to
			// maintain an Array.
			if (pendingLoads[loadTrait.resource] == null)
			{
				pendingLoads[loadTrait.resource] = [loadTrait];
			}
			else
			{
				pendingLoads[loadTrait.resource].push(loadTrait);
			}
		}
		
		private function findAndRemovePendingLoad(resource:URLResource):LoadTrait
		{
			var loadTrait:LoadTrait = null;
			
			var pendingLoadsArray:Array = pendingLoads[resource];
			if (pendingLoadsArray != null)
			{
				if (pendingLoadsArray.length == 1)
				{
					loadTrait = pendingLoadsArray[0] as LoadTrait;
					delete pendingLoads[resource];
				}
				else
				{
					for (var i:int = 0; i < pendingLoadsArray.length; i++)
					{
						loadTrait = pendingLoadsArray[i];
						if (loadTrait.resource == resource)
						{
							pendingLoadsArray.splice(i, 1);
							break;
						}
					}
				}
			}

			return loadTrait;
		}

		private var netConnectionFactory:NetConnectionFactoryBase;
		private var pendingLoads:Dictionary = new Dictionary();
		
		private static const PROTOCOL_RTMP:String = "rtmp";
		private static const PROTOCOL_RTMPS:String = "rtmps";
		private static const PROTOCOL_RTMPT:String = "rtmpt";
		private static const PROTOCOL_RTMPE:String = "rtmpe";
		private static const PROTOCOL_RTMPTE:String = "rtmpte";
		private static const PROTOCOL_HTTP:String = "http";
		private static const PROTOCOL_HTTPS:String = "https";
		private static const PROTOCOL_FILE:String = "file";
		private static const PROTOCOL_EMPTY:String = "";
				
		private static const MEDIA_TYPES_SUPPORTED:Vector.<String> = Vector.<String>([MediaType.VIDEO]);
		private static const MIME_TYPES_SUPPORTED:Vector.<String> = Vector.<String>
		([
			"video/x-flv", 
			"video/x-f4v", 
			"video/mp4", 
			"video/mp4v-es", 
			"video/x-m4v", 
			"video/3gpp", 
			"video/3gpp2", 
			"video/quicktime", 
		]);
	}
}

