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
package com.kaltura.base.vo
{
	import com.kaltura.base.types.MediaTypes;

	import flash.events.EventDispatcher;

	//[Bindable]
	public class KalturaPluginInfo extends EventDispatcher
	{
		/**
		*the mediaType (Overlay, Effect, Transition).
		*/
		public var mediaType:uint = MediaTypes.ANY_TYPE;
		/**
		*unique identifier for this plugin as it saved on the server.
		*/
		public var pluginId:String = '';
		/**
		*the url of the thumbnail.
		*/
		public var thumbnailUrl:String = '';
		/**
		* the category of this plugin.
		*/
		public var category:String = 'Generic';
		/**
		* the creator of this plugin.
		*/
		public var creator:String = 'Kaltura';
		/**
		* the name that should apear on the view to describe the plugin.
		*/
		public var label:String = '';
		/**
		* a description for this plugin.
		*/
		public var description:String = '';

		/**
		 * Constructor.
		 * @param media_type				the media type of this plugin.
		 * @param plugin_id					the unique id as it is saved on the server.
		 * @param thumbnail_url				the url of the thumbnail of this plugin.
		 * @param plugin_category			the category of this plugin.
		 * @param plugin_label				the label of this plugin (this name should be used in UI).
		 * @param plugin_creator			the name of the plugin creator.
		 * @param plugin_description		the description for this plugin.
		 * @see com.kaltura.common.types.MediaTypes
		 */
		public function KalturaPluginInfo (media_type:uint,
											plugin_id:String,
											thumbnail_url:String,
											plugin_category:String,
											plugin_label:String,
											plugin_creator:String = 'Kaltura',
											plugin_description:String = ''):void
		{
			mediaType = media_type;
			pluginId = plugin_id;
			thumbnailUrl = thumbnail_url;
			category = plugin_category;
			creator = plugin_creator;
			description = plugin_description;
			label = plugin_label;
		}
	}
}