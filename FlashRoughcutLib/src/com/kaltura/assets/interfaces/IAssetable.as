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
package com.kaltura.assets.interfaces
{
	import com.kaltura.assets.abstracts.AbstractAsset;
	import com.kaltura.assets.dataStructures.audio.AudioGraph;
	import com.kaltura.net.loaders.interfaces.IMediaSourceLoader;

	import flash.display.Bitmap;

	/**
	 *
	 * An interface to allow using assets of different types on the fly.
	 *
	 */
	public interface IAssetable
	{
		function get entryStatus ():int;
		function get clipedStreamURL ():String;
		function set clipedStreamURL (url:String):void;
		function get clipedStreamLen ():Number;
		function set clipedStreamLen (original_stream_length:Number):void;
		function get clipedStreamStart ():Number;
		function set clipedStreamStart (original_start_time:Number):void;
		function get orderBy():Number;
		function set orderBy(newOrderBy:Number):void;
		function get originalIndex ():uint;
		function set originalIndex (idx:uint):void;
		function get audioGraph ():AudioGraph;
		function set audioGraph (newGraph:AudioGraph):void
		function get transitionAsset ():AbstractAsset;
		function set transitionAsset (asset_transition:AbstractAsset):void;
		function get transitionThumbnail ():String;
		function set transitionThumbnail (transition_thumbnail:String):void;
		function get entryContributor ():String;
		function set entryContributor (cnotributor:String):void;
		function get thumbBitmap ():Bitmap;
		function set thumbBitmap (thumbnail_bitmap:Bitmap):void;
		function get mediaSource():*;
		function set mediaSource (media_source:*):void;
		function get assetUID ():String;
		function set assetUID (asset_uid:String):void;
		function get seqStartPlayTime ():Number;
		function set seqStartPlayTime (sequenceStartTime:Number):void;
		function get seqEndPlayTime ():Number;
		function set seqEndPlayTime (sequenceEndTime:Number):void;
		function get seqTransitionPlayTime ():Number;
		function set seqTransitionPlayTime (seqStartTransition:Number):void;
		function get entryId ():String;
		function set entryId (id:String):void;
		function get entryName ():String;
		function set entryName (eName:String):void;
		function get thumbnailURL ():String;
		function set thumbnailURL (url:String):void;
		function get mediaType ():int;
		function set mediaType (media_type:int):void;
		function get mediaURL ():String;
		function set mediaURL (url:String):void;
		function set transitionLength (transition_length:Number):void;
		function get transitionLength ():Number;
		function set transitionPluginID (transition_type:String):void;
		function get transitionLabel ():String;
		function set transitionLabel (label:String):void;
		function set audioBalance (balance:Number):void;
		function get audioBalance ():Number;
		function set focus (f:Boolean):void;
		function get focus ():Boolean;
		function set selected (is_selected:Boolean):void;
		function get selected ():Boolean;
		function set startTime (stime:Number):void;
		function get startTime ():Number;
		function set length (len:Number):void;
		function get length ():Number;
		function set maxLength (maxLen:Number):void;
		function get maxLength ():Number;
		function get mediaSourceLoader ():IMediaSourceLoader;
		function set mediaSourceLoader (ldr:IMediaSourceLoader):void;
		function get transitionCross ():Boolean;
		function set transitionCross (val:Boolean):void;
		
		function clone ():AbstractAsset;
	}
}