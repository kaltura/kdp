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
	import flash.text.Font;
	import flash.system.LoaderContext;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;

	[Event(name="complete", type="plugin.utils.fonts.FontManagerEvent")]
	[Event(name="ioError", type="flash.events.IOErrorEvent")]
	public class FontManager extends EventDispatcher
	{
		public const REFLECTION:String	= "FontManager";
		private static var instance:FontManager = new FontManager();
		//the default font url to load when a font loading fails
		private var _sDefaultFontUrl:String;
		/**
		* Indicates if the default font loading failed.
		* This flasg is important to avoid an infinite loading requests
		*/
		private var _bDefaultFontLoadError:Boolean = false;

		private var _oFontTable:Object = new Object();
		/**
		 * Singleton enforcer function that returns the only instance of this class
		 * @return
		 *
		 */
		public static function getInstance():FontManager
		{
			return instance;
		}
		public function FontManager():void
		{
			//singleton check
			if( instance ) throw new Error( "FontManager can only be accessed through FontManager.getInstance()" );
		}

		public function loadFont(sUrl:String):void
		{
			var fontLoader:FontLoader = _oFontTable[sUrl] as FontLoader;
			if (!fontLoader)
			{
				fontLoader = new FontLoader(sUrl);
				fontLoader.addEventListener(FontManagerEvent.COMPLETE, fontCompleteHandler);
				fontLoader.addEventListener(IOErrorEvent.IO_ERROR, fontIOErrorHandler);
				fontLoader.addEventListener(FontLoaderErrorEvent.INVALID_FONT, invalidFontErrorHandler);
				_oFontTable[sUrl] = fontLoader;
			}

			fontLoader.requestFont();
		}

		/* private function removeFontLoaderListeners(event:Event):void
		{
				var fontLoader:FontLoader = event.target as FontLoader;
				fontLoader.removeEventListener(FontManagerEvent.COMPLETE, fontCompleteHandler);
				fontLoader.removeEventListener(IOErrorEvent.IO_ERROR, fontIOErrorHandler);
				fontLoader.removeEventListener(FontLoaderErrorEvent.INVALID_FONT, invalidFontErrorHandler);
		} */
		private function fontCompleteHandler(evtComplete:FontManagerEvent):void
		{
			dispatchEvent(evtComplete);
		}

		/**
		 * Font loading error handler function. Makes the font loading "fail safe":
		 * If font loading fails, it will load a default font
		 * @param evtError
		 *
		 */
		private function fontIOErrorHandler(evtError:IOErrorEvent):void
		{
			var sLoaderUrl:String = (evtError.target as FontLoader).url;
			if (sLoaderUrl == _sDefaultFontUrl)
			{
				_bDefaultFontLoadError = true;
			}
			if (_sDefaultFontUrl && !_bDefaultFontLoadError){
				loadFont(_sDefaultFontUrl);
			} else {
				trace (REFLECTION, "Font loading failed. font url: " + sLoaderUrl); //throw evtError;//
			}

		}
		/**
		 * Handles invalid fonts error, mostly swf which dowsn't implement IFontModule properietly
		 * @param evtFontInvalidError
		 *
		 */
		private function invalidFontErrorHandler(evtFontInvalidError:FontLoaderErrorEvent):void
		{
			if (evtFontInvalidError.url == _sDefaultFontUrl)
			{
				_bDefaultFontLoadError = true;
			}
			if (_sDefaultFontUrl && !_bDefaultFontLoadError){
				loadFont(_sDefaultFontUrl);
			}
		}

		/**
		 * The default font url to load when a font load fails
		 * @param defaultUrl
		 *
		 */
		public function set defaultFontUrl(defaultUrl:String):void
		{
			_sDefaultFontUrl = defaultUrl;
		}

	}
}