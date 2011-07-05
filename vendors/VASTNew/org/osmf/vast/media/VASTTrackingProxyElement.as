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
package org.osmf.vast.media
{
	import __AS3__.vec.Vector;
	
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	import org.osmf.elements.ProxyElement;
	import org.osmf.elements.beaconClasses.Beacon;
	import org.osmf.events.AudioEvent;
	import org.osmf.events.PlayEvent;
	import org.osmf.events.TimeEvent;
	import org.osmf.media.MediaElement;
	import org.osmf.traits.MediaTraitType;
	import org.osmf.traits.PlayState;
	import org.osmf.traits.TimeTrait;
	import org.osmf.traits.TraitEventDispatcher;
	import org.osmf.utils.HTTPLoader;
	import org.osmf.utils.OSMFStrings;
	import org.osmf.vast.model.VASTTrackingEvent;
	import org.osmf.vast.model.VASTTrackingEventType;
	import org.osmf.vast.model.VASTUrl;
	
	/**
	 * A ProxyElement that wraps up another MediaElement and fires
	 * HTTP events as the wrapped media enters different states.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */ 
	public class VASTTrackingProxyElement extends ProxyElement
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
		public function VASTTrackingProxyElement(events:Vector.<VASTTrackingEvent>, httpLoader:HTTPLoader=null, wrappedElement:MediaElement=null)
		{
			setEvents(events);
			this.httpLoader = httpLoader;
			
			playheadTimer = new Timer(250);
			playheadTimer.addEventListener(TimerEvent.TIMER, onPlayheadTimer);
			
			super(wrappedElement);
			
			if (events == null)
			{
				throw new ArgumentError(OSMFStrings.getString(OSMFStrings.INVALID_PARAM));
			}
		}
		
		
		// Overrides
		//
		
		override public function set proxiedElement(value:MediaElement):void
		{
			trace("VASTTrackingProxyElement code is running ");
			
			if (value != proxiedElement)
			{
				if (dispatcher != null)
				{
					dispatcher.removeEventListener(AudioEvent.MUTED_CHANGE, processMutedChange);
					dispatcher.removeEventListener(PlayEvent.PLAY_STATE_CHANGE, processPlayStateChange);
					dispatcher.removeEventListener(TimeEvent.COMPLETE, processComplete);
					dispatcher.media = null;
					dispatcher = null;
				}
	
				if (value != null)
				{
					dispatcher = new TraitEventDispatcher();
					dispatcher.media = value;
					dispatcher.addEventListener(AudioEvent.MUTED_CHANGE, processMutedChange);
					dispatcher.addEventListener(PlayEvent.PLAY_STATE_CHANGE, processPlayStateChange);
					dispatcher.addEventListener(TimeEvent.COMPLETE, processComplete);
				}
			}

			super.proxiedElement = value;
		}
		
		/**
		 * @private 
		 */
		protected function processMutedChange(event:AudioEvent):void
		{
			if (event.muted)
			{
				fireEventOfType(VASTTrackingEventType.MUTE);
			}
		}
		
		/**
		 * @private
		 */
		protected function processPlayStateChange(event:PlayEvent):void
		{
			if (event.playState == PlayState.PLAYING)
			{
				playheadTimer.start();
				if (startReached == false)
				{
					startReached = true;
					
					fireEventOfType(VASTTrackingEventType.START);
				}
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
		
		/**
		 * @private
		 */
		protected function processComplete(event:TimeEvent):void
		{
			playheadTimer.stop();
			
			// Reset our flags so the events can fire once more.
			startReached = false;
			firstQuartileReached = false;
			midpointReached = false;
			thirdQuartileReached = false;
			
			fireEventOfType(VASTTrackingEventType.COMPLETE);
		}

		// Internals
		//
		
		protected function setEvents(events:Vector.<VASTTrackingEvent>):void
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
		
		protected function fireEventOfType(eventType:VASTTrackingEventType, cbShared:Boolean = true):void
		{
			var vastEvent:VASTTrackingEvent = eventsMap[eventType] as VASTTrackingEvent;
			if (vastEvent != null)
			{
				for each (var vastURL:VASTUrl in vastEvent.urls)
				{
					if (vastURL.url != null)
					{
						
						var beacon:Beacon = new Beacon(vastURL.url, httpLoader);
						beacon.ping();
					}
				}
			}
		}
		
		protected function onPlayheadTimer(event:TimerEvent):void
		{
			// Check for 25%, 50%, and 75%.
			var percent:Number = this.percentPlayback;
			
			if (percent >= 25 && firstQuartileReached == false)
			{
				firstQuartileReached = true;
				
				fireEventOfType(VASTTrackingEventType.FIRST_QUARTILE);
			}
			else if (percent >= 50 && midpointReached == false)
			{
				midpointReached = true;
				
				fireEventOfType(VASTTrackingEventType.MIDPOINT);
			}
			else if (percent >= 75 && thirdQuartileReached == false)
			{
				thirdQuartileReached = true;
				
				fireEventOfType(VASTTrackingEventType.THIRD_QUARTILE);
			}
		}
		
		protected function get percentPlayback():Number
		{
			var timeTrait:TimeTrait = getTrait(MediaTraitType.TIME) as TimeTrait;
			if (timeTrait != null)
			{
				var duration:Number = timeTrait.duration;
				return duration > 0 ? 100 * timeTrait.currentTime / duration : 0;
			}
			
			return 0;
		}

		protected var dispatcher:TraitEventDispatcher;
		protected var eventsMap:Dictionary;
			// Key:   VASTTrackingEventType
			// Value: VASTTrackingEvent
		protected var httpLoader:HTTPLoader;
		protected var playheadTimer:Timer;
		
		protected var startReached:Boolean = false;
		protected var firstQuartileReached:Boolean = false;
		protected var midpointReached:Boolean = false;
		protected var thirdQuartileReached:Boolean = false;
	}
}