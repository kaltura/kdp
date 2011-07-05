/*
InstreamFramework.as

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
This class is the child of InstreamFrameworkBase.as and serves as a gateway into the major functionality of the Universal Instream Framework.

Example Usage:
	import com.eyewonder.instream.InstreamFramework;
	System.security.allowDomain("*");
	var ewad = new InstreamFramework();
*/
package com.eyewonder.instream 
{
	import flash.geom.Rectangle;	
	
	import com.eyewonder.instream.base.InstreamFrameworkBase;
    import com.eyewonder.instream.cartridge.MyPublisherCartridge; /* replace this with correct cartridge */

    import flash.display.MovieClip;
	
	public class InstreamFramework extends InstreamFrameworkBase 
    {
        /* Define custom member variables here */
        public var _customVarExample : Number;
		
		protected var _state:Number;
		protected var _vol:Number;

        public function InstreamFramework(root_mc : MovieClip)
        {
            super(root_mc);
        }
        
        /* Custom methods */
        public override function customInit() : void /* This is called from the constructor */
        {
            _debugMessage(2, "In customInit().");
            // TODO: Add calls to publisher API and any specialized initiation here. 
            _publisherCartridge = new MyPublisherCartridge();
        }

        public override function endAdNotify() : void
        {
            _debugMessage(2, "In endAdNotify().");
			// TODO: Add calls to publisher API here
        }

		public override function customPublisherTagHandler():void
		{
			_debugMessage(2,"In customPublisherTagHandler().");
			// Convenience references
			var format:String = _adFormat;
			var tagData:XML = _adTagService.adTagData;
					
			// Publisher: Add code here to handle custom data in tags			
					
			return;
		}
	
		public override function handleInteractiveModeStart():void {
			_debugMessage(2, "In handleInteractiveModeStart().");
			// TODO: Publisher should add code here to handle when a linear interactive ad is starting the interactive mode.
			// This method will be called by the creative advertisement.
		}
	
		public override function handleInteractiveModeEnd():void {
			_debugMessage(2, "In handleInteractiveModeEnd().");
			// TODO: Publisher should add code here to handle when a linear interactive ad has finished interactive mode for some reason.
			// This method will be called by the creative advertisement.
		}
		
		public override function handleExpand():void {
			_debugMessage(2, "In handleExpand().");
			// TODO: Publisher should add code in subclass com.eyewonder.instream.InstreamFramework to handle when a linear interactive ad has finished interactive mode for some reason.
			// This method will be called by the creative advertisement.
		}
		
		public override function handleContract():void {
			_debugMessage(2, "In handleContract().");
			// TODO: Publisher should add code in subclass com.eyewonder.instream.InstreamFramework to handle when a linear interactive ad has finished interactive mode for some reason.
			// This method will be called by the creative advertisement.
		}
		
		/* TODO: Publisher can override any additional methods (e.g. timer methods) as needed below */
		/*
		public function registerAdCleanupCallback(callbackFunc : Function) : Void 
		public function getAdMovieClip(x : Number, y : Number, mcWidth : Number, mcHeight : Number) : MovieClip 	
		public function removeAdMovieClip():Void
		public function timerStop() : Void 
		public function timerPause(seconds:Number) : Void 
		public function timerStart(seconds:Number): Void
		public function timerCountdownCompleted(): Void
		public function trackGoInteractive(): Void
		public function trackLeaveInteractive(): Void
		public function trackInteraction: Void
		*/
    }

/* End package */
}
