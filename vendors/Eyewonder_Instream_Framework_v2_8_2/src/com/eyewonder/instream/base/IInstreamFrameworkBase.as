/*
IInstreamFrameworkBase.as

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

EyeWonder instream framework Flash-in-Flash Interface
*/
package com.eyewonder.instream.base
{

import flash.geom.Rectangle;
import flash.display.MovieClip;

	interface IInstreamFrameworkBase  {
	
	// Player Functions
	function customInit():void;
	function setVideoState( state:Number ):void;
	function setAudioState( state:Number ):void;
	function getAudioState():Number;
	function getVideoState():Number;
	function getPlayerInformation() : Object;
	function trackExpand() : void;
	function trackContract() : void;
	function trackLoad() : void;
	function trackClose() : void;
	function trackInteraction() : void;
	function trackClickthru() : void;
	function trackStartOfVideo() : void;
	function trackMidOfVideo() : void;
	function trackEndOfVideo() : void;
	function handleVendorCartridgeInsert() : void
	function registerAdCleanupCallback( callbackFunc:Function ):void;
	function getAdMovieClip( mcPos:Rectangle ):MovieClip;
	function _alignAd(videoPos:Rectangle):Rectangle;
	function timerStop():void;
	function timerStart(seconds:Number):void;
	function timerPause(seconds:Number) : void;
	function timerReset(): void;
	function reportInteraction(): void;	// legacy. Deprecated.
	function handleInteraction(): void;
	function endAdNotify() : void;
	function timerCountdownCompleted() : void;
	function getAPIVersion():String;
	function pubTrace(msg:Object) : void;
	function setDebugLevel(level:Number) : void;
	function resizeNotify():void;
	
	// Ad Functions
	function endAd() : void 
	function loadAdXML( url:String, adSlotType:String ):void;
	
	// EventDispatcher
	function addEventListener( eventName:String, eventHandler:Function ) : void;
	function removeEventListener( eventName:String, eventHandler:Function ) : void;
	function dispatchEvent( eventObject:Object ) : void;
	
	/* Events:
	ewOnStartPlayAd
	ewOnEndAd
	ewOnError
	*/

	
	
}

/* End package */

}