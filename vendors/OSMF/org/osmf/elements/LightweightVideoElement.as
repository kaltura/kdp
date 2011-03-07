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
package org.osmf.elements
{
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.events.StatusEvent;
	import flash.media.Video;
	import flash.net.NetStream;
	import flash.utils.ByteArray;
	
	import org.osmf.events.DRMEvent;
	import org.osmf.events.MediaError;
	import org.osmf.events.MediaErrorCodes;
	import org.osmf.events.MediaErrorEvent;
	import org.osmf.events.TimeEvent;
	import org.osmf.media.DefaultTraitResolver;
	import org.osmf.media.LoadableElementBase;
	import org.osmf.media.MediaResourceBase;
	import org.osmf.media.URLResource;
	import org.osmf.metadata.CuePoint;
	import org.osmf.metadata.TimelineMetadata;
	import org.osmf.net.DynamicStreamingResource;
	import org.osmf.net.ModifiableTimeTrait;
	import org.osmf.net.NetClient;
	import org.osmf.net.NetLoader;
	import org.osmf.net.NetStreamAudioTrait;
	import org.osmf.net.NetStreamBufferTrait;
	import org.osmf.net.NetStreamCodes;
	import org.osmf.net.NetStreamDisplayObjectTrait;
	import org.osmf.net.NetStreamDynamicStreamTrait;
	import org.osmf.net.NetStreamLoadTrait;
	import org.osmf.net.NetStreamPlayTrait;
	import org.osmf.net.NetStreamSeekTrait;
	import org.osmf.net.NetStreamTimeTrait;
	import org.osmf.net.NetStreamUtils;
	import org.osmf.net.StreamType;
	import org.osmf.net.StreamingURLResource;
	import org.osmf.traits.DRMState;
	import org.osmf.traits.DisplayObjectTrait;
	import org.osmf.traits.LoadState;
	import org.osmf.traits.LoadTrait;
	import org.osmf.traits.LoaderBase;
	import org.osmf.traits.MediaTraitBase;
	import org.osmf.traits.MediaTraitType;
	import org.osmf.traits.TimeTrait;
	import org.osmf.utils.OSMFStrings;

	CONFIG::FLASH_10_1
	{
	import flash.events.DRMAuthenticateEvent;
	import flash.events.DRMErrorEvent;
	import flash.events.DRMStatusEvent;
	import flash.net.drm.DRMContentData;	
	import flash.system.SystemUpdaterType;
	import flash.system.SystemUpdater;	
	import org.osmf.net.drm.NetStreamDRMTrait;
	import org.osmf.net.httpstreaming.HTTPStreamingNetLoader;
	}
	
	/**
	* LightweightVideoElement is a media element specifically created for video playback.
	* It supports both streaming and progressive formats.
	*
	* <p>LightweightVideoElement is a lightweight alternative to VideoElement.  Whereas
	* LightweightVideoElement supports only a subset of video delivery modes (specifically
	* progressive and simple RTMP streaming), VideoElement supports all video delivery
	* modes.</p>   
	* 
	* <p>The LightweightVideoElement uses a NetLoader class to load and unload its media.
	* Developers requiring custom loading logic for video
	* can pass their own loaders to the LightweightVideoElement constructor. 
	* These loaders should subclass NetLoader.</p>
	* <p>The basic steps for creating and using a LightweightVideoElement are:
	* <ol>
	* <li>Create a new URLResource pointing to the URL of the video stream or file
	* containing the video to be loaded.</li>
	* <li>Create a new NetLoader.</li>
	* <li>Create the new LightweightVideoElement, 
	* passing the NetLoader and URLResource
	* as parameters.</li>
	* <li>Create a new MediaPlayer.</li>
	* <li>Assign the LightweightVideoElement to the MediaPlayer's <code>media</code> property.</li>
	* <li>Control the media using the MediaPlayer's methods, properties, and events.</li>
	* <li>When done with the LightweightVideoElement, set the MediaPlayer's <code>media</code>  
	* property to null.  This will unload the LightweightVideoElement.</li>
	* </ol>
	* </p>
	* 
	* <p>The LightweightVideoElement supports Flash Media Token Authentication,  
	* for passing authentication tokens through the NetConnection.</p>
	*
	* <p>The LightweightVideoElement has support for the Flash Player's DRM implementation.
	* Note that the <code>startDate</code>, <code>endDate</code>, and <code>period</code>
	* properties of the DRMTrait on this element correspond to the voucher validity before
	* playback starts.  Once playback begins, these properties correspond to the playback
	* time window (as found on flash.net.drm.DRMVoucher).</p>
	* 
	* @includeExample LightweightVideoElementExample.as -noswf
	* 
	* @see org.osmf.elements.VideoElement
	* @see org.osmf.media.URLResource
	* @see org.osmf.media.MediaElement
	* @see org.osmf.media.MediaPlayer
	* @see org.osmf.net.NetLoader
	* 
 	*  @langversion 3.0
	*  @playerversion Flash 10
	*  @playerversion AIR 1.5
	*  @productversion OSMF 1.0	 	 	
	**/
	public class LightweightVideoElement extends LoadableElementBase
	{
		/**
		 * Constructor.
		 * 
		 * @param resource URLResource that points to the video source that the LightweightVideoElement
		 * will use.  For dynamic streaming content, use a DynamicStreamingResource.
		 * @param loader NetLoader used to load the video.  If null, then a NetLoader will
		 * be used.
		 * 
		 * @throws ArgumentError If resource is not an URLResource. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function LightweightVideoElement(resource:MediaResourceBase=null, loader:NetLoader=null)
		{
			if (loader == null)
			{
				loader = new NetLoader();
			}
			
			super(resource, loader);
			
			if (!(resource == null || resource is URLResource))			
			{
				throw new ArgumentError(OSMFStrings.getString(OSMFStrings.INVALID_PARAM));
			}
		}
		       	
       	/**
       	 * The NetClient used by this object's NetStream.  Will be null until this 
       	 * object has been loaded (as indicated by its LoadTrait entering the READY
       	 * state).
       	 *  
       	 *  @langversion 3.0
       	 *  @playerversion Flash 10
       	 *  @playerversion AIR 1.5
       	 *  @productversion OSMF 1.0
       	 */ 
       	public function get client():NetClient
       	{
       		return stream != null ? stream.client as NetClient : null;
       	}
       	       	
       	/**
       	 * Defines the duration that the element's TimeTrait will expose until the
       	 * element's content is loaded.
       	 * 
       	 * Setting this property to a positive value results in the element becoming
       	 * temporal. Any other value will remove the element's TimeTrait, unless the
       	 * loaded content is exposing a duration. 
       	 *  
       	 *  @langversion 3.0
       	 *  @playerversion Flash 10
       	 *  @playerversion AIR 1.5
       	 *  @productversion OSMF 1.0
       	 */       	
		public function get defaultDuration():Number
		{
			return defaultTimeTrait ? defaultTimeTrait.duration : NaN;
		}

       	public function set defaultDuration(value:Number):void
		{
			if (isNaN(value) || value < 0)
			{
				if (defaultTimeTrait != null)
				{
					// Remove the default trait if the default duration
					// gets set to not a number:
					removeTraitResolver(MediaTraitType.TIME);
					defaultTimeTrait = null;
				}
			}
			else 
			{
				if (defaultTimeTrait == null)
				{		
					// Add the default trait if when default duration
					// gets set:
					defaultTimeTrait = new ModifiableTimeTrait();
		       		addTraitResolver
		       			( MediaTraitType.TIME
		       			, new DefaultTraitResolver
		       				( MediaTraitType.TIME
		       				, defaultTimeTrait
		       				)
		       			);
		  		}
		  		
		  		defaultTimeTrait.duration = value; 
			}	
		}
				
		/**
		 * Specifies whether the video should be smoothed (interpolated) when it is scaled. 
		 * For smoothing to work, the runtime must be in high-quality mode (the default). 
		 * The default value is false (no smoothing).  Set this property to true to take
		 * advantage of mipmapping image optimization.
		 * 
		 * @see flash.media.Video
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		**/
		public function get smoothing():Boolean
		{
			return _smoothing;			
		}

		public function set smoothing(value:Boolean):void
		{
			_smoothing = value;
			if (video != null)
			{
				video.smoothing = value;
			}
		}
		
		/**
		 * Indicates the type of filter applied to decoded video as part of post-processing. The
		 * default value is 0, which lets the video compressor apply a deblocking filter as needed.
		 * See flash.media.Video for more information on deblocking modes.
		 * 
		 * @see flash.media.Video
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */ 
		public function get deblocking():int
		{
			return _deblocking;			
		}

		public function set deblocking(value:int):void
		{
			_deblocking = value;
			if (video != null)
			{
				video.deblocking = value;
			}
		}
		
		/**
		 * The number of frames per second being displayed.  Will be zero until
		 * the video is loaded and playing.
		 **/
		public function get currentFPS():Number
		{
			return stream != null ? stream.currentFPS : 0;
		}

       	// Overrides
       	//
       	
      	/**
		 * @private
		 */
		override protected function createLoadTrait(resource:MediaResourceBase, loader:LoaderBase):LoadTrait
		{
			return new NetStreamLoadTrait(loader, resource);
		}
		
     	/**
		 * @private
		 */
		protected function createVideo():Video
		{
			return new Video();
		}
       	
	    /**
	     * @private
		 */
		override protected function processReadyState():void
		{
			var loadTrait:NetStreamLoadTrait = getTrait(MediaTraitType.LOAD) as NetStreamLoadTrait;
			stream = loadTrait.netStream;
				
			// Set the video's dimensions so that it doesn't appear at the wrong size.
			// We'll set the correct dimensions once the metadata is loaded.  (FM-206)
			video = createVideo();
			video.smoothing = _smoothing;
			video.deblocking = _deblocking;
			video.width = video.height = 0;

			video.attachNetStream(stream);
			
			// Hook up our metadata listeners
			NetClient(stream.client).addHandler(NetStreamCodes.ON_META_DATA, onMetaData);
			NetClient(stream.client).addHandler(NetStreamCodes.ON_CUE_POINT, onCuePoint);
						
			stream.addEventListener(NetStatusEvent.NET_STATUS, onNetStatusEvent);
						
			CONFIG::FLASH_10_1
    		{
    			// Listen for all errors
    			stream.addEventListener(DRMErrorEvent.DRM_ERROR, onDRMErrorEvent);
    						    			 			
     			// Check for DRMContentData
    			var streamingResource:StreamingURLResource = resource as StreamingURLResource;
    			if (streamingResource != null 
					&& streamingResource.drmContentData)
    			{
    				var metadata:ByteArray = streamingResource.drmContentData;
    				setupDRMTrait(metadata);					    				 			
	    		}
				else
				{
					// Non sidecar, we need to play before getting access to the DRMTrait.
	   				stream.addEventListener(StatusEvent.STATUS, onStatus);
   					stream.addEventListener(DRMStatusEvent.DRM_STATUS, onDRMStatus);
				}
    		}
			finishLoad();			
		}
		
		// DRM APIs
		CONFIG::FLASH_10_1
    	{
  			private function onStatus(event:StatusEvent):void
			{
				if (event.code == DRM_STATUS_CODE 
					&& getTrait(MediaTraitType.DRM) == null)
				{			
					createDRMTrait(); 			
	    		}
	  		}
	  		
	  		private function onDRMStatus(event:DRMStatusEvent):void
	  		{
	  			drmTrait.inlineOnVoucher(event);
	  		}	  		 
	  		
	  		// Inline metadata + credentials.  The NetStream is dead at this point, restart with new credentials
	  		private function reloadAfterAuth(event:DRMEvent):void
	  		{
	  			if (drmTrait.drmState == DRMState.AUTHENTICATION_COMPLETE)
	  			{	  				
	  				var loadTrait:NetStreamLoadTrait = getTrait(MediaTraitType.LOAD) as NetStreamLoadTrait;
	  				if (loadTrait.loadState == LoadState.READY)
		  			{				  			
		  				loadTrait.unload();	  	
		  			}
		  			loadTrait.load();	  					  				
	  			}	  				  					
	  		}	
			
			private function createDRMTrait():void
			{				
				drmTrait = new NetStreamDRMTrait();		    	
		    	addTrait(MediaTraitType.DRM, drmTrait);			    				
			}	
			
			private function setupDRMTrait(contentData:ByteArray):void
			{			
	    		createDRMTrait();
			   	drmTrait.drmMetadata = contentData;
			}
							
			private function onDRMErrorEvent(event:DRMErrorEvent):void
			{
				if (event.errorID == DRM_NEEDS_AUTHENTICATION)  // Needs authentication
				{					
					drmTrait.addEventListener(DRMEvent.DRM_STATE_CHANGE, reloadAfterAuth);	 
					drmTrait.drmMetadata = event.contentData;
				}	
				else if (event.drmUpdateNeeded)
				{
					update(SystemUpdaterType.DRM);
				}
				else if (event.systemUpdateNeeded)
				{
					update(SystemUpdaterType.SYSTEM);
				}					
				else // Inline DRM - Errors need to be forwarded
				{						
					drmTrait.inlineDRMFailed(new MediaError(event.errorID));
				}
			}	
						
			private function update(type:String):void
			{
				if (drmTrait == null)
				{
					createDRMTrait();	
				}	
				var updater:SystemUpdater = drmTrait.update(type);	
				updater.addEventListener(Event.COMPLETE, onUpdateComplete);			
			}
		
		}
			
		
		private function finishLoad():void
		{
			var trait:MediaTraitBase;
			var loadTrait:NetStreamLoadTrait = getTrait(MediaTraitType.LOAD) as NetStreamLoadTrait;
			
			trait = loadTrait.getTrait(MediaTraitType.DVR);
			if (trait != null)
			{
	  			addTrait(MediaTraitType.DVR, trait);
  			}
  			
	    	trait = loadTrait.getTrait(MediaTraitType.AUDIO);
	    	addTrait(MediaTraitType.AUDIO, trait || new NetStreamAudioTrait(stream));
	    	
	    	trait = loadTrait.getTrait(MediaTraitType.BUFFER);
	    	addTrait(MediaTraitType.BUFFER, trait || new NetStreamBufferTrait(stream));
			
			var timeTrait:TimeTrait = (trait = loadTrait.getTrait(MediaTraitType.TIME)) as TimeTrait; 
			if (timeTrait == null)
			{
				timeTrait = new NetStreamTimeTrait(stream, loadTrait.resource, defaultDuration)
			}
			addTrait(MediaTraitType.TIME, timeTrait);
			
			trait = loadTrait.getTrait(MediaTraitType.DISPLAY_OBJECT);
			addTrait
				(	MediaTraitType.DISPLAY_OBJECT
				,	trait
				||	new NetStreamDisplayObjectTrait(stream, video, NaN, NaN)
				);
			
			trait = loadTrait.getTrait(MediaTraitType.PLAY);
			addTrait(MediaTraitType.PLAY, trait || new NetStreamPlayTrait(stream, resource));
			
			trait = loadTrait.getTrait(MediaTraitType.SEEK);
			if (trait == null && NetStreamUtils.getStreamType(resource) != StreamType.LIVE)
			{
				trait = new NetStreamSeekTrait(timeTrait, loadTrait, stream);
	  		}
	  		if (trait != null)
	  		{
	  			// Only add the SeekTrait if/when the TimeTrait has a duration,
	  			// otherwise the user might try to seek when a seek cannot actually
	  			// be executed (FM-440).
	  			if (isNaN(timeTrait.duration) || timeTrait.duration == 0)
	  			{
	  				timeTrait.addEventListener(TimeEvent.DURATION_CHANGE, onDurationChange);
	  				
	  				function onDurationChange(event:TimeEvent):void
	  				{
	  					timeTrait.removeEventListener(TimeEvent.DURATION_CHANGE, onDurationChange);
	  					
	  					addTrait(MediaTraitType.SEEK, trait);
	  				}
	  			}
	  			else
	  			{
	    			addTrait(MediaTraitType.SEEK, trait);
	    		}
	    	}
	    	
			var dsResource:DynamicStreamingResource = resource as DynamicStreamingResource;
			if (dsResource != null && loadTrait.switchManager != null)
			{
				var dsTrait:MediaTraitBase = loadTrait.getTrait(MediaTraitType.DYNAMIC_STREAM);
				addTrait(MediaTraitType.DYNAMIC_STREAM, dsTrait || new NetStreamDynamicStreamTrait(stream, loadTrait.switchManager, dsResource));
			}
		}
		
		/**
		 * @private
		 */
		override protected function processUnloadingState():void
		{
			NetClient(stream.client).removeHandler(NetStreamCodes.ON_META_DATA, onMetaData);
			
			stream.removeEventListener(NetStatusEvent.NET_STATUS, onNetStatusEvent);
			
	    	removeTrait(MediaTraitType.AUDIO);
	    	removeTrait(MediaTraitType.BUFFER);
			removeTrait(MediaTraitType.PLAY);
			removeTrait(MediaTraitType.TIME);
			removeTrait(MediaTraitType.DISPLAY_OBJECT);
	    	removeTrait(MediaTraitType.SEEK);
    		removeTrait(MediaTraitType.DYNAMIC_STREAM);
    		removeTrait(MediaTraitType.DVR);
    		
	    	CONFIG::FLASH_10_1
    		{    			
    			stream.removeEventListener(DRMErrorEvent.DRM_ERROR, onDRMErrorEvent);
    			stream.removeEventListener(DRMStatusEvent.DRM_STATUS, onDRMStatus);
    			stream.removeEventListener(StatusEvent.STATUS, onStatus);
    			if (drmTrait != null)
    			{       			
	    			drmTrait.removeEventListener(DRMEvent.DRM_STATE_CHANGE, reloadAfterAuth);	 
	    			removeTrait(MediaTraitType.DRM);  
	    			drmTrait = null;
	    		}  					
    		}
    		
	    	// Null refs to garbage collect.	    	
			video.attachNetStream(null);
			stream = null;
			video = null;
			displayObjectTrait = null;
		}

		private function onMetaData(info:Object):void 
    	{   
			var cuePoints:Array = info.cuePoints;
			
			if (cuePoints != null && cuePoints.length > 0)
			{
				var dynamicCuePoints:TimelineMetadata = getMetadata(CuePoint.DYNAMIC_CUEPOINTS_NAMESPACE) as TimelineMetadata;
				if (dynamicCuePoints == null)
				{
					dynamicCuePoints = new TimelineMetadata(this);
					addMetadata(CuePoint.DYNAMIC_CUEPOINTS_NAMESPACE, dynamicCuePoints);
				}
				
				for (var i:int = 0; i < cuePoints.length; i++)
				{
					var cuePoint:CuePoint = new CuePoint
						( cuePoints[i].type
						, cuePoints[i].time
						, cuePoints[i].name
						, cuePoints[i].parameters
						);
						
					try
					{
						dynamicCuePoints.addMarker(cuePoint);
					}
					catch (error:ArgumentError)
					{
						// Invalid cue points should be ignored.
					}
				}
			}			    		
     	}
     	
     	private function onCuePoint(info:Object):void
     	{
    		if (embeddedCuePoints == null)
     		{
     			embeddedCuePoints = new TimelineMetadata(this);
     			addMetadata(CuePoint.EMBEDDED_CUEPOINTS_NAMESPACE, embeddedCuePoints);
     		}

			var cuePoint:CuePoint = new CuePoint
				( info.type
				, info.time
				, info.name
				, info.parameters
				);
			
			try
			{
				embeddedCuePoints.addMarker(cuePoint);
			}
			catch (error:ArgumentError)
			{
				// Invalid cue points should be ignored.
			}
     	}     	
     	     	
     	// Fired when the DRM subsystem is updated.  NetStream needs to be recreated.
     	private function onUpdateComplete(event:Event):void
     	{          		
    		(getTrait(MediaTraitType.LOAD) as LoadTrait).unload();
    		(getTrait(MediaTraitType.LOAD) as LoadTrait).load();		
     	}
 	    	
     	     	
     	private function onNetStatusEvent(event:NetStatusEvent):void
     	{     		
     		var error:MediaError = null;
 			switch (event.info.code)
			{
				case NetStreamCodes.NETSTREAM_PLAY_FAILED:
				case NetStreamCodes.NETSTREAM_FAILED:
					error = new MediaError(MediaErrorCodes.NETSTREAM_PLAY_FAILED, event.info.description);
					break;
				case NetStreamCodes.NETSTREAM_PLAY_STREAMNOTFOUND:
					error = new MediaError(MediaErrorCodes.NETSTREAM_STREAM_NOT_FOUND, event.info.description);
					break;
				case NetStreamCodes.NETSTREAM_PLAY_FILESTRUCTUREINVALID:
					error = new MediaError(MediaErrorCodes.NETSTREAM_FILE_STRUCTURE_INVALID, event.info.description);
					break;
				case NetStreamCodes.NETSTREAM_PLAY_NOSUPPORTEDTRACKFOUND:
					error = new MediaError(MediaErrorCodes.NETSTREAM_NO_SUPPORTED_TRACK_FOUND, event.info.description);
					break;	
			}
					
			CONFIG::FLASH_10_1
			{
			if (event.info.code == NetStreamCodes.NETSTREAM_DRM_UPDATE)
			{
				update(SystemUpdaterType.DRM);
	     	}
			}
						
			if (error != null)
			{
				dispatchEvent(new MediaErrorEvent(MediaErrorEvent.MEDIA_ERROR, false, false, error));
			}
     	}
     	
     	private var displayObjectTrait:DisplayObjectTrait;
     	private var defaultTimeTrait:ModifiableTimeTrait;
     	
     	private var stream:NetStream;
      	private var video:Video;
      	
		private var embeddedCuePoints:TimelineMetadata;
		private var _smoothing:Boolean;
		private var _deblocking:int;
		
		CONFIG::FLASH_10_1
		{	
		private static const DRM_STATUS_CODE:String 		= "DRM.encryptedFLV";
		private static const DRM_NEEDS_AUTHENTICATION:int	= 3330; 
		private var drmTrait:NetStreamDRMTrait;	
		}
	}
}
