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
package com.kaltura.managers.downloadManagers
{
    import com.kaltura.assets.abstracts.AbstractAsset;
    import com.kaltura.base.types.MediaTypes;
    import com.kaltura.dataStructures.HashMap;
    import com.kaltura.managers.downloadManagers.events.DownloadManagerStatusEvent;
    import com.kaltura.managers.downloadManagers.imagesManager.ImagesManager;
    //xxx import com.kaltura.managers.downloadManagers.protocols.NetProtocolBitmapSocket;
    import com.kaltura.managers.downloadManagers.protocols.NetProtocolImage;
    import com.kaltura.managers.downloadManagers.protocols.NetProtocolPlugin;
    import com.kaltura.managers.downloadManagers.protocols.NetProtocolProgressiveDUAL;
    import com.kaltura.managers.downloadManagers.protocols.NetProtocolProgressiveFLV;
    import com.kaltura.managers.downloadManagers.protocols.NetProtocolSWFLoader;
    import com.kaltura.managers.downloadManagers.protocols.NetProtocolSolidColor;
    import com.kaltura.managers.downloadManagers.protocols.interfaces.INetProtocol;
    import com.kaltura.managers.downloadManagers.types.StreamingModes;
    import com.kaltura.net.downloading.LoadingStatus;
    import com.kaltura.net.loaders.interfaces.IMediaSourceLoader;

    import flash.display.*;
    import flash.events.*;

    import mx.utils.UIDUtil;

    /**
     * Singleton that localizes, and standardizes loading and monitoring of media download.
     */
     [Event(name="mediaLoaded", type="com.kaltura.managers.downloadManagers.events.DownloadManagerStatusEvent")]
    public class DownloadManager extends EventDispatcher
    {
    	static private var meName:String = 'LoadUtility';
		protected var _doHashing:Boolean = true;
		protected var roughcutsTable:HashMap = new HashMap();

		/**
		 *determines whether to preform domain hashing for using multiple subdomains or not.
		 * @return 		true if manager will preform hashing.
		 *
		 */
		public function get doHashing ():Boolean
		{
			return _doHashing;
		}

		/**
		 * determines whether to preform domain hashing for using multiple subdomains or not.
		 * @param hash		true if manager should preform hashing.
		 *
		 */
		public function set doHashing (do_hash:Boolean):void
		{
			_doHashing = do_hash;
		}

		/**
		 * generates a uid in order to identify the asset's media source being downloaded.
		 * @return 		UUID.
		 * @private
		 */
		static private function getNextAssetUniqueKey():String
		{
			return UIDUtil.createUID();
		}

        /**
         *instantiate and load the media object of an asset.
         * @param roughcut_entryId			the entryId of the roughcut associated with the asset to load.
         * @param roughcut_entry_version	the version of the roughcut associated with the asset to load.
         * @param asset						the asset it's mediaSource to load.
         * @param completeHandle			a function to be called when protocol dispatch finish loading (COMPLETE).
         * @param streamingMode				determine the serving method used to get the media files.
         * @param assetIndex				the asset's index in the timeline.
         * @see com.kaltura.managers.downloadManagers.types.StreamingModes
         */
        public function loadAsset (roughcut_entry_Id:String, roughcut_entry_version:int, asset:AbstractAsset, completeHandle:Function = null, streamingMode:int = 0, assetIndex:uint = 0):void
        {
        	var netProtocol:INetProtocol;
        	asset.assetUID = DownloadManager.getNextAssetUniqueKey();
        	switch (asset.mediaType)
        	{
        		case MediaTypes.AUDIO:
        		case MediaTypes.VIDEO:
        			switch (streamingMode)
        			{
        				case StreamingModes.PROGRESSIVE:
        					netProtocol = new NetProtocolProgressiveFLV (roughcut_entry_Id, roughcut_entry_version);
        					break;

        				case StreamingModes.PROGRESSIVE_STREAM_DUAL:
        					netProtocol = new NetProtocolProgressiveDUAL (roughcut_entry_Id, roughcut_entry_version, assetIndex);
        			}
        			break;

        		case MediaTypes.IMAGE:
        			netProtocol = new NetProtocolImage (roughcut_entry_Id, roughcut_entry_version);
        			break;

        		case MediaTypes.EFFECT:
        		case MediaTypes.OVERLAY:
        		case MediaTypes.TRANSITION:
        			netProtocol = new NetProtocolPlugin (roughcut_entry_Id, roughcut_entry_version);
        			break;

/*         		case MediaTypes.BITMAP_SOCKET:
        			netProtocol = new NetProtocolBitmapSocket (roughcut_entry_Id, roughcut_entry_version);
        			break;
 */
        		case MediaTypes.SOLID:
					netProtocol = new NetProtocolSolidColor (roughcut_entry_Id, roughcut_entry_version);
        			break;

        		case MediaTypes.SWF:
        			netProtocol = new NetProtocolSWFLoader (roughcut_entry_Id, roughcut_entry_version);
        			break;
        	}
        	//if there is no protocol (the mediaType is incorrect or does not exist):
        	if (!netProtocol)
        		return;

        	//process the media loading using the net protocol:
        	if (completeHandle != null)
        		netProtocol.addEventListener(Event.COMPLETE, completeHandle, false, 0, true);
        	netProtocol.addEventListener (Event.COMPLETE, dispacthFinish, false, 0, true);
        	var mediaSourceLoader:IMediaSourceLoader = netProtocol.load(asset);
        	if (mediaSourceLoader && mediaSourceLoader.loadedObject)
        	{
        		asset.mediaSource = mediaSourceLoader.loadedObject.mediaSource;
        		asset.mediaSourceLoader = mediaSourceLoader;
        		addLoaderToTable (roughcut_entry_Id, roughcut_entry_version, asset.assetUID, mediaSourceLoader);
        		if (asset.mediaSourceLoader.status == LoadingStatus.COMPLETE)
					asset.mediaSourceLoader.dispatchEvent(new Event (Event.COMPLETE));
			}
        }

        /**
         * when a net protocol finishs loading, this function dispatches MEDIA_LOADED event.
         * @see com.kaltura.managers.downloadManagers.events.DownloadManagerStatusEvent
         */
        private function dispacthFinish (event:Event):void
        {
        	var netProtocol:INetProtocol = event.target as INetProtocol;
        	var newEvent:DownloadManagerStatusEvent;
        	newEvent = new DownloadManagerStatusEvent (DownloadManagerStatusEvent.MEDIA_LOADED, netProtocol.roughcutEntryId, netProtocol.roughcutEntryVersion, netProtocol.asset.mediaURL, LoadingStatus.COMPLETE, netProtocol.asset);
        	this.dispatchEvent(newEvent);
        }

        /**
         * index the mediaSourceLoader with an associated roughcut entryId in a hashTable.
         * this keeps a reference to the loader, making it possible to aggragate loading status for multiple roughcuts.
         * @param roughcut_entry_id			the entryId of the asssociated roughcut.
         * @param roughcut_entry_version	the version of the asssociated roughcut.
         * @param asset_uid					the uid of the asset it's mediaSource to load.
         * @param media_source_loader		the loader to index.
         * @see com.kaltura.managers.downloadManagers.protocols.loaders.interfaces.IMediaSourceLoader
         */
        protected function addLoaderToTable (roughcut_entry_id:String, roughcut_entry_version:int, asset_uid:String, media_source_loader:IMediaSourceLoader):void
        {
        	var roughcutLoadersTable:HashMap = roughcutsTable.getValue(roughcut_entry_id + "." + roughcut_entry_version.toString());
        	if (roughcutLoadersTable)
        	{
        		roughcutLoadersTable.put (asset_uid, media_source_loader);
        	} else {
        		roughcutLoadersTable = new HashMap ();
        		roughcutLoadersTable.put (asset_uid, media_source_loader);
        		roughcutsTable.put (roughcut_entry_id + "." + roughcut_entry_version.toString(), roughcutLoadersTable);
        	}
        }

        /**
         *get the loaders map of a desired roughcut.
         * @param roughcut_entry_id			the id of the roughcut which loaders we want.
         * @param roughcut_entry_version	the version of the asssociated roughcut.
         * @return 							map that contains all the roughcut's assets loaders.
         */
        public function getRoughcutMap (roughcut_entry_id:String, roughcut_entry_version:String):HashMap
        {
			var roughcutLoadersTable:HashMap = roughcutsTable.getValue(roughcut_entry_id + "." + roughcut_entry_version);
        	if (roughcutLoadersTable)
        	{
        		return roughcutLoadersTable;
        	}
        	return null;
        }

        /**
         * removes an asset loader by it's asset uid and dispose it from memory.
         * @param roughcut_entry_id			the entry id of the roughcut this asset loader belongs to.
         * @param roughcut_entry_version	the version of the asssociated roughcut.
         * @param asset_uid					the uid of the related asset.
         * @see com.kaltura.assets.abstracts.assetUID
         */
        public function removeAssetLoader (roughcut_entry_id:String, roughcut_entry_version:int, asset_uid:String):void
        {
        	var roughcutLoadersTable:HashMap = roughcutsTable.getValue(roughcut_entry_id + "." + roughcut_entry_version);
        	if (roughcutLoadersTable)
        	{
        		var assetLoader:IMediaSourceLoader = roughcutLoadersTable.getValue(asset_uid);
        		if (assetLoader)
        		{
	        		ImagesManager.getInstance().removeImage(assetLoader.url);
	        	}
        		roughcutLoadersTable.remove(asset_uid);
        		if (roughcutLoadersTable.size() == 0)
        			roughcutsTable.remove (roughcut_entry_id + "." + roughcut_entry_version);
        	}
        }

        //===================================================================================================
        //singleton control:
        static private var dlManager:DownloadManager;

        static public function getInstance ():DownloadManager
        {
        	if (dlManager == null)
        	{
        		dlManager = new DownloadManager ();
        	}
        	return dlManager;
        }

        public function DownloadManager ():void
        {
        	if (dlManager != null)
        		throw new Error ("Singleton can't be instantiated more than once, use getInstance instead.");
        }
    }
}