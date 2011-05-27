/*
AdContainerParent.as

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
 Don't rename this class. Instead, extend it if you would like to use a different class name
 See ../InstreamFramework for an example

 */
package com.eyewonder.instream.base
{
import flash.display.Loader;
import flash.display.MovieClip;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.net.URLRequest;
import flash.system.ApplicationDomain;
import flash.system.LoaderContext;

public dynamic class AdContainerParent extends MovieClip {

	public var ew_instreamObject:InstreamFrameworkBase;	/* Deprecated */
	public var ew_instreamEndAd:Function;					/* Deprecated */
	public var uif_instreamObject:InstreamFrameworkBase; 	/* Preferred method */

	public var _adContainer:Loader;
	public var _initListener:Function;			/* init listener (called when methods on child SWF are available) */
	public var _completeListener:Function;		/* complete listener (called when the child SWF starts running) */
	
	public var _isLoaded:Boolean = false;

	public var _adContainerLoaderContext : LoaderContext;
	public function AdContainerParent(base:InstreamFrameworkBase, end:Function )
	{
		base._debugMessage(0,"In AdContainerParent("+typeof(base) + "," + typeof(end) + ")");
		ew_instreamObject = uif_instreamObject = base;
		ew_instreamEndAd = end;
		
		_adContainer = new Loader();
		_isLoaded = false;
	}

	public function unloadClip():void
	{
		if (!_isLoaded)
			return;
		_isLoaded = false;
		_adContainer.unload();
		this.removeChild(_adContainer);
	}
	
	public function loaderInit(event:Event):void
	{	
		dispatchEvent(new Event(Event.INIT));
	}
	
	public function loaderComplete(event:Event):void
	{	
		dispatchEvent(new Event(Event.COMPLETE));
	}
	
	public function loaderError(event:IOErrorEvent):void
	{
		dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR));
	}

	public function loadClip(swfUrl:String):void
	{
		var urlReq:URLRequest = new URLRequest(swfUrl);
		_adContainer.contentLoaderInfo.addEventListener(Event.INIT, loaderInit);
		_adContainer.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderComplete);
		_adContainer.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loaderError);
		this.addChild(_adContainer);
		_adContainer.load( urlReq );
		_isLoaded = true;
	}

}
}