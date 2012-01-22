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
package com.kaltura.roughcut.sdl
{
	import com.kaltura.application.KalturaApplication;
	import com.kaltura.assets.AssetsFactory;
	import com.kaltura.assets.abstracts.AbstractAsset;
	import com.kaltura.assets.assets.PluginAsset;
	import com.kaltura.base.IDisposable;
	import com.kaltura.base.types.MediaTypes;
	import com.kaltura.dataStructures.HashMap;
	import com.kaltura.plugin.logic.effects.KEffect;
	import com.kaltura.plugin.logic.overlays.Overlay;
	import com.kaltura.plugin.types.transitions.TransitionTypes;
	import com.kaltura.roughcut.Roughcut;
	import com.kaltura.roughcut.assets.RoughcutTimelinesAssets;
	import com.kaltura.roughcut.soundtrack.AudioPlayPolicy;
	import com.kaltura.utils.url.URLProccessing;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	import mx.collections.ArrayCollection;

	public class RoughcutSDL implements IDisposable
	{
		/**
		*the sdl of the roughcut as it was served by the server.
		*/
		public var originalSDL:XML;
		/**
		*the sdl as it is reflected by the current state of the roughcut.
		*/
		public var currentSDL:XML;
		/**
		*the associated roughcut entry id.
		*/
		public var roughcutEntryId:String = '-1';
		/**
		 *the entry version of this roughcut.
		 */
		public var roughcutEntryVersion:int = -1;
		/**
		*whether this roughcut's assets are currently being processed by the server, if so this will contain the assets entry ids.
		*/
		protected var showPending:XMLList;
		/**
		*the time stamp at which the roughcut was set to be processed by the server.
		*/
		protected var lastPendingTimeStamp:XMLList;
		/**
		*the url of the roughcut's thumbnail.
		*/
		protected var _thumbnailURL:String = '';
		/**
		 *identification of the editor application.
		 */
		public var editorType:int = 1;
		/**
		 * in case an admin, deleted entries from the system, we mark these entries as deleted.
		 * contains DeletedEntry instances.
		 * @see com.kaltura.base.vo.DeletedEntry
		 */
		public var deletedEntries:ArrayCollection = new ArrayCollection ();

		/**
		 *the url of the roughcut's thumbnail.
		 */
		public function get thumbnailURL ():String
		{
			return _thumbnailURL;
		}

		/**
		 *Constructor.
		 * @param entryId		the entry id of this roughcut.
		 * @param sdl			the sdl of this roughcut.
		 */
		public function RoughcutSDL (entry_id:String, entry_version:int, sdl:XML):void
		{
			originalSDL = sdl;
			roughcutEntryId = entry_id;
			roughcutEntryVersion = entry_version;
		}

		/**
		 *disposes of this object.
		 */
		public function dispose ():void
		{
			originalSDL = null;
			currentSDL = null;
			showPending = null;
			lastPendingTimeStamp = null;
		}

		private const PADDING_TAG_SIZE:Number = 224;
		private const PADDING_TAG_TIME:Number = 0.026;
		private const PADDING_TAGS:Number = 20;

		/**
		 * parse the sdl and builds a roughcutTimelines.
		 * @param all_assets		the associated assets of this roughcut.
		 * @param validate_sdl	true if the sdl should be validate with the getallentries servcie.
		 * @return 				the timelines generated for this roughcut.
		 */
		public function parseAndBuildTimelines (all_assets:HashMap, validate_sdl:Boolean):RoughcutTimelinesAssets
		{
			var sequenceVideoData:Array = [];
			var sequenceAudioData:Array = [];
			var sequenceOverlaysData:Array = [];
			var sequenceEffectsData:Array = [];

			var validAsset:AbstractAsset;																			//varify the asset from the SDL that exist on the
    																												//shows thumbnails list (meaning, the user has access to the assets)
		    var tempAsset:AbstractAsset;																			//temp AbstarctAsset to work with
		    var duration:Number = -1;
			var showsLength:int = originalSDL.length();																//get the duration of the sequence (loaded show)
			var origineType:int;																					//the current asset's type (VIDEO, AUDIO...)

			if (originalSDL.MetaData.hasOwnProperty("Pending"))
			{
				if (originalSDL.MetaData.Pending != "" || originalSDL.MetaData.hasSimpleContent())
				{
					showPending = originalSDL.MetaData.Pending;
				} else {
					showPending = null;
				}
			} else {
				showPending = null;
			}

			if (originalSDL.MetaData.hasOwnProperty("LastPendingTimeStamp"))
			{
				if (originalSDL.MetaData.LastPendingTimeStamp != "" || originalSDL.MetaData.hasSimpleContent())
				{
					lastPendingTimeStamp = originalSDL.MetaData.LastPendingTimeStamp;
				} else {
					lastPendingTimeStamp = null;
				}
			} else {
				lastPendingTimeStamp = null;
			}

			if (originalSDL.MetaData.hasOwnProperty("ThumbUrl"))
				_thumbnailURL = originalSDL.MetaData.ThumbUrl;

			// run over the main timeline assets in the SDL... (Video, Image and Solid)
			var pluginAssetXml:XML;
			var list:XMLList;
			var crossExist:Boolean;
			var solidColor:uint;
			var bd:BitmapData;
			var bmp:Bitmap;
			var colorName:String;
			var transitionId:String;
			var transitionNone:String = (TransitionTypes.NONE).toLowerCase();
			var transitionIdlower:String;
			var transitionThumbnail:String;
			var transitionLength:Number;
			var totalTimestamp:Array = [];
			var tempTimestamp:Number = 0;
			var lastTimeStamp:Number = 0;
			var timestamp:Number = 0;
			var totalByte:Array = [];
			var tempByte:uint = 0;
			var lastByte:uint = 0;
			var currentByte:uint = 0;
			var lastStream:uint = 0;
			var oddEven:uint = 1;
			var print:String;
			var url2Load:String;
			var testColor:Number;
			var transitionAsset:AbstractAsset;
			totalByte[0] = totalByte[1] = 0;
			totalTimestamp[0] = totalTimestamp[1] = 0;
			var maxStaticLength:Number = Roughcut.mediaTypesSettings.defaultMaxStaticTypesDuration > 0 ?
										 Roughcut.mediaTypesSettings.defaultMaxStaticTypesDuration : Number.MAX_VALUE;
			var tempMaxLength:Number;
			var addbytes:Array = [0,0];
			var addTime:Array = [0,0];

			var nullTransitionLabel:String = KalturaApplication.getInstance().getTransitionLabel(TransitionTypes.NONE);

			for each (var p:XML in originalSDL.VideoAssets.vidAsset)
			{
				//for discrete streams method, we need to calculate the position in the relavent stream
				oddEven = 1 - oddEven;
				tempTimestamp = Number(p.StreamInfo.@real_seek_time);
				tempByte = Number(p.StreamInfo.@real_start_byte);
				print = print + "\noddEven: " + oddEven + "\tLastTimeStamp: " + lastTimeStamp.toPrecision(3);
				if (tempTimestamp >= 0)
				{
					//calculate time stamp:
					totalTimestamp[lastStream] += tempTimestamp - lastTimeStamp;
					timestamp = totalTimestamp[oddEven];
					lastTimeStamp = tempTimestamp;
					//calculate Byte stamp:
					totalByte[lastStream] += tempByte - lastByte;
					currentByte = totalByte[oddEven];
					lastByte = tempByte;
					lastStream = oddEven;
					print = print + "\t\t\tVIDEO \t\t\ttempT: " + tempTimestamp.toPrecision(3) + "\t\t\tcTimeStamp: " + timestamp.toPrecision(3) + "\t\t\tTotalArray: " + totalTimestamp;
				} else {
					print = print + "\t\t\tNON_VIDEO \t\t\ttempT: " + tempTimestamp.toPrecision(4) + "\t\t\tcTimeStamp: " + timestamp.toPrecision(4) + "\t\t\tTotalArray: " + totalTimestamp;
				}
				origineType = MediaTypes.translateStringTypeToInt(p.@type);
				switch (origineType)
				{
					// The following actions are similiar for video and image assets:
					case MediaTypes.VIDEO:
					case MediaTypes.IMAGE:
						validAsset = all_assets.getValue(p.@k_id);									//get the original asset to validate with.
				 		//create a base asset to work with:
				 		transitionId = String(p.EndTransition.@type);
				 		transitionIdlower = transitionId.toLowerCase();
				 		transitionThumbnail = KalturaApplication.getInstance().getTransitionThumbnail(transitionId);
				 		transitionLength = (Number(p.StreamInfo.@len_time) - Number(p.EndTransition.@StartTime));
				 		// for historic resons we used thumbnail validation to make sure this transition is still valid
				 		// ie, the partner has authorized the use of this plugin ...
				 		if ((transitionNone == transitionIdlower) || (transitionThumbnail == TransitionTypes.NONE))
				 		{
				 			//if there is no transition, or it's invalid (was deleted or mistyped) set it to None.
				 			transitionId = TransitionTypes.NONE;
				 			transitionLength = 0;
				 		}
				 		tempMaxLength = origineType & (MediaTypes.IMAGE | MediaTypes.SILENCE | MediaTypes.SOLID) ?
					 					maxStaticLength : Number(p.StreamInfo.@len_time);

						if (validAsset != null)
				 		{
				 			tempAsset = validAsset.clone();
				 			tempAsset.assetUID = 'null';
				 			tempAsset.length = Number(p.StreamInfo.@len_time);
				 			if (origineType & (MediaTypes.IMAGE | MediaTypes.SILENCE | MediaTypes.SOLID))
								tempAsset.maxLength = tempMaxLength;
				 			tempAsset.startTime = Number(p.StreamInfo.@start_time);
					 		tempAsset.audioBalance = Number(p.StreamInfo.@pan);
					 		tempAsset.transitionLength = transitionLength;
					 		tempAsset.transitionPluginID = transitionId;
					 		transitionAsset = new PluginAsset(tempAsset.assetUID, tempAsset.entryId, tempAsset.entryName + ".AssetTransition",
								AbstractAsset.noneTransitionThumbnail, "", transitionLength, transitionLength, 0, 0, transitionId, transitionLength);
							transitionAsset.mediaType = MediaTypes.TRANSITION;
							tempAsset.transitionAsset = transitionAsset;
					 	} else {
					 		//entry was deleted.
					 		if (!validate_sdl)
					 		{
					 			// use a template (returned from the server instead of the validAsset):
 								tempAsset = AssetsFactory.create(origineType, 'null', p.@k_id, p.@name, '',
	 								p.@url, Number(p.StreamInfo.@len_time), tempMaxLength, Number(p.StreamInfo.@start_time),
	 								Number(p.StreamInfo.@pan), transitionId, transitionLength);
					 		} else {
					 			// null the asset, so it'll be removed from the roughcut.
					 			tempAsset = null;
					 		}
					 		//xxx deletedEntries.addItem (new DeletedEntry (p.@k_id, p.@name, Number(p.StreamInfo.@len_time), transitionId, transitionLength));
					 	}

					 	if (tempAsset != null)
					 	{
					 		//is this asset's transition is "cross" ?
					 		list = p.EndTransition.@cross;
					 		crossExist = list.length() > 0;
					 		tempAsset.transitionCross = crossExist ? (uint(p.EndTransition.@cross) > 0 ? true : false) : false;
					 		//set the volume graph for this asset
					 		tempAsset.audioGraph.fromXML (p.VolumePoints[0]);
					 		if (p.VolumePoints[0] == null)
					 		{
						 		tempAsset.audioGraph.setOverallVolume(0.5, false);							//if there's no audio graph, reset the graph to half volume
						 	}
					 		sequenceVideoData.push (tempAsset);												//add the asset to the mainTimeline assets array

							//this is where we have differences between video and image
							switch (tempAsset.mediaType)
							{
								case MediaTypes.VIDEO:
									tempAsset.clipedStreamStart = Number(p.StreamInfo.@Clipped_Start);		//save the cut time relative to the original clip
									tempAsset.clipedStreamLen = Number(p.StreamInfo.@Clipped_Len);			//save the duration relative to the original clip
									tempAsset.clipedStreamURL = String (p.StreamInfo.@file_name);			//save the orginal file path
									tempAsset.realSeqStreamSeekTime = timestamp + addTime[oddEven];							//the offset time in the large stream where this assets start (discrete mode)
									tempAsset.startByte = currentByte + addbytes[oddEven];										//the offset time in the large stream where this assets end (discrete mode)
									tempAsset.endByte = currentByte + uint(p.StreamInfo.@real_end_byte) - uint(p.StreamInfo.@real_start_byte);
									addTime[oddEven] += PADDING_TAG_TIME * PADDING_TAGS;
									addbytes[oddEven] += PADDING_TAG_SIZE * PADDING_TAGS;
									break;

								case MediaTypes.IMAGE:
									url2Load = URLProccessing.hashURLforMultipalDomains (tempAsset.mediaURL, tempAsset.entryId);
									tempAsset.mediaURL = url2Load;
									break;
							}
						} else {
							//TODO: How do we respond to a situation where an asset was not found (maybe deleted or got permissionized) ?
						}
						break;

					case MediaTypes.SOLID:																			// create a solid asset
						//for backward compatability, in the past we used to save solid color values on the name attribute.
						testColor = p.@name;
						if (isNaN(testColor))
							solidColor = uint(p.StreamInfo.@file_name);
						else
							solidColor = uint(testColor);
						bd = new BitmapData (KalturaApplication.getInstance().initPlayerWidth, KalturaApplication.getInstance().initPlayerHeight, false, solidColor);
						bmp = new Bitmap (bd);
						colorName = ""; //xxx ColorsUtil.getName(solidColor)[1];									//get the name of that color
						tempAsset = AssetsFactory.create (MediaTypes.SOLID, 'null', "solid-" + MediaTypes.SOLID.toString(),
														MediaTypes.getLocaleMediaType(MediaTypes.SOLID) + " (" + colorName + ")", solidColor.toString(), "",
														Number(p.StreamInfo.@len_time), maxStaticLength, 0, 0, String(p.EndTransition.@type),
														Number(p.StreamInfo.@len_time) - Number(p.EndTransition.@StartTime), false, false, bd);
						tempAsset.thumbBitmap = bmp;
						tempAsset.maxLength = maxStaticLength;
				 		sequenceVideoData.push (tempAsset);
						break;

					case MediaTypes.SWF:
				 		transitionId = String(p.EndTransition.@type);
				 		transitionIdlower = transitionId.toLowerCase();
				 		transitionThumbnail = KalturaApplication.getInstance().getTransitionThumbnail(transitionId);
				 		transitionLength = (Number(p.StreamInfo.@len_time) - Number(p.EndTransition.@StartTime));
				 		if ((transitionNone == transitionIdlower) || (transitionThumbnail == TransitionTypes.NONE))
				 		{
				 			transitionId = TransitionTypes.NONE;
				 			transitionLength = 0;
				 		}
						tempAsset = AssetsFactory.create(origineType, 'null', p.@k_id, p.@name, '',
	 								p.@url, Number(p.StreamInfo.@len_time), tempMaxLength, Number(p.StreamInfo.@start_time),
	 								Number(p.StreamInfo.@pan), transitionId, transitionLength);
						tempAsset.maxLength = maxStaticLength;
				 		sequenceVideoData.push (tempAsset);
						break;
				}
				if (tempAsset)
				{
					if ( ! Roughcut.mediaTypesSettings.transitionsClearRoughcut)
					{
						tempAsset.transitionLabel = KalturaApplication.getInstance().getTransitionLabel(tempAsset.transitionPluginID);
						pluginAssetXml = p.EndTransition.arguments[0];
						tempAsset.pluginAssetXml = pluginAssetXml != '' && pluginAssetXml != null ? pluginAssetXml : null;
					} else {
						tempAsset.transitionPluginID = TransitionTypes.NONE;
						tempAsset.transitionCross = false;
						tempAsset.transitionLabel = KalturaApplication.getInstance().getTransitionLabel(tempAsset.transitionPluginID);
						if (tempAsset.transitionPluginID.toLowerCase() != TransitionTypes.NONE.toLowerCase()) {
							if (tempAsset.transitionLabel == nullTransitionLabel) {
								//transition doesn't really exist -
								trace ('tried to load non-existing transition: ' + tempAsset.transitionPluginID);
							}
						}
						tempAsset.transitionLength = 0;
						transitionAsset = AssetsFactory.create (MediaTypes.TRANSITION, "null", '0',
												tempAsset.entryName + ".AssetTransition",
												KalturaApplication.getInstance().getTransitionThumbnail(tempAsset.transitionPluginID), tempAsset.transitionPluginID,
												tempAsset.transitionLength, tempAsset.transitionLength, 0, 0, tempAsset.transitionPluginID, tempAsset.transitionLength);
						tempAsset.transitionAsset = transitionAsset;
						tempAsset.transitionAsset.transitionCross = tempAsset.transitionCross;
					}
				}
			}

			//soundtrack control:
			//is it single assets soundtrack?
			var soundtrackAsset:AbstractAsset = null;
			var firstAssetPolicy:XMLList = originalSDL.AudioAssets.@firstAssetPolicy;
	 		var firstAssetPolicyExist:Boolean = firstAssetPolicy.length() > 0;
	 		var firstPolicy:uint = uint(firstAssetPolicy);
			var doSoundtrackAsset:Boolean = firstAssetPolicyExist && (firstPolicy == AudioPlayPolicy.AUDIO_PLAY_POLICY_ONCE || firstPolicy == AudioPlayPolicy.AUDIO_PLAY_POLICY_REPEAT);
		    if (firstPolicy == 0) firstPolicy = AudioPlayPolicy.AUDIO_PLAY_POLICY_ALL;
		    //behaviour of volume of the audio timeline when crossing with video assets over time:
			var volumePolicy:XMLList = originalSDL.AudioAssets.@soundtrackVolumePolicy;
	 		var volumePolicyExist:Boolean = volumePolicy.length() > 0;
	 		var soundtrackVolumePolicy:uint = volumePolicyExist ? uint(volumePolicy) : AudioPlayPolicy.CROSS_VIDEO_NO_ACTION;
		    //volume of the soundtrack
			var soundtrackVolumeXMList:XMLList = originalSDL.AudioAssets.@soundtrackVolume;
	 		var soundtrackVolumeExist:Boolean = soundtrackVolumeXMList.length() > 0;
	 		var soundtrackVolume:Number = soundtrackVolumeExist ? (uint(soundtrackVolumeXMList) / 100) : 1;
		    //volume of the soundtrack when in silent mode
			var soundtrackSilentVolumeXMList:XMLList = originalSDL.AudioAssets.@soundtrackSilentVolume;
	 		var soundtrackSilentVolumeExist:Boolean = soundtrackSilentVolumeXMList.length() > 0;
	 		var soundtrackSilentVolume:Number = soundtrackSilentVolumeExist ? (uint(soundtrackSilentVolumeXMList) / 100) : 0.4;
		    // run over the audio timeline assets in the SDL...
		    totalByte[0] = totalByte[1] = 0;
			totalTimestamp[0] = totalTimestamp[1] = 0;
			tempByte = 0;
			tempTimestamp = 0;
			timestamp = 0;
			currentByte = 0;
			oddEven = 1;
			lastByte = 0;
			lastTimeStamp = 0;
			print = print + "\n====\n";
			
			addbytes = [0,0];
			addTime = [0,0];
		    for each (p in originalSDL.AudioAssets.AudAsset)
			{
				oddEven = 1 - oddEven;
				tempTimestamp = Number(p.StreamInfo.@real_seek_time);
				tempByte = Number(p.StreamInfo.@real_start_byte);
				print = print + "\noddEven: " + oddEven + "\t\tLastTimeStamp: " + lastTimeStamp;
				if (tempTimestamp >= 0)
				{
					//calculate time stamp:
					totalTimestamp[lastStream] += tempTimestamp - lastTimeStamp;
					timestamp = totalTimestamp[oddEven];
					lastTimeStamp = tempTimestamp;
					//calculate Byte stamp:
					totalByte[lastStream] += tempByte - lastByte;
					currentByte = totalByte[oddEven];
					lastByte = tempByte;
					lastStream = oddEven;
					print = print + "\t\tAUDIO \t\ttempT: " + tempTimestamp + "\t\tcTimeStamp: " + timestamp;
				} else {
					print = print + "\t\tNON_AUDIO \t\ttempT: " + tempTimestamp + "\t\tcTimeStamp: " + timestamp;
				}
				origineType = MediaTypes.translateStringTypeToInt(p.@type);
				if (origineType != MediaTypes.SILENCE)
				{
					//this is an audio asset,
					//we use the rule "not == silence" so in the future we can handle different types of audio assets.

					//get the original asset to validate with:
					validAsset = all_assets.getValue(p.@k_id);
					origineType = MediaTypes.AUDIO;
					if (validAsset != null)
					{					//AUDIO:
						tempAsset = AssetsFactory.create (MediaTypes.AUDIO, 'null', validAsset.entryId, validAsset.entryName, validAsset.thumbnailURL, validAsset.mediaURL,
														Number(p.StreamInfo.@len_time), validAsset.maxLength, Number(p.StreamInfo.@start_time),
														Number(p.StreamInfo.@pan), String(p.EndTransition.@type), Number(p.StreamInfo.@len_time) - Number(p.EndTransition.@StartTime));
					} else {
						if (!validate_sdl)
						{
							tempAsset = AssetsFactory.create (origineType, 'null', p.@k_id, p.@name, '', p.@url,
														Number(p.StreamInfo.@len_time), Number(p.StreamInfo.@len_time), Number(p.StreamInfo.@start_time),
														Number(p.StreamInfo.@pan), String(p.EndTransition.@type), Number(p.StreamInfo.@len_time) - Number(p.EndTransition.@StartTime));
						}
					}
					if (tempAsset)
					{
				 		//get audiop graph
				 		tempAsset.audioGraph.fromXML(p.VolumePoints[0]);
				 		if (p.VolumePoints[0] == null) {
					 		tempAsset.audioGraph.setOverallVolume(0.5, false);
					 	}
				 		//get the original file url and trimming values:
						tempAsset.clipedStreamStart = Number(p.StreamInfo.@Clipped_Start);		//save the cut time relative to the original clip
						tempAsset.clipedStreamLen = Number(p.StreamInfo.@Clipped_Len);			//save the duration relative to the original clip
						tempAsset.clipedStreamURL = String (p.StreamInfo.@file_name);			//save the orginal file path
						tempAsset.realSeqStreamSeekTime = timestamp + addTime[oddEven];							//the offset time in the large stream where this assets start (discrete mode)
						tempAsset.startByte = currentByte + addbytes[oddEven];										//the offset time in the large stream where this assets end (discrete mode)
						tempAsset.endByte = currentByte + uint(p.StreamInfo.@real_end_byte) - uint(p.StreamInfo.@real_start_byte);
						addTime[oddEven] += PADDING_TAG_TIME * PADDING_TAGS;
						addbytes[oddEven] += PADDING_TAG_SIZE * PADDING_TAGS;
			 			
			 			//is this asset's transition is "cross" ?
				 		list = p.EndTransition.@cross;
				 		crossExist = list.length() > 0;
				 		tempAsset.transitionCross = crossExist ? (uint(p.EndTransition.@cross) > 0 ? true : false) : true;
						//Soundtrack (the player will repeat the first asset of AudioAssets)
						if (!soundtrackAsset && doSoundtrackAsset)
							soundtrackAsset = tempAsset;
						//add the asset to the audio assets array
		 				sequenceAudioData.push (tempAsset);
					} else {
						// TODO: How do we respond to a situation where an asset was not found (maybe deleted or got permissionized) ?
					}
				} else {
					// this is a SILENCE asset (place holder):
					validAsset = AssetsFactory.create (MediaTypes.SILENCE, 'null', "silence-" + MediaTypes.SILENCE.toString(),
														MediaTypes.getLocaleMediaType(MediaTypes.SILENCE), "", "",
														Number(p.StreamInfo.@len_time), maxStaticLength);
					validAsset.maxLength = maxStaticLength;
					//add the asset to the audio assets array
		 			sequenceAudioData.push (validAsset);
				}
			}
			trace ("Streams analyses:\n" + print);
			// run over the plugins timeline assets in the SDL...
			var pluginAsset:AbstractAsset;
			var tempThumbUrl:String;
			//process the overlays in the SDL:
			for each (p in originalSDL.Plugins.Overlays.Plugin)
			{
				duration = Number(p.@length);
				tempThumbUrl = KalturaApplication.getInstance().getPluginThumbnail(p.@type, MediaTypes.OVERLAY);
				pluginAsset = AssetsFactory.create (MediaTypes.OVERLAY, 'null', '-1', p.name, tempThumbUrl, p.@type, duration, duration,
												 0, 0, TransitionTypes.NONE, 0);
				pluginAsset.seqStartPlayTime = Number(p.@StartTime);
				pluginAsset.seqEndPlayTime = pluginAsset.seqStartPlayTime + duration;
				pluginAssetXml = p.*[0];
				pluginAsset.pluginAssetXml = pluginAssetXml != '' && pluginAssetXml != null ? pluginAssetXml : null;
				sequenceOverlaysData.push (pluginAsset);
			}
			//process the effects in the SDL:
			for each (p in originalSDL.Plugins.Effects.Plugin)
			{
				duration = Number(p.@length);
				tempThumbUrl = KalturaApplication.getInstance().getPluginThumbnail(p.@type, MediaTypes.OVERLAY);
				pluginAsset = AssetsFactory.create (MediaTypes.EFFECT, 'null', '-1', p.name, tempThumbUrl, p.@type, duration, duration,
												 0, 0, TransitionTypes.NONE, 0);
				pluginAsset.seqStartPlayTime = Number(p.@StartTime);
				pluginAsset.seqEndPlayTime = pluginAsset.seqStartPlayTime + duration;
				pluginAssetXml = p.*[0];
				pluginAsset.pluginAssetXml = pluginAssetXml != '' && pluginAssetXml != null ? pluginAssetXml : null;
				sequenceEffectsData.push (pluginAsset);
			}

			// The kshow_id provided has no sequence edited.
			if (sequenceVideoData.length == 0 && sequenceAudioData.length == 0)
			{
				trace ("\n\n ====== Loaded empty show ======= \n\n");
			}

			var roughcutTimelines:RoughcutTimelinesAssets = new RoughcutTimelinesAssets (roughcutEntryId, roughcutEntryVersion,
												sequenceVideoData, sequenceAudioData, sequenceOverlaysData,
												sequenceEffectsData, soundtrackAsset, firstPolicy, soundtrackVolumePolicy,
												soundtrackVolume, soundtrackSilentVolume);
			return roughcutTimelines;
		}

		public function buildOriginalSdl (roughcut_timelines:RoughcutTimelinesAssets):void
		{
			originalSDL = buildSDL (roughcut_timelines);
			currentSDL = originalSDL.copy();
		}

		/**
		 *build SDL from a given roughcut timelines, saves it as the current SDL and return it.
		 * <p>before running this you must call preSequencePlay on a the player.</p>
		 * @param roughcutTimelines		the roughcut timelines to build.
		 * @return 						the new SDL.
		 * @see Sequence Description Language.
		 */
		public function buildSDL (roughcutTimelines:RoughcutTimelinesAssets, editor_type:int = 1):XML
		{
			editorType = editor_type;
			var execXML:XML = <xml>
								<MetaData>
									<Publish>
										<Application>
											{(editorType == 1 ? 'kalturaSimpleEditor' : 'kalturaAdvancedEditor')}
										</Application>
									</Publish>
									<SeqDuration>
									</SeqDuration>
									<ShowVersion>
									</ShowVersion>
								</MetaData>
								<VideoAssets>
								</VideoAssets>
								<AudioAssets>
								</AudioAssets>
								<VoiceAssets>
								</VoiceAssets>
								<Plugins>
									<Overlays>
									</Overlays>
									<Effects>
									</Effects>
								</Plugins>
							</xml>;
			execXML.MetaData.SeqDuration = roughcutTimelines.roughcutDuration;
			execXML.MetaData.ShowVersion = '-1';
			if (originalSDL != null)
			{
				if (showPending != null)
				{
					execXML.MetaData.appendChild(new XML("<Pending>" + showPending + "</Pending>"));
				}
				if (lastPendingTimeStamp != null)
				{
					execXML.MetaData.appendChild(new XML("<LastPendingTimeStamp>" + lastPendingTimeStamp + "</LastPendingTimeStamp>"));
				}
				if (originalSDL.MetaData.hasOwnProperty("Host"))
				{
					execXML.MetaData.appendChild(new XML("<Host>" + originalSDL.MetaData.Host + "</Host>"));
				}
			}
			if (_thumbnailURL != "")
			{
				execXML.MetaData.ThumbUrl = _thumbnailURL;
			}

			execXML.AudioAssets.@firstAssetPolicy = roughcutTimelines.soundtrackFirstAssetPolicy;
			execXML.AudioAssets.@soundtrackVolumePolicy = roughcutTimelines.soundtrackVolumePlayPolicy;
			execXML.AudioAssets.@soundtrackVolume = ((roughcutTimelines.soundtrackVolume * 100) >> 0).toString();
			execXML.AudioAssets.@soundtrackSilentVolume = ((roughcutTimelines.soundtrackSilentVolume * 100) >> 0).toString();

			var parsedAsset:AbstractAsset;
			var VidAsset:XML;
			var N:int = roughcutTimelines.videoAssets.length;
			var transXML:XML;
			var vidURL:String = '';
			var vidURLRelative:String = '';
			var relativeURLIdx:int;
			var startStram:int, endStream:int;
			for (var i:int = 0; i < N; ++i)
			{
				transXML = new XML();
				parsedAsset = AbstractAsset(roughcutTimelines.videoAssets[i]);
				if (parsedAsset.transitionAsset && parsedAsset.transitionAsset.mediaSource)
					transXML = parsedAsset.transitionAsset.mediaSource.toXML();
				startStram = int(parsedAsset.startTime * 1000);
				endStream = int((parsedAsset.startTime + parsedAsset.length) * 1000);
				if (parsedAsset.mediaType == MediaTypes.VIDEO)
				{
					parsedAsset.mediaURL = URLProccessing.serverURL + parsedAsset.clipedStreamURL;
					var url2Load:String = URLProccessing.hashURLforMultipalDomains (URLProccessing.clipperServiceUrl (parsedAsset.entryId, parsedAsset.startTime, parsedAsset.length), parsedAsset.entryId);
					parsedAsset.mediaURL = url2Load;
				}
				if (parsedAsset.mediaType != MediaTypes.SOLID)
				{
					relativeURLIdx = parsedAsset.mediaURL.indexOf("/content");
					if (relativeURLIdx > -1)
					{
						vidURLRelative = parsedAsset.mediaURL.substring(relativeURLIdx, parsedAsset.mediaURL.length);
					} else {
						relativeURLIdx = parsedAsset.clipedStreamURL.indexOf("/content");
						vidURLRelative = parsedAsset.clipedStreamURL.substring(relativeURLIdx, parsedAsset.clipedStreamURL.length);
					}
				} else {
					vidURLRelative = parsedAsset.thumbnailURL;
				}
				VidAsset = <vidAsset k_id={parsedAsset.entryId} type={MediaTypes.translateIntTypeToString(parsedAsset.mediaType)} name={parsedAsset.entryName} url={parsedAsset.mediaURL}>
								<StreamInfo file_name={vidURLRelative}
									posX="0" posY="0" start_byte="-1" end_byte="-1" total_bytes="-1" real_seek_time="-1" start_time={parsedAsset.startTime} len_time={parsedAsset.length}
									volume={parsedAsset.audioGraph.getAverageVolume()} pan={parsedAsset.audioBalance} isSingleFrame="0" Clipped_Start={parsedAsset.startTime} Clipped_Len={parsedAsset.length} />
								<EndTransition cross={parsedAsset.transitionCross == true ? 1 : 0} type={parsedAsset.transitionPluginID} StartTime={(parsedAsset.length - parsedAsset.transitionLength)} length={parsedAsset.transitionLength}>
									{transXML}
								</EndTransition>
								{parsedAsset.audioGraph.toXML()}
		 					</vidAsset>;
				execXML.VideoAssets.appendChild(VidAsset);
			}
			var AudAsset:XML;
			var assetType:String;
			N = roughcutTimelines.audioAssets.length;
			for (i = 0; i < N; ++i)
			{
				parsedAsset = AbstractAsset(roughcutTimelines.audioAssets[i]);

				if ((relativeURLIdx = parsedAsset.mediaURL.indexOf("/content")) > -1)
				{
					vidURLRelative = parsedAsset.mediaURL.substring(relativeURLIdx, parsedAsset.mediaURL.length);
				} else {
					relativeURLIdx = parsedAsset.clipedStreamURL.indexOf("/content");
					vidURLRelative = parsedAsset.clipedStreamURL.substring(relativeURLIdx, parsedAsset.clipedStreamURL.length);
				}
				assetType = MediaTypes.translateIntTypeToString(parsedAsset.mediaType);
				AudAsset = <AudAsset k_id={parsedAsset.entryId} type={assetType} name={parsedAsset.entryName} url={parsedAsset.mediaURL}>
								<StreamInfo file_name={vidURLRelative}
									start_byte="-1" end_byte="-1" total_bytes="-1" real_seek_time="-1" start_time={parsedAsset.startTime} len_time={parsedAsset.length}
									volume={parsedAsset.audioGraph.getAverageVolume()} pan={parsedAsset.audioBalance} />
								<EndTransition type={parsedAsset.transitionPluginID} StartTime={(parsedAsset.length - parsedAsset.transitionLength)} length={parsedAsset.transitionLength} />
								{parsedAsset.audioGraph.toXML()}
		 					</AudAsset>;
				execXML.AudioAssets.appendChild(AudAsset);
			}
			var PluginAsset:XML;
			var tempO:Overlay;
			N = roughcutTimelines.overlaysAssets.length;
			for (i = 0; i < N; ++i)
			{
				parsedAsset = AbstractAsset(roughcutTimelines.overlaysAssets[i]);
				tempO = parsedAsset.mediaSource;
				if (tempO != null)
				{
					PluginAsset = <Plugin type={tempO.moduleId} StartTime={parsedAsset.seqStartPlayTime} length={parsedAsset.length}>
										{tempO.toXML()}
								  </Plugin>;
					execXML.Plugins.Overlays.appendChild (PluginAsset);
				}
			}
			PluginAsset = null;
			var tempE:KEffect;
			N = roughcutTimelines.effectsAssets.length;
			for (i = 0; i < N; ++i)
			{
				parsedAsset = AbstractAsset(roughcutTimelines.effectsAssets[i]);
				tempE = parsedAsset.mediaSource;
				if (tempE != null)
				{
					PluginAsset = 	<Plugin type={tempE.moduleId} StartTime={parsedAsset.seqStartPlayTime} length={parsedAsset.length}>
										{tempE.toXML()}
						  			</Plugin>;
					execXML.Plugins.Effects.appendChild (PluginAsset);
				}
			}
			currentSDL = execXML.copy();
			return execXML.copy();
		}
	}
}

