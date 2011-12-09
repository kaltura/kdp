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

package com.kaltura.model
{

	import com.adobe.cairngorm.model.IModelLocator;
	import com.kaltura.KalturaClient;
	import com.kaltura.base.context.KalturaApplicationConfig;
	import com.kaltura.base.context.PartnerInfo;
	import com.kaltura.dataStructures.HashMap;
	
	import mx.collections.ArrayCollection;

	/**
	 *a singleton manager for managing the kaltura application model.
	 */
	//[Bindable]
	public class KalturaModelLocator implements IModelLocator
	{
		static private var modelLocator : KalturaModelLocator;

		//-----------------------------------------------------------
		/**
		*log the commands
		*/
		private var _logStatus:String = '-> Model instantiated, waiting for configuration load...';

		public function get logStatus ():String
		{
			return _logStatus;
		}
		public function set logStatus (msg:String):void
		{
			_logStatus += '\n-> ' + msg;
		}

		//-----------------------------------------------------------
		public static function getInstance():KalturaModelLocator
		{
			if ( modelLocator == null )
				modelLocator = new KalturaModelLocator();

			return modelLocator;
		}

		//-----------------------------------------------------------
		public function KalturaModelLocator():void
		{
			if ( modelLocator != null )
				throw new Error( 'Only one ModelLocator instance should be instantiated' );
		}

		// MODELS ===================================================
		/**
		 *the kaltura client reference, this client is responsible for the callbacks to the kaltura server.
		 */
		public var kalturaClient : KalturaClient;
		/**
		*the application config.xml data, this holds information specific to the server to access, partner etc.
		*/
		public var applicationConfig:KalturaApplicationConfig = new KalturaApplicationConfig ();
		/**
		*the partner information of this kaltura application.
		*/
		public var partnerInfo:PartnerInfo = null;
		/**
		*hashMap to manage entries (Roughcuts).
		*/
		public var roughcutsMap:HashMap = new HashMap ();
		/**
		*entries map to manage roughcut entries.
		*/
		public var entriesMap:HashMap = new HashMap ();
		/**
		 *assets map to manage assets between roughcuts and across the application.
		 */
		public var assetsMap:HashMap = new HashMap ();
		/**
		* list of available transitions and their thumbnail urls, this should be instantiated with data from the server.
		*/
		public var transitions:ArrayCollection = new ArrayCollection ();
		/**
		* list of available overlays and their thumbnail urls, this should be instantiated with data from the server.
		*/
		public var overlays:ArrayCollection = new ArrayCollection ();
		/**
		* list of available text overlays and their thumbnail urls, this should be instantiated with data from the server.
		*/
		public var textOverlays:ArrayCollection = new ArrayCollection ();
		/**
		* list of available effects and their thumbnail urls, this should be instantiated with data from the server.
		*/
		public var effects:ArrayCollection = new ArrayCollection ();
	}
}