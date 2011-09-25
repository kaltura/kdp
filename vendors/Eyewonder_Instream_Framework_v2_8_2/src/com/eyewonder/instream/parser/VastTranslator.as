/*
VASTTranslator.as

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

Deserializes the parser variables for the VAST modules.

*/
package com.eyewonder.instream.parser
{
	import com.eyewonder.instream.debugger.*;
	
	import flash.display.Sprite;
	import flash.events.*;
	
	public dynamic class VastTranslator extends Sprite
	{
		public static const TRANSLATOR_READY:String = "translatorReady";
		
		
		public var _adTagID:String;
		public var _adTagWrapperSystem:String;
		public var _VASTAdTagURL:String;
		public var _adTagWrapperImpression:String;
		public var _adTagWrapperError:String;
		public var _adTagWrapperTrackingEvent:Object;
		public var _adTagSystem:String;
		public var _adTagTitle:String;
		public var _adTagImpressionURL:String;
		public var _adTagVASTDuration:Number;
		public var _clickThruUrl:String;
		
		public var _trackingArray:Array;
		public var _adTagTrackingEvent:Array;
		
		public var _impressionArray : Array;
		public var _errorArray : Array;
		public var _clickThruArray : Array;
		public var _mediafileArray:Array;
		public var _companionArray:Array;
		public var _nonlinearArray:Array;
		
		public var _impressionWrapperArray : Array;
		public var _errorWrapperArray : Array;
		public var _clickThruWrapperArray : Array;
		
		public var _trackingStartWrapperArray:Array;
		public var _trackingMidPointWrapperArray:Array ;
		public var _trackingFirstQuartileWrapperArray:Array ;
		public var _trackingThirdQuartileWrapperArray:Array ;
		public var _trackingCompleteWrapperArray:Array ;
		public var _trackingMuteWrapperArray:Array ;
		public var _trackingPauseWrapperArray:Array ;
		public var _trackingReplayWrapperArray:Array;
		public var _trackingFullScreenWrapperArray:Array ;
		public var _trackingStopWrapperArray:Array ;	
		
		public var _vastObj:VASTParser;
		public var _vastVars:Object;
		
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
		public var _trkClickThruEvent:Array;
		
		
		public function VastTranslator(parser:VASTParser):void
		{
			_vastObj = parser;
			deserializeVastVars();
			
		}
		
		public function deserializeVastVars():void
		{
			
			UIFDebugMessage.getInstance()._debugMessage(3, "In deserializeVastVars() ", "VAST", "VASTTranslator");
			
			
			_adTagWrapperSystem = String(_vastObj.adTagWrapperSystem);
			_VASTAdTagURL = String(_vastObj.VASTAdTagURL);
			_adTagWrapperImpression = String(_vastObj.adTagWrapperImpression );
			
			_adTagID = String(_vastObj.adTagID);
			_adTagSystem = String(_vastObj.adTagSystem);
			_adTagTitle = String(_vastObj.adTagTitle);
			_adTagVASTDuration = Number(_vastObj.adTagVASTDuration);
			
			_clickThruUrl = String(_vastObj.adTagClickThrough);
			
			_impressionArray = _vastObj.impressionArray;
			_errorArray = _vastObj.errorArray;
			_clickThruArray = _vastObj.clickThruArray;
			_trackingArray = _vastObj.trackingArray;
			_mediafileArray = _vastObj.mediafileArray;
			_companionArray = _vastObj.companionArray;
			_nonlinearArray = _vastObj.nonlinearArray;
			
			_trkStartEvent = _vastObj.trkStartEvent;
			_trkMidPointEvent = _vastObj.trkMidPointEvent;
			_trkFirstQuartileEvent = _vastObj.trkFirstQuartileEvent;
			_trkThirdQuartileEvent = _vastObj.trkThirdQuartileEvent;
			_trkCompleteEvent = _vastObj.trkCompleteEvent;
			_trkMuteEvent = _vastObj.trkMuteEvent;
			_trkPauseEvent = _vastObj.trkPauseEvent;
			_trkReplayEvent = _vastObj.trkReplayEvent;
			_trkFullScreenEvent = _vastObj.trkFullScreenEvent;
			_trkStopEvent = _vastObj.trkStopEvent;
			_trkClickThruEvent = _vastObj.trkClickThru;
			
			_impressionWrapperArray = _vastObj.impressionWrapperArray;
			_errorWrapperArray = _vastObj.errorWrapperArray;
			_clickThruWrapperArray = _vastObj.clickThruWrapperArray;
			
			_trackingStartWrapperArray = _vastObj.trackingStartWrapperArray;
			_trackingMidPointWrapperArray = _vastObj.trackingMidPointWrapperArray;
			_trackingFirstQuartileWrapperArray = _vastObj.trackingFirstQuartileWrapperArray;
			_trackingThirdQuartileWrapperArray = _vastObj.trackingThirdQuartileWrapperArray;
			_trackingCompleteWrapperArray = _vastObj.trackingCompleteWrapperArray;
			_trackingMuteWrapperArray = _vastObj.trackingMuteWrapperArray;
			_trackingPauseWrapperArray = _vastObj.trackingPauseWrapperArray;
			_trackingReplayWrapperArray = _vastObj.trackingReplayWrapperArray;
			_trackingFullScreenWrapperArray = _vastObj.trackingFullScreenWrapperArray;
			_trackingStopWrapperArray = _vastObj.trackingStopWrapperArray;	
			
		}
		
		//VAST Getters/Setters
		public function get adTagID() : String
		{
			return _adTagID;
		}
		
		public function get adTagWrapperSystem() : String
		{
			return _adTagWrapperSystem;
		}
		
		public function get VASTAdTagURL() : String
		{
			
			return _VASTAdTagURL;
		}
		
		public function get adTagWrapperImpression() : String
		{
			return _adTagWrapperImpression;
		}
		
		
		public function get adTagWrapperTrackingEvent() : Object
		{
			return _adTagWrapperTrackingEvent;
		}
		
		public function get adTagSystem() : String
		{
			return _adTagSystem;
		}
	
		public function get adTagTitle() : String
		{
			return _adTagTitle;
		}
		
		public function get adTagImpressionURL() : String
		{
			return _adTagImpressionURL;
		}
		
		public function get trackingArray() : Array
		{
			return _trackingArray;
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
		
		public function get trackingFullScreenWrapperArray() : Array {
			return _trackingFullScreenWrapperArray;
		}
		
		public function get trackingStopWrapperArray() : Array {
			return _trackingStopWrapperArray;
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
		
		public function get adTagVASTDuration() : Number
		{
			return _adTagVASTDuration;
		}
		
		public function get mediafileArray() : Array
		{
			return _mediafileArray;
		}
	
		public function get companionArray() : Array
		{
			return _companionArray;
		}
	
		public function get nonlinearArray() : Array
		{
			return _nonlinearArray;
		}
		public function get trkStartEvent() : Array
		{
			return _trkStartEvent;
		}
		public function get trkMidPointEvent() : Array
		{
			return _trkMidPointEvent;
		}
		public function get trkFirstQuartileEvent() : Array
		{
			return _trkFirstQuartileEvent;
		}
		public function get trkThirdQuartileEvent() : Array
		{
			return _trkThirdQuartileEvent;
		}
		public function get trkCompleteEvent() : Array
		{
			return _trkCompleteEvent;
		}
		public function get trkMuteEvent() : Array
		{
			return _trkMuteEvent;
		}
		public function get trkPauseEvent() : Array
		{
			return _trkPauseEvent;
		}
		public function get trkReplayEvent() : Array
		{
			return _trkReplayEvent;
		}
		public function get trkFullScreenEvent() : Array
		{
			return _trkFullScreenEvent;
		}
		public function get trkStopEvent() : Array
		{
			return _trkStopEvent;
		}	
	
		public function get clickThruUrl() : String
		{
			return _clickThruUrl;
		}		
			
		public function get trkClickThruEvent() : Array
		{
			return _trkClickThruEvent;
		}
	}
}