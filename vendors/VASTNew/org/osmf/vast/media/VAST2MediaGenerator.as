/*****************************************************
*  
*  Copyright 2010 Eyewonder, LLC.  All Rights Reserved.
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
*  The Initial Developer of the Original Code is Eyewonder, LLC.
*  Portions created by Eyewonder, LLC. are Copyright (C) 2010 
*  Eyewonder, LLC. A Limelight Networks Business. All Rights Reserved. 
*  
*****************************************************/

package org.osmf.vast.media
{
	import __AS3__.vec.Vector;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import org.osmf.elements.ProxyElement;
	import org.osmf.elements.SWFLoader;
	import org.osmf.elements.VideoElement;
	import org.osmf.elements.beaconClasses.Beacon;
	import org.osmf.events.MediaElementEvent;
	import org.osmf.media.MediaElement;
	import org.osmf.media.MediaFactory;
	import org.osmf.media.URLResource;
	import org.osmf.metadata.Metadata;
	import org.osmf.traits.DisplayObjectTrait;
	import org.osmf.traits.MediaTraitType;
	import org.osmf.utils.HTTPLoader;
	import org.osmf.vast.model.VAST2MediaFile;
	import org.osmf.vast.model.VAST2Translator;
	import org.osmf.vast.model.VASTTrackingEvent;
	import org.osmf.vast.model.VASTTrackingEventType;
	import org.osmf.vast.model.VASTUrl;
	import org.osmf.vast.parser.base.VAST2CompanionElement;
	import org.osmf.vpaid.elements.VPAIDElement;
	import org.osmf.vpaid.metadata.VPAIDMetadata;
	
	CONFIG::LOGGING
	{
		import org.osmf.logging.Logger;
		import org.osmf.logging.Log;
	}

	/**
	 * Utility class for creating MediaElements from a VASTDocument.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */
	public class VAST2MediaGenerator
	{
		/**
		 * Constructor.
		 * 
		 * @param mediaFileResolver The resolver to use when a VASTDocument
		 * contains multiple representations of the same content (MediaFile).
		 * If null, this object will use a DefaultVASTMediaFileResolver.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function VAST2MediaGenerator(mediaFileResolver:IVAST2MediaFileResolver=null, mediaFactory:MediaFactory=null)
		{
			super();
			
			this.mediaFileResolver =
				 mediaFileResolver != null
				 ? mediaFileResolver
				 : new DefaultVAST2MediaFileResolver();
			this.mediaFactory = mediaFactory;	 
			
		}
		
		/**
		 * Creates all relevant MediaElements from the specified VAST document.
		 * 
		 * @param vastDocument The VASTDocument that holds the raw VAST information.
		 * 
		 * @returns A Vector of MediaElements, where each MediaElement
		 * represents a different VASTAd within the VASTDocument. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function createMediaElements(vastDocument:VAST2Translator, vastPlacement:String = null,playerSize:Rectangle = null, translatorIndex:int = 0):Vector.<MediaElement>
		{
			var mediaElements:Vector.<MediaElement> = new Vector.<MediaElement>();
			
			this.vastDocument = vastDocument;
			vastDocument.adPlacement = (vastPlacement == null)?vastDocument.PLACEMENT_LINEAR:vastPlacement;
			
			if(vastDocument.clickThruUrl != null || vastDocument.clickThruUrl != "")
			{
				clickThru = vastDocument.clickThruUrl
			}
			
			
			cacheBuster = new CacheBuster();
			
	
			var trackingEvents:Vector.<VASTTrackingEvent> = new Vector.<VASTTrackingEvent>;
			var proxyChain:Vector.<ProxyElement> = new Vector.<ProxyElement>();
			
			// Check for the Impressions.
			if (vastDocument.impressionArray != null && vastDocument.impressionArray.length > 0)
			{
				var impressionArray:Vector.<VASTUrl> = new Vector.<VASTUrl>;
				for each(var impressionObj:Object in vastDocument.impressionArray)
				{
					var impressionURL:VASTUrl = new VASTUrl(impressionObj.url);
					impressionArray.push(impressionURL);
				}
			}

			addTrackingEvent("trkClickThruEvent", VASTTrackingEventType.CLICK_THRU, trackingEvents);
			addTrackingEvent("errorArray", VASTTrackingEventType.ERROR, trackingEvents);
			addTrackingEvent("trkStartEvent", VASTTrackingEventType.START, trackingEvents);
			addTrackingEvent("trkMidPointEvent", VASTTrackingEventType.MIDPOINT, trackingEvents);
			addTrackingEvent("trkFirstQuartileEvent", VASTTrackingEventType.FIRST_QUARTILE, trackingEvents);
			addTrackingEvent("trkThirdQuartileEvent", VASTTrackingEventType.THIRD_QUARTILE, trackingEvents);
			addTrackingEvent("trkCompleteEvent", VASTTrackingEventType.COMPLETE, trackingEvents);
			addTrackingEvent("trkMuteEvent", VASTTrackingEventType.MUTE, trackingEvents);
			addTrackingEvent("trkCreativeViewEvent", VASTTrackingEventType.CREATIVE_VIEW, trackingEvents);
			addTrackingEvent("trkPauseEvent", VASTTrackingEventType.PAUSE,trackingEvents);
			addTrackingEvent("trkReplayEvent", VASTTrackingEventType.REPLAY, trackingEvents);
			addTrackingEvent("trkFullScreenEvent", VASTTrackingEventType.FULLSCREEN, trackingEvents);
			addTrackingEvent("trkStopEvent", VASTTrackingEventType.STOP, trackingEvents);
			addTrackingEvent("trkUnmuteEvent", VASTTrackingEventType.UNMUTE, trackingEvents);
			addTrackingEvent("trkCloseEvent", VASTTrackingEventType.CLOSE, trackingEvents);
			addTrackingEvent("trkRewindEvent", VASTTrackingEventType.REWIND, trackingEvents);
			addTrackingEvent("trkResumeEvent", VASTTrackingEventType.RESUME, trackingEvents);
			addTrackingEvent("trkExpandEvent", VASTTrackingEventType.EXPAND, trackingEvents);
			addTrackingEvent("trkCollapseEvent", VASTTrackingEventType.COLLAPSE, trackingEvents);
			addTrackingEvent("trkAcceptInvitationEvent", VASTTrackingEventType.ACCEPT_INVITATION, trackingEvents);
			addTrackingEvent("trkSkipEvent", VASTTrackingEventType.SKIP,trackingEvents );
			addTrackingEvent("trkProgressEvent", VASTTrackingEventType.PROGRESS, trackingEvents);
			addTrackingEvent("trkExitFullScreenEvent", VASTTrackingEventType.EXIT_FULLSCREEN, trackingEvents );
			addTrackingEvent("trkCloseLinearEvent", VASTTrackingEventType.CLOSE_LINEAR, trackingEvents );
			
			// Check for Video.
			if (vastDocument.mediafileArray != null && vastDocument.mediafileArray.length > 0 && isLinear)
			{
				
				for each(var mediaObj:Object in vastDocument.mediafileArray)
				{
					var mediaFileObj:VAST2MediaFile = new VAST2MediaFile();
					mediaFileObj.url = mediaObj.url;
					mediaFileObj.delivery = mediaObj.delivery;
					mediaFileObj.bitrate = mediaObj.bitrate;
					mediaFileObj.type = mediaObj.type;
					mediaFileObj.width = mediaObj.width;
					mediaFileObj.height = mediaObj.height;
					mediaFileObj.id = mediaObj.id;
					mediaFileObj.scalable = mediaObj.scalable;
					mediaFileObj.maintainAspectRatio = mediaObj.maintainAspectRatio;
					mediaFileObj.apiFramework = mediaObj.apiFramework;

					var mediaFileURL:Vector.<VAST2MediaFile> = new Vector.<VAST2MediaFile>;
					mediaFileURL.push(mediaFileObj);
				}

				// Resolve the correct one.
				var mediaFile:VAST2MediaFile = mediaFileResolver.resolveMediaFiles(mediaFileURL);
				if (mediaFile != null)
				{
					var mediaURL:String = mediaFile.url;
									
					// If streaming, we may need to strip off the extension.
					if (mediaFile.delivery == "streaming" && mediaFile.type != "application/x-shockwave-flash")
					{
						mediaURL = mediaURL.replace(/\.flv$|\.f4v$/i, "");
						
					}

					var rootElement:MediaElement;
					
					if(mediaFile.type == "application/x-shockwave-flash" ||mediaFile.type == "swf" )
					{
						if (mediaFile.scalable)
						{
							rootElement = new VPAIDElement(new URLResource(mediaFile.url), new SWFLoader(),playerSize.width,playerSize.height);
						}
						else
						{
							rootElement = new VPAIDElement(new URLResource(mediaFile.url), new SWFLoader(),mediaFile.width,mediaFile.height);
						}
						VPAIDMetadata(rootElement.getMetadata("org.osmf.vpaid.metadata.VPAIDMetadata")).addValue(VPAIDMetadata.NON_LINEAR_CREATIVE, false);

					}
					else 
					{
						if (mediaFactory != null)
						{
							rootElement = mediaFactory.createMediaElement(new URLResource(mediaURL)) as VideoElement;
							//VideoElement(rootElement).smoothing = true;
						}
						else
						{
							rootElement = new VideoElement(new URLResource(mediaURL));
							//VideoElement(rootElement).smoothing = true;
						}
						

					}
					
					
					var impressions:VASTImpressionProxyElement = new VAST2ImpressionProxyElement(impressionArray, null, rootElement, cacheBuster);
					var events:VASTTrackingProxyElement = new VAST2TrackingProxyElement(trackingEvents,null, impressions, cacheBuster,clickThru);
					var vastMediaElement:MediaElement = events;
					
					mediaElements.push(vastMediaElement);


				}
			}
			else if(vastDocument.nonlinearArray != null && vastDocument.nonlinearArray.length > 0 && isNonLinear)
			{
				
				//Non-linear check goes here.  If available create VPAID Element
				for each(var element:Object in vastDocument.nonlinearArray)
				{
					
					if(element.creativeType == "application/x-shockwave-flash")
					{
						
						var vpaidElement:MediaElement = new VPAIDElement(new URLResource(element.URL), new SWFLoader());
						var vpaidMetadata:Metadata = vpaidElement.getMetadata(VPAIDMetadata.NAMESPACE);
						vpaidMetadata.addValue(VPAIDMetadata.NON_LINEAR_CREATIVE, true);
						
						
						var impressionsNonLinear:VASTImpressionProxyElement = new VAST2ImpressionProxyElement(impressionArray, null, vpaidElement, cacheBuster);							
						var eventsNonLinear:VASTTrackingProxyElement = new VAST2TrackingProxyElement(trackingEvents,null, impressionsNonLinear, cacheBuster, clickThru);
						var vastMediaElementNonLinear:MediaElement = eventsNonLinear;
					
						mediaElements.push(vastMediaElementNonLinear);
						
					}
				}
				
			}
			
			if(vastDocument.companionArray != null && vastDocument.companionArray.length > 0)
			{
				for each(var companionAd:VAST2CompanionElement in vastDocument.companionArray)
				{	
					CONFIG::LOGGING
					{
						logger.debug("[VAST] Companion ad detected" + companionAd.staticResource);
					}
					var companionElement:CompanionElement = new CompanionElement(companionAd);
					companionElement.scriptPath = companionAd.staticResource;
					mediaElements.push(companionElement);
				}
			}
			
			return mediaElements;
		}
	
		private function get isLinear() : Boolean
		{
			return (vastDocument.adPlacement == VAST2Translator.PLACEMENT_LINEAR);
		}
		private function get isNonLinear() : Boolean
		{
			return (vastDocument.adPlacement == VAST2Translator.PLACEMENT_NONLINEAR);
		}
		
		/**
		 * 
		 * @param evtName property name in vastDocument
		 * @param evtType type of event
		 * @return VASTTrackingEvent with the given evtType and the suitable URLs
		 * 
		 */		
		private function addTrackingEvent(evtName:String, evtType:VASTTrackingEventType, trackingArray:Vector.<VASTTrackingEvent>): void 
		{
			if(trackingArray && vastDocument[evtName] != null && vastDocument[evtName].length > 0)
			{
				var trkEvent:VASTTrackingEvent = new VASTTrackingEvent(evtType);
				var trkArray:Vector.<VASTUrl> = new Vector.<VASTUrl>;
				
				for each(var obj:Object in vastDocument[evtName])
				{
					var url:VASTUrl = new VASTUrl(obj.url);
					trkArray.push(url);
				}
				
				trkEvent.urls = trkArray;
				trackingArray.push(trkEvent);						
			}	

		}
		
		private var mediaFactory:MediaFactory;	
		private var clickThru:String;
		private var httpLoader:HTTPLoader;
		private var vastDocument:VAST2Translator;
		private var mediaFileResolver:IVAST2MediaFileResolver;
		private var vastTranslator:VAST2Translator;
		private var cacheBuster:CacheBuster;
		private var _adPlacement:String;
		
		CONFIG::LOGGING
		{
			private static const logger:Logger = Log.getLogger("org.osmf.vast.media.VAST2MediaGenerator");
		}
	}
}