/*
<vidAsset k_id={entry id on kaltura server} type={VIDEO | AUDIO | SOLID | IMAGE | SILENCE | VOICE} name={name of entry on kaltura server} url={url of file}>
	<StreamInfo file_name={file name} posX="0" posY="0" start_byte="-1" end_byte="-1" total_bytes="-1" real_seek_time="-1" start_time={0-maximum length of original file} len_time={length in seconds} volume={the volume specific to the asset} pan={the audio balance specific to the asset} Clipped_Start={the time we cut the asset relative to the original stream} Clipped_Len={the duration we cut the asset relative to the original stream} />
	<EndTransition cross={1 if this transition performs cross between this asset and the following or 0 if it affect only this asset} type={type of transition - the id of the plugin on kaltura server} StartTime={the time in seconds relative to the asset duration on which the transition should start} length={the duration of the transition - in seconds}>
		{transition plugin specific values and description}
	</EndTransition>
	<AssetEffect type={type of effect - the id of the plugin on kaltura server} StartTime={the time in seconds relative to the asset duration on which the effect should start} length={the duration of the effect - in seconds}>
		{effect plugin specific values and description}
	</AssetEffect>
	<VolumePoints>
		<VolumePoint time={0-length} volume={0-1} />
	</VolumePoints>
</vidAsset>
<Plugin type={type of plugin on the kaltura server} StartTime={the global sequence time in seconds at which plugin starts to affect} length={the duration of the plugin in seconds}>
	{specific plugin elements}
</Plugin>
*/