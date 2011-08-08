/*
This file is part of the Kaltura Collaborative Media Suite which allows users
to do with audio, video, and animation what Wiki platfroms allow them to do with
text.

Copyright (C) 2006-2008  Kaltura Inc.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as
published by the Free Software Foundation, either version 3 of the
License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

@ignore
*/
package com.kaltura.plugin.utils.fonts
{
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.Security;
	import flash.system.SecurityDomain;

	[Event(name="complete", type="plugin.utils.fonts.FontManagerEvent")]
	[Event(name="invalidFont", type="plugin.utils.fonts.FontManagerEvent")]
	[Event(name="ioError", type="flash.events.IOErrorEvent")]
	public class FontLoader extends EventDispatcher
	{
		private var _sUrl:String;
		private var _fontModule:IFontModule;
		private var _nRequests:int = 0;

		public function FontLoader(sUrl:String):void
		{
			_sUrl = sUrl;
		}

		public function requestFont():void
		{
			_nRequests++
			if (! _fontModule)
			{
				var ldrFont:Loader = new Loader();
				var request:URLRequest = new URLRequest(_sUrl);
				ldrFont.contentLoaderInfo.addEventListener(Event.COMPLETE, loadCompleteHandler);
				ldrFont.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loadFailedHandler);
				Security.allowDomain("*");
				ldrFont.load(request,new LoaderContext(true,ApplicationDomain.currentDomain, SecurityDomain.currentDomain));
			}
			else
			{
				fontLoaded();
			}

		}

		private function loadCompleteHandler(evtComplete:Event):void
		{
			var info:LoaderInfo = evtComplete.target as LoaderInfo;
			var loadedFont:IFontModule = info.content as IFontModule;
			_fontModule = loadedFont;
			if (_fontModule)
			{
				fontLoaded();
			} else {
				handleInstantiationError();
			}
		}

		/**
		 * Handles an incompatible loaded font files errors.
		 * Those kind of error is caused by an incompatible casting of the loaded swf file to IFontModule
		 *
		 */
		private function handleInstantiationError():void
		{
			dispatchEvent(new FontLoaderErrorEvent(FontLoaderErrorEvent.INVALID_FONT, false, false, _sUrl));
			//loadFailedHandler(null);
		}

		private function loadFailedHandler(evtIoError:IOErrorEvent):void
		{
			dispatchEvent(evtIoError);
		}

		private function fontLoaded():void
		{
			var fontManagerEvent:FontManagerEvent = new FontManagerEvent(Event.COMPLETE, false, false, _fontModule);
			for (_nRequests; _nRequests > 0; _nRequests--)
			{
				dispatchEvent(fontManagerEvent);
			}
		}

		public function get url():String
		{
			return _sUrl;
		}


	}
}