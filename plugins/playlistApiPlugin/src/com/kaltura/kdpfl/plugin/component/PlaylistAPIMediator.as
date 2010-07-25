/**
 * PlaylistAPIMediator
 *
 * @langversion 3.0
 * @playerversion Flash 9.0.28.0
 * @author Dan Bacon / www.baconoppenheim.com
 */
 package com.kaltura.kdpfl.plugin.component
{
	
	import com.akamai.events.AkamaiNotificationEvent;
	import com.akamai.rss.AkamaiMediaRSS;
	import com.akamai.rss.ContentTO;
	import com.akamai.rss.ItemTO;
	import com.akamai.rss.Media;
	import com.kaltura.base.types.MediaTypes;
	import com.kaltura.events.KalturaEvent;
	import com.kaltura.kdpfl.plugin.type.DataProviderNotification;
	import com.kaltura.utils.KConfigUtil;
	import com.kaltura.vo.KalturaPlayableEntry;
	
	import flash.events.*;
	import flash.net.URLLoader;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	/**
	 * Mediator for Playlist API Plugin 
	 */	
	public class PlaylistAPIMediator extends Mediator
	{
		/**
		 * mediator name 
		 */		
		public static const NAME:String = "PlaylistAPIMediator";
		
		private var _akamaiMRSS:AkamaiMediaRSS = new AkamaiMediaRSS;
		private var _dataLoader:URLLoader = new URLLoader;
		private var _dataProvider:KDataProvider;
		private var _viewedDataProvider:KDataProvider;
		private var _playlistUrl:String;
		private var _wasPlayed:Boolean;
		private var _playlistName:String;
		private var	_entryId:String=""
		private var _firstTimeInit : Boolean = false;
		private var _multiDataProviders:Array = new Array();
		private var _flashvars: Object;
		private var _loadOnChangeFlag : Boolean = false;
		private var _autoplay:Boolean= false;
		private var _started:Boolean=false;
		private var _filters:Array = new Array();
		
		/**
		 * Constructor 
		 * @param viewComponent	view component
		 */		
		public function PlaylistAPIMediator( viewComponent:Object=null )
		{
			super( NAME, viewComponent );
			
			_flashvars = facade.retrieveProxy("configProxy")["vo"]["flashvars"];
			
		}
		
		/**
		 * Mediator's registration function. Sets KDP autoPlay value and the default image duration.  
		 */		
		override public function onRegister():void 
		{
			var mediaProxy : Object = facade.retrieveProxy( "mediaProxy" ); 
			mediaProxy.vo.supportImageDuration = true;
			//initPlayList();
			//trace ("playlist register");
			if(view.autoPlay==true) _autoplay=true;
			if(_autoplay) _flashvars.autoPlay = "true";
		}
	
		/**
		 * Commences load of the active playlist. 
		 * 
		 */		
		private function initPlayList():void
		{
			if(view.kpl0Url)	
			{
				loadPlaylist( view.kpl0Name , view.kpl0Url );	
						
			}	
		}

		/**
		 * Reload the active playlist with saved filter parameters. 
		 */		
		public function reloadPlaylist():void
		{
			loadPlaylist(_playlistName, _playlistUrl);
		}		
				
		/**
		 * Load a playlist from a given url.
		 * @param name	playlist name, which becomes displayed in the playlist tab-bar.
		 * @param url	url to load playlist from
		 * 
		 */		
		public function loadPlaylist(name:String, url:String):void
		{   
			
			if(_dataProvider)
			{
				_dataProvider.removeEventListener(Event.CHANGE,onChangeItem , false);
			}
				
			//_started = _loadOnChangeFlag = false;
			
		    //if we already have a selected data provider we will reset the selectedIndex
			if(_dataProvider) _dataProvider.selectedIndex = NaN;
			
			_playlistName = name;
			url = unescape(url); // in case the URL got here ecsaped
			var kc: Object =  facade.retrieveProxy("servicesProxy")["kalturaClient"];
			_playlistUrl = url.replace("{ks}",kc.ks);
			var filteredUrl:String = _playlistUrl;
			var i:int = 1;
			//apply filters
			for (var filt:* in _filters)
			{
				if (_filters[filt]  != null)
				{
					filteredUrl = filteredUrl + "&filter" +i.toString() + "__" +  filt + "=" + _filters[filt];
					i++;
				}
			}

			if (_multiDataProviders[filteredUrl] == null)
			{
				_akamaiMRSS.addEventListener( AkamaiNotificationEvent.PARSED, onDataLoaded, false, 0, true );
				_akamaiMRSS.load( filteredUrl );
			}
			else
			{
				_dataProvider = _multiDataProviders[filteredUrl];
				view.dataProvider = _dataProvider;
				createItems(view.dataProvider.selectedIndex);
				_dataProvider.addEventListener(Event.CHANGE,onChangeItem , false);
			}
		}
	
		/**
		 * Create a data provider from a non-mrss response and assign it to the view.
		 * @param evt KalturaEvent
		 */		
		public function onDataLoadedNotMRSS( evt:KalturaEvent ):void
		{
			var mediaEntries:Array = evt.data as Array;
			_dataProvider = new KDataProvider( mediaEntries );
			_dataProvider.addEventListener( Event.CHANGE, onChangeItem, false, 0, true );
			view.dataProvider = _dataProvider; // update plugin main
		}
		
		// written by almog @ kaltura
		private function mrssToMediaEntryArray():Array
		{
			var itemToList:Array = _akamaiMRSS.itemArray;
			var entries:Array = [];
	
			for each (var itemTo:ItemTO in itemToList)
			{
				var kalturaEntry:KalturaPlayableEntry = new KalturaPlayableEntry();
	
				var media:Media = itemTo.media;
				var contentTo:ContentTO = media.contentArray[0];
				for (var itemProperty:String in itemTo)
				{
					kalturaEntry[itemProperty] = KConfigUtil.getDefaultValue2(itemTo[itemProperty], kalturaEntry, itemProperty);
				}
				//TODO chaeck if this is the proper way to parse 
				//kalturaEntry.duration = parseInt(itemTo.media.contentArray[0].duration);
				kalturaEntry.duration = parseInt(contentTo.duration);
				if (itemTo.media.thumbnail)
					kalturaEntry.thumbnailUrl = itemTo.media.thumbnail.url;
				kalturaEntry.name = itemTo.media.title;
				kalturaEntry.description = itemTo.media.description;
				kalturaEntry['partnerLandingPage'] = itemTo.link;
				kalturaEntry.createdAt = itemTo.createdAtInt;
	
				if (!kalturaEntry.id)
					kalturaEntry.id = contentTo.url;
				kalturaEntry['seekFromStart'] = KConfigUtil.getDefaultValue(itemTo.seekFromStart, 0);
				kalturaEntry['mediaType'] = MediaTypes.translateServerType(MediaTypes.translateStringTypeToInt(contentTo.medium.toUpperCase()), true);
				entries.push(kalturaEntry);
			}
	
			return( entries ); 
		}	
		
		/**
		 * Create data provider to display in the view. 
		 * @param mediaEntries array of media entries parsed from the playlist response.
		 * 
		 */		
		private function _createNewProvider(mediaEntries:Array):void
		{	
			_dataProvider = new KDataProvider( mediaEntries );
			_dataProvider.addEventListener( Event.CHANGE, onChangeItem, false, 0, true );
			view.dataProvider = _dataProvider; // update plugin main
			createItems(view.initItemIndex);
			_multiDataProviders[_playlistUrl] = _dataProvider;
		}
		
		
		/**
		 * Parse MRSS response into a data provider to display in the View. 
		 * @param evt
		 */		
		public function onDataLoaded( evt:AkamaiNotificationEvent ):void
		{
			var mediaEntries:Array = mrssToMediaEntryArray();
			_createNewProvider(mediaEntries);
		}
	
	    private function createItems(index:int = 0):void
	    {
			if(_dataProvider.length >0)
			{
				
				 
				if(view.autoInsert) 
				{
					if(!_wasPlayed)
					{
						_wasPlayed = true;	
						
						_dataProvider.selectedIndex = index;
						view.autoInsert = false;

					}
				}
			}
	    }
	
		private function onChangeItem( evt:Event ):void
		{
			if(_started)//because the kdp first changes media, we need to activate the _loadOnChangeFlag from the second time it changes media
			{
				_loadOnChangeFlag = true; //indicates that we need to load 
				(facade.retrieveProxy("mediaProxy"))["vo"]["singleAutoPlay"] = true;
			}
			if(!_dataProvider.selectedIndex)
			{
				_dataProvider.selectedIndex = 0;
			}
			//trace ("in change item");
			sendChangeMedia(_dataProvider.selectedIndex);
			_started=true;
			
		}

		private function playNext():void
		{
			if (_dataProvider && _dataProvider.selectedIndex<_dataProvider.length-1)
				_dataProvider.selectedIndex += 1;
		}
		
		private function playPrevious():void
		{
			if(_dataProvider && _dataProvider.selectedIndex>=0)
				_dataProvider.selectedIndex -= 1;
		}
		
		private function sendChangeMedia(index:int):void
		{
			var item:Object=_dataProvider.getItemAt(index);
			if(_entryId == item.entryId) return; //if it's the same item return
			
			_entryId = item.entryId;
			
			facade.sendNotification( "changeMedia", {entryId:_entryId} );	
		}
		
		/**
		 * Notify KDP that load failed 
		 * @param evt fault data
		 */		
		public function onDataLoadError( evt:KalturaEvent ):void
		{
			facade.sendNotification( DataProviderNotification.DATA_ERROR, evt );
		}
		 
		/**
		 * Apply a filter to the playlist.
		 * @param field	new field to filter by.
		 * @param value	value to filter by
		 */		
		public function setFilter(field:String, value:String):*
		{
			_filters[field] = value;	
		}
		
		/**
		 * Remove a specific filter from the playlist 
		 * @param field the field to remove from the filter
		 */		
		public function clearFilter(field:String):*
		{
			_filters[field] = null;
		}

		/**
		 * Remove all filters (nullify the filters array).
		 */		
		public function clearFilters():*
		{
			var f:String;
			for(f in _filters)
			{
				_filters[f] = null;
			}
		}
		
		/**
		 * @inheritDoc
		 */		
		override public function handleNotification( note:INotification ):void
		{
			switch( note.getName() )
			{
				case DataProviderNotification.NEXT_ITEM:			
					if( _dataProvider ) _dataProvider.next(); 
				break;	
				case DataProviderNotification.PREV_ITEM:	
					if( _dataProvider ) _dataProvider.prev();
				break;
				case "mediaReady":
					//if the load is caused from change or we have auto play flag we should start play on media loaded
					//if (_entryId != note.getBody().entryId) return;
					  
				break;
				case "playerPlayEnd":
				if (view.autoContinue)
			    {
					playNext();
			    }
				break;
				case "playlistPlayPrevious":
					playPrevious();
				break;
				case "playlistPlayNext":
					playNext();
				break;
				case "layoutReady":
					//trace("plugins loaded");
					
				break;
				case "kdpEmpty":
				case "kdpReady":
					if(!_firstTimeInit)
					{
						initPlayList();
						_firstTimeInit = true;
					}
				break;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function listNotificationInterests():Array
		{
			return [
				DataProviderNotification.NEXT_ITEM,
				DataProviderNotification.PREV_ITEM,
				"mediaReady",
				"playerPlayEnd",
				"playlistPlayPrevious",
				"playlistPlayNext",
				"layoutReady",
				"kdpEmpty",
				"kdpReady"
			];
		}
	
		/**
		 * Return mediator name
		 */		
		public function toString():String
		{
			return( NAME );
		}	
					
		/**
		 * Return Playlist's view component
		 */		
		public function get view():playlistAPIPluginCode
		{
			return( viewComponent as playlistAPIPluginCode );
		}
				
	}
}