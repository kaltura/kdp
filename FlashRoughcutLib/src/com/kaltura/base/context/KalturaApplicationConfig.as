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
package com.kaltura.base.context
{
	public class KalturaApplicationConfig
	{
		//============== debug =================
		//urls:
		/**
		 *internal
		 */
		public var debugFromIDE:Boolean = false;
		/**
		 *deprecated
		 */
		public var XMLsource:String;

		//default values:
		/**
		 *deprecated
		 */
		public var defaultKshowID:String = '-1';
		/**
		 *deprecated
		 */
		public var defaultEntryID:String = '-1';

		//url paths:
		public var serverURL:String;
		public var partnerServicesUrl:String = "/index.php/partnerservices2";
		public var keditorServicesUrl:String = "index.php/keditorservices";
		public var pluginsFolder:String = "/flash/mixplugins/v1.0";
		public var transitionsFolder:String = "transitions";
		public var overlaysFolder:String = "overlays";
		public var effectsFolder:String = "effects";

		//Extra application information:
		public var logoAssetURL:String = "kalturaLogo.png";					//the application logo.
		public var checkEntriesStatusDelay:uint = 30000;
	}
}