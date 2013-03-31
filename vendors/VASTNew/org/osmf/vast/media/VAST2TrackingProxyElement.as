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
*  Contributor(s): Eyewonder, LLC
*  
*****************************************************/
package org.osmf.vast.media
{
	import __AS3__.vec.Vector;
	
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	import org.osmf.containers.MediaContainer;
	import org.osmf.elements.ProxyElement;
	import org.osmf.elements.VideoElement;
	import org.osmf.elements.beaconClasses.Beacon;
	import org.osmf.events.AudioEvent;
	import org.osmf.events.LoadEvent;
	import org.osmf.events.MediaErrorEvent;
	import org.osmf.events.MetadataEvent;
	import org.osmf.events.PlayEvent;
	import org.osmf.events.TimeEvent;
	import org.osmf.media.MediaElement;
	import org.osmf.traits.AudioTrait;
	import org.osmf.traits.LoadState;
	import org.osmf.traits.LoadTrait;
	import org.osmf.traits.MediaTraitType;
	import org.osmf.traits.PlayState;
	import org.osmf.traits.PlayTrait;
	import org.osmf.traits.TimeTrait;
	import org.osmf.traits.TraitEventDispatcher;
	import org.osmf.utils.HTTPLoader;
	import org.osmf.utils.OSMFStrings;
	import org.osmf.vast.metadata.VASTMetadata;
	import org.osmf.vast.model.VASTTrackingEvent;
	import org.osmf.vast.model.VASTTrackingEventType;
	import org.osmf.vast.model.VASTUrl;
	import org.osmf.vpaid.elements.VPAIDElement;
	import org.osmf.vpaid.metadata.VPAIDMetadata;
	
	/**
	 * A ProxyElement that wraps up another MediaElement and fires
	 * HTTP events as the wrapped media enters different states.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */ 
	public class VAST2TrackingProxyElement extends VASTTrackingProxyElement
	{
		/**
		 * Constructor.
		 * 
		 * @param events An Array containing all VAST TrackingEvents which
		 * should trigger the firing of HTTP events.
		 * @param httpLoader The HTTPLoader to use to ping the beacon.  If
		 * null, then a default HTTPLoader will be used.
		 * @param wrappedElement The MediaElement to wrap.
		 * 
		 * @throws ArgumentError If urls is null.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function VAST2TrackingProxyElement(events:Vector.<VASTTrackingEvent>, httpLoader:HTTPLoader=null, wrappedElement:MediaElement=null, cacheBust:CacheBuster = null,  clickURL:String = "")
		{ 
			super(events);
			clickThruURL = clickURL;
			
			if (cacheBust == null) // Cachebuster should be shared across all events for the same ad view due to synchronization/correlation that happens on some ad servers
				cacheBuster = new CacheBuster()
			else
				cacheBuster = cacheBust;
						
			proxiedElement = wrappedElement;

			dispatcher = new TraitEventDispatcher();
			dispatcher.media = wrappedElement;
			dispatcher.addEventListener(LoadEvent.LOAD_STATE_CHANGE, processLoadStateChange);
			dispatcher.media.addEventListener(MediaErrorEvent.MEDIA_ERROR, mediaError);
			
			
			if(proxiedElement != null && ProxyElement(this.proxiedElement).proxiedElement is VPAIDElement)
			{
				var vpaidElement:VPAIDElement = ProxyElement(this.proxiedElement).proxiedElement as VPAIDElement;
				var vpaidMetadata:VPAIDMetadata = vpaidElement.getMetadata(vpaidElement.metadataNamespaceURLs[0]) as VPAIDMetadata;
				vpaidMetadata.addEventListener(MetadataEvent.VALUE_ADD, onMetadataValueAdded);
				vpaidMetadata.addEventListener(MetadataEvent.VALUE_CHANGE, onMetadataValueChange);
			}

			if(ProxyElement(this.proxiedElement).proxiedElement is VideoElement)
			{
				var vastMetadata:VASTMetadata = new VASTMetadata();
				addMetadata(VASTMetadata.NAMESPACE, vastMetadata);
				vastMetadata.addEventListener(MetadataEvent.VALUE_CHANGE, onMetadataValueChange);
				vastMetadata.addEventListener(MetadataEvent.VALUE_ADD, onMetadataValueAdded);
				
				
			}

		}
		
		private function onMetadataValueAdded(e:MetadataEvent):void
		{
			
			switch(e.key)
			{
				case VPAIDMetadata.AD_COLLAPSE:
					fireEventOfType(VASTTrackingEventType.COLLAPSE, false);
				break;
				
				case VPAIDMetadata.AD_EXPAND:
					fireEventOfType(VASTTrackingEventType.EXPAND, false);
				break;
				
				case VPAIDMetadata.AD_USER_ACCEPT_INVITATION:
					fireEventOfType(VASTTrackingEventType.ACCEPT_INVITATION, false);
				break;
				
				case VPAIDMetadata.AD_USER_CLOSE:
					fireEventOfType(VASTTrackingEventType.CLOSE);
				break;
				
				case VPAIDMetadata.AD_USER_MINIMIZE:
					fireEventOfType(VASTTrackingEventType.USER_MINIMIZE, false);
				break;
				
				case VPAIDMetadata.AD_CREATIVE_VIEW:
					fireEventOfType(VASTTrackingEventType.CREATIVE_VIEW);
				break;
				
				case VPAIDMetadata.AD_VOLUME_CHANGE:
				
				var audioTrait:AudioTrait = MediaElement(ProxyElement(this.proxiedElement).proxiedElement).getTrait(MediaTraitType.AUDIO) as AudioTrait;
				//trace("--- Audio Volume Changed IN onMetadataValueAdded --- " + audioTrait.volume + "PLAYER VOLUME == " + playerVolume);
				playerVolume = audioTrait.volume;
				if (audioTrait.volume != 0 && mute)
				{
					mute = false;
					fireEventOfType(VASTTrackingEventType.UNMUTE, false);
					//trace("onMetadataValueAdded == FIRING THE UNMUTE EVENT");
				}
				else if (audioTrait.volume == 0 && !mute)
				{	
					mute = true;
					fireEventOfType(VASTTrackingEventType.MUTE, false);
					//trace("onMetadataValueAdded == FIRING THE MUTE EVENT");
				}	
				break;
				
				case VPAIDMetadata.AD_REWIND:
					fireEventOfType(VASTTrackingEventType.REWIND, false);
				break;
				
				case VPAIDMetadata.AD_RESUME:
					fireEventOfType(VASTTrackingEventType.RESUME, false);
				break;
				
				case VPAIDMetadata.AD_FULLSCREEN:
					fireEventOfType(VASTTrackingEventType.FULLSCREEN, false);
				break;
				/* In VASTImpressionProxyElement. 
				TODO: Combine VASTTrackingProxyElement with VASTImpressionProxyElement
				
				case VPAIDMetadata.AD_IMPRESSION:
				
					fireEventOfType(VASTTrackingEventType.IMPRESSION);
				break;
				*/
				case VPAIDMetadata.AD_VIDEO_START:
				
					fireEventOfType(VASTTrackingEventType.START);
				break;
				
				case VPAIDMetadata.AD_VIDEO_FIRST_QUARTILE:
				
					fireEventOfType(VASTTrackingEventType.FIRST_QUARTILE);
				break;
				
				case VPAIDMetadata.AD_VIDEO_MID_POINT:
				
					fireEventOfType(VASTTrackingEventType.MIDPOINT);
				break;				
				
				case VPAIDMetadata.AD_VIDEO_THIRD_QUARTILE:
				
					fireEventOfType(VASTTrackingEventType.THIRD_QUARTILE);
				break;
				
				case VPAIDMetadata.AD_VIDEO_COMPLETE:
				
					fireEventOfType(VASTTrackingEventType.COMPLETE);
				break;
				
				case VPAIDMetadata.AD_CLOSE:
				
					fireEventOfType(VASTTrackingEventType.CLOSE);
				break;
				
				case VPAIDMetadata.AD_CLICKTRK:
				
					fireEventOfType(VASTTrackingEventType.CLICK_THRU, false);
			
				break;

				case VPAIDMetadata.AD_ERROR:
					
					fireEventOfType(VASTTrackingEventType.ERROR);
			
				break;
				
				case VASTMetadata.CLICKTHRU:
					//trace("Metadata CLICKTHRU");
					onMediaElementClick(e.value);
				break;				
			}
		}
		
		private function onMetadataValueChange(e:MetadataEvent):void
		{
			
			switch(e.key)
			{
				case VPAIDMetadata.AD_COLLAPSE:
					fireEventOfType(VASTTrackingEventType.COLLAPSE);
				break;
				
				case VPAIDMetadata.AD_EXPAND:
					fireEventOfType(VASTTrackingEventType.EXPAND);
				break;
				
				case VPAIDMetadata.AD_USER_ACCEPT_INVITATION:
					fireEventOfType(VASTTrackingEventType.ACCEPT_INVITATION);
				break;
				
				case VPAIDMetadata.AD_USER_CLOSE:
					fireEventOfType(VASTTrackingEventType.CLOSE);
				break;
				
				case VPAIDMetadata.AD_USER_MINIMIZE:
					fireEventOfType(VASTTrackingEventType.USER_MINIMIZE);
				break;
				
				case VPAIDMetadata.AD_CREATIVE_VIEW:
					fireEventOfType(VASTTrackingEventType.CREATIVE_VIEW);
				break;
				
				case VPAIDMetadata.AD_VOLUME_CHANGE:
				
				var audioTrait:AudioTrait = MediaElement(ProxyElement(this.proxiedElement).proxiedElement).getTrait(MediaTraitType.AUDIO) as AudioTrait;
				//trace("--- Audio Volume Changed IN onMetadataValueChange --- " + audioTrait.volume + "PLAYER VOLUME == " + playerVolume);
				playerVolume = audioTrait.volume;
				if (mute && audioTrait.volume  != 0)
				{
					mute = false;
					fireEventOfType(VASTTrackingEventType.UNMUTE);
					//trace("onMetadataValueChange == FIRING UNMUTE EVENT");
				}	
				else if (!mute && audioTrait.volume == 0)
				{
					mute = true;
					fireEventOfType(VASTTrackingEventType.MUTE);
					//trace("onMetadataValueChange == FIRING MUTE EVENT");
				}
				break;
				
				case VPAIDMetadata.AD_REWIND:
					fireEventOfType(VASTTrackingEventType.REWIND);
				break;
				
				case VPAIDMetadata.AD_RESUME:
					fireEventOfType(VASTTrackingEventType.RESUME);
				break;
				
				case VPAIDMetadata.AD_FULLSCREEN:
					fireEventOfType(VASTTrackingEventType.FULLSCREEN);
				break;
				/* In VASTImpressionProxyElement. 
				TODO: Combine VASTTrackingProxyElement with VASTImpressionProxyElement
				
				case VPAIDMetadata.AD_IMPRESSION:
				
					fireEventOfType(VASTTrackingEventType.IMPRESSION);
				break;
				*/
				case VPAIDMetadata.AD_VIDEO_START:
				
					fireEventOfType(VASTTrackingEventType.START);
				break;
				
				case VPAIDMetadata.AD_VIDEO_FIRST_QUARTILE:
				
					fireEventOfType(VASTTrackingEventType.FIRST_QUARTILE);
				break;
				
				case VPAIDMetadata.AD_VIDEO_MID_POINT:
				
					fireEventOfType(VASTTrackingEventType.MIDPOINT);
				break;				
				
				case VPAIDMetadata.AD_VIDEO_THIRD_QUARTILE:
				
					fireEventOfType(VASTTrackingEventType.THIRD_QUARTILE);
				break;
				
				case VPAIDMetadata.AD_VIDEO_COMPLETE:
				
					fireEventOfType(VASTTrackingEventType.COMPLETE);
				break;
				
				case VPAIDMetadata.AD_CLOSE:
				
					fireEventOfType(VASTTrackingEventType.CLOSE);
				break;
				
				case VPAIDMetadata.AD_CLICKTRK:
				
					fireEventOfType(VASTTrackingEventType.CLICK_THRU);
			
				break;

				case VPAIDMetadata.AD_ERROR:
					
					fireEventOfType(VASTTrackingEventType.ERROR);
			
				break;
				case VASTMetadata.CLICKTHRU:
					
					onMediaElementClick(e.value);
				break;
			}
		}
		
		private function onTimeComplete(e:TimeEvent):void
		{
			mediaContainer.buttonMode = false;
			mediaContainer.removeEventListener(MouseEvent.MOUSE_UP,onMediaElementClick);		
		}		
		
		private function onLoadStateChange(e:LoadEvent):void
		{
			//If VAST and load error fire off load tracker
			if(ProxyElement(this.proxiedElement).proxiedElement is VideoElement && e.loadState == LoadState.LOAD_ERROR)
			{
				fireEventOfType(VASTTrackingEventType.ERROR);
			}
		}
		
		private function mediaError(event:MediaErrorEvent):void
		{
			fireEventOfType(VASTTrackingEventType.ERROR);
		}
		
		// Overrides
		//
		
		/**
		 * @private
		 */
		override protected function processMutedChange(event:AudioEvent):void
		{
			//trace("MUTE == " + mute);
			//trace("PLAYER VOLUME " + playerVolume);
			if (event.muted && !mute)
			{
				mute = true;
				fireEventOfType(VASTTrackingEventType.MUTE);
				//trace("processMutedChange == FIRING THE MUTE EVENT");
			}	
			else if (mute && !event.muted)
			{
				mute = false;
				fireEventOfType(VASTTrackingEventType.UNMUTE);
				//trace("processMutedChange == FIRING THE UNMUTE EVENT");
			}	
		}

		//EyeWonder addition - sometimes the play trait event fires before the load ready event is fired
		//We need check to see if the play trait is playing. If so start tracking.		
		private function processLoadStateChange(event:LoadEvent):void
		{
			//trace("Tracker Proxy LoadState: " + event.loadState);
			if(event.loadState == LoadState.READY)
			{
				var playTrait:PlayTrait = getTrait(MediaTraitType.PLAY) as PlayTrait;
				if (container != null && container != null)
				{
					if(ProxyElement(this.proxiedElement).proxiedElement is VideoElement)
					{
						//trace("Firing Creative View");
						fireEventOfType(VASTTrackingEventType.CREATIVE_VIEW);//Want to fire only for linear creatives. Nonlinear fires it's own AD_CREATIVE_VIEW
						createClickTrhu();
						if(ProxyElement(this.proxiedElement).proxiedElement.hasTrait(MediaTraitType.TIME))
						{
							
							var timeTrait:TimeTrait = ProxyElement(this.proxiedElement).proxiedElement.getTrait(MediaTraitType.TIME) as TimeTrait;
							timeTrait.addEventListener(TimeEvent.COMPLETE, onTimeComplete);
						}
				
					}
				}
				if(playTrait.playState == PlayState.PLAYING)
				{
					onMediaElementPlay();
				}
			}
		}
		
		private function createClickTrhu():void
		{
			//Add a mouse event to the media container for clickThru support
			mediaContainer = container as MediaContainer;
			mediaContainer.buttonMode = true;
			mediaContainer.addEventListener(MouseEvent.MOUSE_UP,onMediaElementClick);		
		}
		
		/**
		 * @private
		 */
		override protected function processPlayStateChange(event:PlayEvent):void
		{
			if (event.playState == PlayState.PLAYING)
			{
				//EW addition see processLoadStateChange function for details.
				onMediaElementPlay();
			}
			else if (event.playState == PlayState.PAUSED)
			{
				fireEventOfType(VASTTrackingEventType.PAUSE);
			}
			else
			{
				playheadTimer.stop();
			}
		}
		
		private function onMediaElementPlay():void
		{
			playheadTimer.start();
			if (startReached == false){
				startReached = true;
				fireEventOfType(VASTTrackingEventType.START);
			}else{
				fireEventOfType(VASTTrackingEventType.RESUME);
			}
		}
		
		/**
		 * @private
		 */
		override protected function processComplete(event:TimeEvent):void
		{
			playheadTimer.stop();
			
			// Reset our flags so the events can fire once more.
			startReached = false;
			firstQuartileReached = false;
			midpointReached = false;
			thirdQuartileReached = false;
			
			fireEventOfType(VASTTrackingEventType.COMPLETE);
			//if (VAST1)
				fireEventOfType(VASTTrackingEventType.STOP);			
			//if (VAST2)
				fireEventOfType(VASTTrackingEventType.CLOSE);
		}

		// Internals
		//
		
		override protected function setEvents(events:Vector.<VASTTrackingEvent>):void
		{
			eventsMap = new Dictionary();
			
			if (events != null)
			{
				for each (var event:VASTTrackingEvent in events)
				{
					
					eventsMap[event.type] = event;
				}
			}
		}
		
		override protected function fireEventOfType(eventType:VASTTrackingEventType, cbShared:Boolean = true):void
		{
			var vastEvent:VASTTrackingEvent = eventsMap[eventType] as VASTTrackingEvent;
			
			if (vastEvent != null)
			{
				for each (var vastURL:VASTUrl in vastEvent.urls)
				{
					//trace("------------------- " + vastURL.url);
					var cb:CacheBuster = cacheBuster;
					// For some trackers that can be fired multiple times such as mute/unmute. For all the rest, especially 
					// impressions+clickthrus, use same cb value to make "Jump tags" and correlations work better.
					// Even though clickthrus can be called multiple times, they are redirects and usually cachebusted on the server
					// Side. Some types of clickthrus like "Jump tags" won't work if impression and clickthru cachebuster don't match (not 
					// clicktracker, but actual clickthru redirect). Note that when cbShared is set to false, the tracker may not work for
					// research study correlations.
					if (cbShared == false)  
					{	
						cb = new CacheBuster();
					}
					// Fire off the event tracker
					if (vastURL.url != null)
					{
						var beacon:Beacon = new Beacon(cb.cacheBustURL(vastURL.url), httpLoader);
						beacon.ping();
					}
				}
			}
		}
		
		private function getBrowserEngine() : String
		{
			// Get User Agent
			try
			{
				var userAgent : String = ExternalInterface.call("eval", "navigator.userAgent");
				userAgent = userAgent.toLowerCase();
				var isIe : Boolean = (userAgent.indexOf("msie") >= 0);
				var isOpera : Boolean = (userAgent.indexOf('opera') >= 0);
				if(isOpera) isIe = false;
				var isSafari : Boolean = (userAgent.indexOf('applewebkit') >= 0 || userAgent.indexOf('konqueror') >= 0);
				var isGecko : Boolean = (userAgent.indexOf('gecko/') > 0);
			
				if(isIe) browserEngine = 'msie';
				if(isOpera) browserEngine = 'opera';
				if(isSafari) browserEngine = 'webkit';
				if(isGecko) browserEngine = 'gecko';
			}
			catch ( e : Error )
			{
				browserEngine = 'unknown';
			}
			
			return browserEngine;
		}		
		
		
		
		private function onMediaElementClick(e:MouseEvent):void
		{
			
			if(cacheBuster != null && clickThruURL != null)
			{
				getURL(cacheBustURL(clickThruURL), "_blank");
				fireEventOfType(VASTTrackingEventType.CLICK_THRU);
			}
		}
		
		private function getURL( url : String, window : String = "_self" ) : void
		{
			var compatBrowser : Boolean = false;
			browserEngine = getBrowserEngine();
			switch( browserEngine ) {
				case "webkit":
				case "opera":
				case "internabl":
				case "unknown":
				case "aim":
					compatBrowser = false;
					break;
				default:
					compatBrowser = true;
			}

			var request : URLRequest = new URLRequest(url);
			flash.net.navigateToURL(request, window);
		}
		
		private function cacheBustURL(urlToTag:String):String
		{
			return cacheBuster.cacheBustURL( urlToTag, CacheBuster.AD);
		}
			
		protected var browserEngine : String = 'unknown';
		protected var clickThruURL:String;
		protected var cacheBuster:CacheBuster;
		protected var mute:Boolean = false;
		protected var playerVolume:Number = 0;
		protected var mediaContainer:MediaContainer;
	}
}