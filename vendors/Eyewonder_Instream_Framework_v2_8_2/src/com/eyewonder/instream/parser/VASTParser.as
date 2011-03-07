/*
VASTParser.as

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

Parser VAST formatted XML ad tags.

*/
package com.eyewonder.instream.parser {
	
	/**
	 * @author mthomas
	 */
	import com.eyewonder.instream.parser.events.ParserEvent;
	import com.eyewonder.instream.debugger.*;
	
	import flash.events.Event;

	public dynamic class VASTParser extends Parser {
		
		public static const TOGGLE_VAST_WRAPPER_CALLED:String = "toggleVastWrapperCalled";
		
		// InLine
		public var _adTagID : String;
		public var _adTagWrapperSystem : String;
		public var _VASTAdTagURL : String;
		public var _adTagSystem : String;
		public var _adTagTitle : String;
		public var _adTagImpressionURL : String;
		public var _adTagVASTDuration : Number;
		public var _adTagClickThrough : String;

		public var _impressionArray : Array;
		public var _errorArray : Array;
		public var _clickThruArray : Array;
		public var _trackingArray : Array;
		public var _mediafileArray : Array;
		public var _companionArray : Array;
		public var _nonlinearArray : Array;
		
		public var _trkStartEvent:Array;
		public var _trkMidPointEvent:Array;
		public var _trkFirstQuartileEvent:Array;
		public var _trkThirdQuartileEvent:Array;
		public var _trkCompleteEvent:Array;
		public var _trkMuteEvent:Array;
		public var _trkPauseEvent:Array;
		public var _trkReplayEvent:Array;
		public var _trkFullScreenEvent:Array;
		public var _trkStopEvent:Array;
		public var _trkClickThru:Array;
		
		// Wrapper
		public var _adTagWrapperImpression : String;
		public var _adTagWrapperTrackingEvent : Object;
		public var _adTagWrapperError : String;
		
		public var _errorWrapperArray : Array;
		public var _impressionWrapperArray : Array;
		public var _clickThruWrapperArray : Array;
		
		public var _trackingStartWrapperArray : Array;
		public var _trackingMidPointWrapperArray : Array;
		public var _trackingFirstQuartileWrapperArray : Array;
		public var _trackingThirdQuartileWrapperArray : Array;
		public var _trackingCompleteWrapperArray : Array;
		public var _trackingMuteWrapperArray : Array;
		public var _trackingPauseWrapperArray : Array;
		public var _trackingReplayWrapperArray : Array;
		public var _trackingFullScreenWrapperArray : Array;
		public var _trackingStopWrapperArray : Array;

		public var _vastVars : Object;
		public var _isVASTXML : Boolean = false;
		public var _isVASTXMLWRAPPER : Boolean = false;

		public function VASTParser() {
			super();
			tagType = "VAST";
		
			_adTagID = "";
			_adTagWrapperSystem = "";
			_VASTAdTagURL = "";
			_adTagWrapperImpression = "";
			_adTagWrapperTrackingEvent = new Object();
			_adTagWrapperError = "";
			_adTagSystem = "";
			_adTagTitle = "";
			_adTagImpressionURL = "";
			_adTagVASTDuration = 0;
			_adTagClickThrough = "";
		
			_impressionArray = new Array();
			_trackingArray = new Array();
			_clickThruArray = new Array();
			_mediafileArray = new Array();
			_companionArray = new Array();
			_nonlinearArray = new Array();
			_errorArray = new Array();
			
			_trkStartEvent = new Array();
			_trkMidPointEvent = new Array();
			_trkFirstQuartileEvent = new Array();
			_trkThirdQuartileEvent = new Array();
			_trkCompleteEvent = new Array();
			_trkMuteEvent = new Array(); 
			_trkPauseEvent = new Array();
			_trkReplayEvent = new Array();
			_trkFullScreenEvent = new Array();
			_trkStopEvent = new Array();
			_trkClickThru = new Array();
			
			_errorWrapperArray = new Array();
			_impressionWrapperArray = new Array();
			_clickThruWrapperArray = new Array();
			
			_trackingStartWrapperArray = new Array();
			_trackingMidPointWrapperArray = new Array();
			_trackingFirstQuartileWrapperArray = new Array();
			_trackingThirdQuartileWrapperArray = new Array();
			_trackingCompleteWrapperArray = new Array();
			_trackingMuteWrapperArray = new Array();
			_trackingPauseWrapperArray = new Array();
			_trackingReplayWrapperArray = new Array();
			_trackingFullScreenWrapperArray = new Array();
			_trackingStopWrapperArray = new Array();
		
			_vastVars = new Object();
		}
		
		//performs a check to see if the xml passed to it is VAST
		public override function checkFormat(data:XML):Boolean
		{
			UIFDebugMessage.getInstance()._debugMessage(3, "In checkFormat() ", "VAST", "VASTParser");
			
			if(String(data.name()) == "VideoAdServingTemplate")
			{
				
				return true;
			}
			else
			{ 
				return false;
			}
		}
		
		//stores vast tags in the _vastVars object
		protected function createVASTvars() : void {
			
			UIFDebugMessage.getInstance()._debugMessage(3, "In createVASTvars() ", "VAST", "VASTParser");
			
			if(!_isVASTXML && !_isVASTXMLWRAPPER) {
				dispatchError(4);
				return;
			}
			_vastVars["adTagID"] = adTagID;
			_vastVars["adTagWrapperSystem"] = adTagWrapperSystem;
			_vastVars["VASTAdTagURL"] = VASTAdTagURL;
			_vastVars["adTagWrapperImpression"] = adTagWrapperImpression;
			_vastVars["adTagWrapperTrackingEvent"] = adTagWrapperTrackingEvent;
			_vastVars["adTagWrapperError"] = adTagWrapperError;
			_vastVars["adTagSystem"] = adTagSystem;
			_vastVars["adTagTitle"] = adTagTitle;
			_vastVars["adTagImpressionURL"] = adTagImpressionURL;
			_vastVars["impressionArray"] = impressionArray;
			_vastVars["trackingArray"] = trackingArray;
			_vastVars["errorArray"] = errorArray;
			_vastVars["adTagVASTDuration"] = adTagVASTDuration;
			_vastVars["adTagClickThrough"] = adTagClickThrough;
			_vastVars["mediafileArray"] = mediafileArray;
			_vastVars["companionArray"] = companionArray;
			_vastVars["nonlinearArray"] = nonlinearArray;
		
			var output : String = "VAST Variables:: ";
			for(var variableName in _vastVars) {
				output += variableName + ": " + _vastVars[variableName] + "\n";
			}
			//_sendToPanel(output);
			//trace(output);
			//trace("\n\n");

			dispatchEvent(new ParserEvent(ParserEvent.XML_PARSED, _vastVars));
		}

		protected override function parseXMLData() : void {
			//Parse Data Here: _adTagXML:XMLDocument is the XML Data
			
			UIFDebugMessage.getInstance()._debugMessage(3, "In parseXMLData() ", "VAST", "VASTParser");
			
			var i:Number = 0;
			var j:Number = 0;
			var Impression:Object;
			if(mainXML.Ad.Wrapper.AdSystem != undefined) {
				_isVASTXMLWRAPPER = true;
				dispatchEvent(new Event(VASTParser.TOGGLE_VAST_WRAPPER_CALLED));
				
				adTagWrapperSystem = mainXML.Ad.Wrapper.AdSystem;
				

				if(mainXML.Ad.Wrapper.VASTAdTagURL.URL != undefined) {
					VASTAdTagURL = mainXML.Ad.Wrapper.VASTAdTagURL.URL;
				}

				for(i = 0; i < mainXML.Ad.Wrapper.Impression.URL.length(); i++)
				{
					Impression = new Object();
					if (mainXML.Ad.Wrapper.Impression.URL[i] != undefined) {
						Impression.url = mainXML.Ad.Wrapper.Impression.URL[i];
					}
					_impressionWrapperArray.push(Impression);
				}

				for(i = 0; i < mainXML.Ad.Wrapper.Error.URL.length(); i++)
				{
					var ErrorWrapperNode : Object = new Object();
					if (mainXML.Ad.Wrapper.Error.URL[i] != undefined) {
						ErrorWrapperNode.url = mainXML.Ad.Wrapper.Error.URL[i];
					}
					_errorWrapperArray.push(ErrorWrapperNode);
				}


				for(i = 0; i < mainXML.Ad.Wrapper.TrackingEvents.Tracking.length(); i++) 
				{
					var TrackingWrapper : Object = new Object();
					
					if(mainXML.Ad.Wrapper.TrackingEvents.Tracking[i] != undefined) {
						TrackingWrapper.event = mainXML.Ad.Wrapper.TrackingEvents.Tracking[i].@event;
					}
					
					var trackWrapperURL : Array = new Array();
					
					for(j = 0; j < mainXML.Ad.Wrapper.TrackingEvents.Tracking[i].URL.length(); j++)
					{
						
						if (mainXML.Ad.Wrapper.TrackingEvents.Tracking[i].URL[j] != undefined) {
							trackWrapperURL.push( mainXML.Ad.Wrapper.TrackingEvents.Tracking[i].URL[j]);
							TrackingWrapper.url = trackWrapperURL[j];
					
							switch(String(TrackingWrapper.event))
							{	
								
								case "start":
								_trackingStartWrapperArray.push(TrackingWrapper);
								break;
								
								case "midpoint":
								_trackingMidPointWrapperArray.push(TrackingWrapper);
								break;
								
								case "firstQuartile":
								_trackingFirstQuartileWrapperArray.push(TrackingWrapper);
								break;
								
								case "thirdQuartile":
								_trackingThirdQuartileWrapperArray.push(TrackingWrapper);
								break;
								
								case "complete":
								_trackingCompleteWrapperArray.push(TrackingWrapper);
								break
								
								case "mute":
								_trackingMuteWrapperArray.push(TrackingWrapper);
								break;
								
								case "pause":
								_trackingPauseWrapperArray.push(TrackingWrapper);
								break;
								
								case "replay":
								_trackingReplayWrapperArray.push(TrackingWrapper);
								break;
								
								case "fullscreen":
								_trackingFullScreenWrapperArray.push(TrackingWrapper);
								break;
								
								case "stop":
								_trackingStopWrapperArray.push(TrackingWrapper);
								break;
								
								default:
								break;
							}
						}
					}
				}
					
				//Get the wrapper's clickthru tracking URLS
				for(var index:int = 0; index < mainXML.Ad.Wrapper.VideoClicks.ClickTracking.URL.length(); index ++)
				{
					var ClickThru : Object = new Object();
					if (mainXML.Ad.Wrapper.VideoClicks.ClickTracking.URL[index] != undefined) {
						ClickThru.url = mainXML.Ad.Wrapper.VideoClicks.ClickTracking.URL[index];
					}
					_clickThruWrapperArray.push(ClickThru);	
				}

			} else {
				
				if(mainXML.Ad != undefined) {
					adTagID = mainXML.Ad.@id;
				}
				isVASTXML = true;
				_isVASTXMLWRAPPER = false;
				
				adTagSystem = mainXML.Ad.InLine.AdSystem;
				
				adTagTitle = mainXML.Ad.InLine.AdTitle;
				
				for(i = 0; i < mainXML.Ad.InLine.Impression.URL.length(); i++)
				{
					Impression = new Object();
					if (mainXML.Ad.InLine.Impression.URL[i] != undefined) {
						Impression.url = mainXML.Ad.InLine.Impression.URL[i];
					}
					_impressionArray.push(Impression);
				}
				
				for(i = 0; i < mainXML.Ad.InLine.Error.URL.length(); i++)
				{
					var ErrorNode : Object = new Object();
					if (mainXML.Ad.InLine.Error.URL[i] != undefined) {
						ErrorNode.url = mainXML.Ad.InLine.Error.URL[i];
					}
					_errorArray.push(ErrorNode);
				}
				
						
				for (i = 0; i < mainXML.Ad.InLine.TrackingEvents.Tracking.length(); i++) 
				{
					
					var trackURL : Array = new Array();
					for(j = 0; j < mainXML.Ad.InLine.TrackingEvents.Tracking[i].URL.length(); j++)
					{
						
						if (mainXML.Ad.InLine.TrackingEvents.Tracking[i].URL[j] != undefined) {
							
							var Tracking : Object = new Object();
							
							if(mainXML.Ad.InLine.TrackingEvents.Tracking[i] != undefined) {
								Tracking.event = mainXML.Ad.InLine.TrackingEvents.Tracking[i].@event;
							}
							
							trackURL.push( mainXML.Ad.InLine.TrackingEvents.Tracking[i].URL[j]);
							Tracking.url = trackURL[j];
							
							switch(String(Tracking.event))
							{	
						
								case "start":
								_trkStartEvent.push(Tracking);
								break;
								
								case "midpoint":
								_trkMidPointEvent.push(Tracking);
								break;
								
								case "firstQuartile":
								_trkFirstQuartileEvent.push(Tracking);
								break;
								
								case "thirdQuartile":
								_trkThirdQuartileEvent.push(Tracking);
								break;
								
								case "complete":
								_trkCompleteEvent.push(Tracking);
								break
								
								case "mute":
								_trkMuteEvent.push(Tracking);
								break;
								
								case "pause":
								_trkPauseEvent.push(Tracking);
								break;
								
								case "replay":
								_trkReplayEvent.push(Tracking);
								break;
								
								case "fullscreen":
								_trkFullScreenEvent.push(Tracking);
								break;
								
								case "stop":
								_trkStopEvent.push(Tracking);
								break;
								
								default:
								break;
							}
						}
					}
					_trackingArray.push(Tracking);
				}

				if(mainXML.Ad.InLine.Video.Duration != undefined) {
					var durationArray : Array = mainXML.Ad.InLine.Video.Duration.text().split(":");
					adTagVASTDuration = (durationArray[0] * 3600) + (durationArray[1] * 60) + (durationArray[2] * 1000);
				}
				
				if(mainXML.Ad.InLine.Video.VideoClicks != undefined) {
					if(mainXML.Ad.InLine.Video.VideoClicks.ClickThrough != undefined) 
					{
						if(mainXML.Ad.InLine.Video.VideoClicks.ClickThrough.URL != undefined) 
						{
							adTagClickThrough = mainXML.Ad.InLine.Video.VideoClicks.ClickThrough.URL;
						}
					}
					//Get the clickthru tracking URLS
					for(i = 0; i < mainXML.Ad.InLine.Video.VideoClicks.ClickTracking.URL.length(); i ++)
					{
						Impression = new Object();
						if (mainXML.Ad.InLine.Video.VideoClicks.ClickTracking.URL[i] != undefined) {
							Impression.url = mainXML.Ad.InLine.Video.VideoClicks.ClickTracking.URL[i];
						}
						_clickThruArray.push(Impression);	
					}
				}
				
				if(mainXML.Ad.InLine.Video.MediaFiles != undefined) {
					for(i = 0; i < mainXML.Ad.InLine.Video.MediaFiles.MediaFile.length(); i++) {
						
						if (mainXML.Ad.InLine.Video.MediaFiles.MediaFile[i] != undefined) {
							if (mainXML.Ad.InLine.Video.MediaFiles.MediaFile[i].URL != undefined) {
								var tempArray : Array = mainXML.Ad.InLine.Video.MediaFiles.MediaFile[i].URL.text().split(".");
								
								var Mediafile : Object = new Object();
								Mediafile.url = mainXML.Ad.InLine.Video.MediaFiles.MediaFile[i].URL.text();
								Mediafile.delivery = mainXML.Ad.InLine.Video.MediaFiles.MediaFile[i].@delivery;
								Mediafile.bitrate = mainXML.Ad.InLine.Video.MediaFiles.MediaFile[i].@bitrate;
								Mediafile.type = mainXML.Ad.InLine.Video.MediaFiles.MediaFile[i].@type;
								Mediafile.width = mainXML.Ad.InLine.Video.MediaFiles.MediaFile[i].@width;
								Mediafile.height = mainXML.Ad.InLine.Video.MediaFiles.MediaFile[i].@height;
									
								_mediafileArray.push(Mediafile);
							}
						}
					}
				}
					
				for(i = 0; i < mainXML.Ad.InLine.CompanionAds.Companion.length(); i++) {
					if(mainXML.Ad.InLine.CompanionAds.Companion[i] != undefined) {
						var companion : Object = new Object();
						companion.width = mainXML.Ad.InLine.CompanionAds.Companion[i].@width;
						companion.height = mainXML.Ad.InLine.CompanionAds.Companion[i].@height;
						companion.resourceType = mainXML.Ad.InLine.CompanionAds.Companion[i].@resourceType;
								
						_companionArray.push(companion);
					}
				}
						
				for(i = 0; i < mainXML.Ad.InLine.NonLinearAds.NonLinear.length(); i++) {
					if(mainXML.Ad.InLine.NonLinearAds.NonLinear[i] != undefined) {
						var nonlinear : Object = new Object();
						nonlinear.width = mainXML.Ad.InLine.NonLinearAds.NonLinear[i].@width;
						nonlinear.height = mainXML.Ad.InLine.NonLinearAds.NonLinear[i].@height;
						nonlinear.resourceType = mainXML.Ad.InLine.NonLinearAds.NonLinear[i].@resourceType;
								
						_nonlinearArray.push(nonlinear);
					}
				}
			}
			
			createVASTvars();
		}

		//VAST Getters/Setters

		public function get isVASTXML() : Boolean {
			return _isVASTXML;
		}

		public function set isVASTXML(value : Boolean) : void {
			_isVASTXML = value;
		}

		public function get isVASTXMLWRAPPER() : Boolean {
			return _isVASTXMLWRAPPER;
		}

		public function set isVASTXMLWRAPPER(value : Boolean) : void {
			_isVASTXMLWRAPPER = value;
		}

		public function get adTagID() : String {
			return _adTagID;
		}

		public function set adTagID(tagID : String) : void {
			_adTagID = tagID;
		}

		public function get adTagWrapperSystem() : String {
			return _adTagWrapperSystem;
		}

		public function set adTagWrapperSystem(system : String) : void {
			_adTagWrapperSystem = system;
		}

		public function get VASTAdTagURL() : String {
			return _VASTAdTagURL;
		}

		public function set VASTAdTagURL(VASTurl : String) : void {
			_VASTAdTagURL = VASTurl;
		}

		public function get adTagWrapperError() : String {
			return _adTagWrapperError;
		}

		public function set adTagWrapperError(wrapperError : String) : void {
			_adTagWrapperError = wrapperError;
		}

		public function get adTagWrapperImpression() : String {
			return _adTagWrapperImpression;
		}

		public function set adTagWrapperImpression(wrapperImpression : String) : void {
			_adTagWrapperImpression = wrapperImpression;
		}

		public function get adTagWrapperTrackingEvent() : Object {
			return _adTagWrapperTrackingEvent;
		}

		public function set adTagWrapperTrackingEvent(wrapperTracking : Object) : void {
			_adTagWrapperTrackingEvent = wrapperTracking;
		}

		public function get adTagSystem() : String {
			return _adTagSystem;
		}

		public function set adTagSystem(adSystem : String) : void {
			_adTagSystem = adSystem;
		}

		public function get adTagTitle() : String {
			return _adTagTitle;
		}

		public function set adTagTitle(tagTitle : String) : void {
			_adTagTitle = tagTitle;
		}

		public function get adTagImpressionURL() : String {
			return _adTagImpressionURL;
		}

		public function set adTagImpressionURL(ImpressionURL : String) : void {
			_adTagImpressionURL = ImpressionURL;
		}

		public function get impressionArray() : Array
		{
			return _impressionArray;
		}

		public function get impressionWrapperArray() : Array
		{
			return _impressionWrapperArray;
		}
		
		public function get clickThruArray() : Array
		{
			return _clickThruArray;
		}
			
		public function get clickThruWrapperArray() : Array
		{
			return _clickThruWrapperArray;
		}

		public function get errorArray() : Array
		{
			return _errorArray;
		}

		public function get errorWrapperArray() : Array
		{
			return _errorWrapperArray;
		}

		public function get trackingArray() : Array {
			return _trackingArray;
		}

		public function get adTagVASTDuration() : Number {
			return _adTagVASTDuration;
		}

		public function set adTagVASTDuration(duration : Number) : void {
			_adTagVASTDuration = duration;
		}

		public function get adTagClickThrough() : String {
			return _adTagClickThrough;
		}

		public function set adTagClickThrough(clickthru : String) : void {
			_adTagClickThrough = clickthru;
		}

		public function get mediafileArray() : Array {
			return _mediafileArray;
		}
		
		public function get trkStartEvent() : Array {
			return _trkStartEvent;
		}
		
		public function get trkMidPointEvent() : Array {
			return _trkMidPointEvent;
		}

		public function get trkFirstQuartileEvent() : Array {
			return _trkFirstQuartileEvent;
		}
		
		public function get trkThirdQuartileEvent() : Array {
			return _trkThirdQuartileEvent;
		}
		
		public function get trkCompleteEvent() : Array {
			return _trkCompleteEvent;
		}
		
		public function get trkMuteEvent() : Array {
			return _trkMuteEvent;
		}
		
		public function get trkPauseEvent() : Array {
			return _trkPauseEvent;
		}
		
		public function get trkReplayEvent() : Array {
			return _trkReplayEvent;
		}
		
		public function get trkFullScreenEvent() : Array {
			return _trkFullScreenEvent;
		}
		
		public function get trkStopEvent() : Array {
			return _trkStopEvent;
		}

		public function get trackingStartWrapperArray() : Array {
			return _trackingStartWrapperArray;
		}
		
		public function get trackingMidPointWrapperArray() : Array {
			return _trackingMidPointWrapperArray;
		}
		
		public function get trackingFirstQuartileWrapperArray() : Array {
			return _trackingFirstQuartileWrapperArray;
		}
		
		public function get trackingThirdQuartileWrapperArray() : Array {
			return _trackingThirdQuartileWrapperArray;
		}
		
		public function get trackingCompleteWrapperArray() : Array {
			return _trackingCompleteWrapperArray;
		}
		
		public function get trackingMuteWrapperArray() : Array {
			return _trackingMuteWrapperArray;
		}
		
		public function get trackingPauseWrapperArray() : Array {
			return _trackingPauseWrapperArray;
		}
		
		public function get trackingReplayWrapperArray() : Array {
			return _trackingReplayWrapperArray;
		}
		
		public function get trackingFullScreenWrapperArray() : Array {return _trackingFullScreenWrapperArray;}
			
		public function get trackingStopWrapperArray() : Array {return _trackingStopWrapperArray;}
		
		public function get companionArray() : Array {return _companionArray;}
			
		public function get nonlinearArray() : Array {return _nonlinearArray;}
		
		public function get trkClickThru(): Array {return _trkClickThru;}
			
		
	}

/* End package */
}