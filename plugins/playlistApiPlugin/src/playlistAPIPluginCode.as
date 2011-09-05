package {
	import com.akamai.events.AkamaiNotificationEvent;
	import com.akamai.rss.AkamaiMediaRSS;
	import com.akamai.rss.ContentTO;
	import com.akamai.rss.ItemTO;
	import com.akamai.rss.Media;
	import com.kaltura.base.types.MediaTypes;
	import com.kaltura.events.KalturaEvent;
	import com.kaltura.kdpfl.model.FuncsProxy;
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.plugin.component.KDataProvider;
	import com.kaltura.kdpfl.plugin.component.PlaylistAPIMediator;
	import com.kaltura.kdpfl.util.DateTimeUtils;
	import com.kaltura.kdpfl.util.Functor;
	import com.kaltura.utils.KConfigUtil;
	import com.kaltura.vo.KalturaPlayableEntry;
	
	import fl.data.DataProvider;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	import org.puremvc.as3.interfaces.IFacade;

	/**
	 * playlistAPIPluginCode needs to be dynamic so it can receive 
	 * indexed playlists names and urls. </br>
	 * it is also used as the view component for this plugin.
	 */	
	public dynamic class playlistAPIPluginCode extends Sprite implements IPlugin {
		
		/**
		 * plugin mediator
		 */		
		private var _playlistAPIMediator:PlaylistAPIMediator;
		
		/**
		 * a wrapper for media rss
		 * */
		private var _akamaiMRSS:AkamaiMediaRSS = new AkamaiMediaRSS;
		
		/**
		 * @copy #dataProvider. 
		 */		
		private var _dataProvider:KDataProvider;
		
		/**
		 * url of currently play8ing playlist 
		 */		
		private var _playlistUrl:String;
		
		/**
		 * indicates this playlist (??) was played 
		 */		
		private var _wasPlayed:Boolean;
		
		/**
		 * name of the currently playing playlist 
		 */		
		private var _playlistName:String;
		
		/**
		 * id of currently playing entry 
		 */		
		private var _entryId:String = "";
		
		/**
		 * only initialize playlist once
		 */			
		private var _initialLoad:Boolean = false;
		
		/**
		 * an object whose keys are playlist urls and values are matching KDataProviders.
		 * when you come to wonder why an array has keys that are strings - it's because 
		 * array is a dynamic class. why an array is used here instead of an object is beyond me.
		 */		
		private var _multiDataProviders:Array = new Array();
		
		/**
		 * only set something once.
		 * beats me why. 
		 */		
		private var _started:Boolean = false;
		
		/**
		 * playlist filters
		 */		
		private var _filters:Array = new Array();

		/**
		 * @copy #multiPlaylistDataProvider 
		 */		
		private var _multiDataProvider:DataProvider;
		
		/**
		 * @copy #selectedDataProvider
		 */
		private var _selectedDataProvider:DataProvider;
		
		/**
		 * @copy #searchDataProvider 
		 */
		private var _searchDataProvider:DataProvider;
		
		/**
		 * @copy #sortDataProvider
		 */
		private var _sortDataProvider:DataProvider;
	
		
		
		/**
		 * automatically continue to next item in playlist 
		 */		
		public var autoContinue:Boolean = false;
		
		/**
		 * automatically start playing the first item 
		 */		
		public var autoPlay:Boolean = false;
		
		/**
		 * automatically load the first entry in the playlist 
		 * @default true
		 */		
		public var autoInsert:Boolean = true;
		
		/**
		 * automatically load the first playlist 
		 * @default true
		 */		
		public var playlistAutoInsert:Boolean = true;
		
		/**
		 * start playing the playlist from this item index
		 */		
		public var initItemIndex:int = 0;


		
		/**
		 * Constructor
		 */
		public function playlistAPIPluginCode() {}


		
		
		/**
		 * Commences load of the first playlist (kpl0). <br/>
		 * This should only happen the first time we recieve kdpEmpty/kdpReady 
		 */
		public function loadFirstPlaylist():void {
			if (playlistAutoInsert && !_initialLoad) {
				if (this.kpl0Url) {
					loadPlaylist(this.kpl0Name, this.kpl0Url);
				}
				_initialLoad = true;
			}
		}
		
		
		/**
		 * Reload the active playlist with saved filter parameters.
		 */
		private function reloadPlaylist():void {
			loadPlaylist(_playlistName, _playlistUrl);
		}
		
		
		/**
		 * Load a playlist from a given url.
		 * @param name	playlist name, which becomes displayed in the playlist tab-bar.
		 * @param url	url to load playlist from
		 */
		public function loadPlaylist(name:String, url:String):void {
			
			if (_dataProvider) {
				_dataProvider.removeEventListener(Event.CHANGE, onChangeItem, false);
			}
			//if we already have a selected data provider we will reset the selectedIndex
			if (_dataProvider && _dataProvider.length != 0)
				_dataProvider.selectedIndex = NaN;
			
			_playlistName = name;
			url = unescape(url); // in case the URL got here ecsaped
			_playlistUrl = url.replace("{ks}", _playlistAPIMediator.ks);
			var filteredUrl:String = _playlistUrl;
			var i:int = 1;
			//apply filters
			for (var filt:* in _filters) {
				if (_filters[filt] != null) {
					filteredUrl = filteredUrl + "&filter" + i.toString() + "__" + filt + "=" + _filters[filt];
					i++;
				}
			}
			
			if (_multiDataProviders[filteredUrl] == null) {
				_akamaiMRSS.addEventListener(AkamaiNotificationEvent.PARSED, onDataLoaded, false, 0, true);
				_akamaiMRSS.load(filteredUrl);
			}
			else {
				dataProvider = _multiDataProviders[filteredUrl];
				createItems(_dataProvider.selectedIndex);
				_dataProvider.addEventListener(Event.CHANGE, onChangeItem, false);
				_playlistAPIMediator.sendNotification(playlistAPIPlugin.PLAYLIST_READY);
			}
		}
		
		
		/**
		 * Create a data provider from a non-mrss response and assign it to the view.
		 * @param evt KalturaEvent
		 */
		private function onDataLoadedNotMRSS(evt:KalturaEvent):void {
			var mediaEntries:Array = evt.data as Array;
			dataProvider = new KDataProvider(mediaEntries);
			_dataProvider.addEventListener(Event.CHANGE, onChangeItem, false, 0, true);
			_playlistAPIMediator.sendNotification(playlistAPIPlugin.PLAYLIST_READY);
		}
		
		
		// written by almog @ kaltura
		private function mrssToMediaEntryArray():Array {
			var itemToList:Array = _akamaiMRSS.itemArray;
			var entries:Array = [];
			
			for each (var itemTo:ItemTO in itemToList) {
				var kalturaEntry:KalturaPlayableEntry = new KalturaPlayableEntry();
				
				var media:Media = itemTo.media;
				var contentTo:ContentTO = media.contentArray[0];
				for (var itemProperty:String in itemTo) {
					kalturaEntry[itemProperty] = KConfigUtil.getDefaultValue2(itemTo[itemProperty], kalturaEntry, itemProperty);
				}
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
			
			return (entries);
		}
		
		
		/**
		 * Create data provider to display in the view.
		 * @param mediaEntries array of media entries parsed from the playlist response.
		 */
		private function createNewProvider(mediaEntries:Array):void {
			dataProvider = new KDataProvider(mediaEntries);
			_dataProvider.addEventListener(Event.CHANGE, onChangeItem, false, 0, true);
			createItems(initItemIndex);
			_multiDataProviders[_playlistUrl] = _dataProvider;
			_playlistAPIMediator.sendNotification(playlistAPIPlugin.PLAYLIST_READY);
		}
		
		
		/**
		 * Parse MRSS response into a data provider to display in the View.
		 * @param evt
		 */
		private function onDataLoaded(evt:AkamaiNotificationEvent):void {
			var mediaEntries:Array = mrssToMediaEntryArray();
			createNewProvider(mediaEntries);
		}
		
		
		private function createItems(index:int = 0):void {
			if (_dataProvider.length > 0) {
				if (autoInsert) {
					if (!_wasPlayed) {
						_wasPlayed = true;
						
						_dataProvider.selectedIndex = index;
						autoInsert = false;
						
					}
				}
			}
		}
		
		
		/**
		 * Triggered when the dataprovider's selectedItem is changed.
		 * @param evt
		 */
		private function onChangeItem(evt:Event):void {
			if (_started) {
				_playlistAPIMediator.setMediaProxySingleAutoPlay(true);
			}
			if (!_dataProvider.selectedIndex) {
				_dataProvider.selectedIndex = 0;
			}
			sendChangeMedia(_dataProvider.selectedIndex);
			_started = true;
			
		}
		
		
		/**
		 * Plays the next item in the dataprovider, until the end of the list. 
		 * doesn't "wrap" the list. 
		 */		
		public function playNext():void {
			//check if this is the last entry of the playlist. 
			//DO NOT switch these 2 conditions. 
			if (_dataProvider && _dataProvider.selectedIndex == _dataProvider.length-1)
			{
				_playlistAPIMediator.sendNotification(playlistAPIPlugin.PLAYLIST_DONE);
			}
			if (_dataProvider && _dataProvider.selectedIndex < _dataProvider.length - 1)
				_dataProvider.selectedIndex += 1;
		}
		
		
		/**
		 * Plays the previous item in the dataprovider, until the beginning of the list. 
		 * doesn't "wrap" the list.
		 */		
		public function playPrevious():void {
			if (_dataProvider && _dataProvider.selectedIndex >= 0)
				_dataProvider.selectedIndex -= 1;
		}
		
		
		private function sendChangeMedia(index:int):void {
			var item:Object = _dataProvider.getItemAt(index);
			if (_entryId == item.entryId)
				return; //if it's the same item return
			
			_entryId = item.entryId;
			
			if(_dataProvider && item ==  _dataProvider.content[0] )
			{
				_playlistAPIMediator.sendNotification(playlistAPIPlugin.PLAYLIST_FIRST_ENTRY);
			} else if (_dataProvider && item ==  _dataProvider.content[_dataProvider.length-1])
			{
				_playlistAPIMediator.sendNotification(playlistAPIPlugin.PLAYLIST_LAST_ENTRY);
			} else
			{
				
				_playlistAPIMediator.sendNotification(playlistAPIPlugin.PLAYLIST_MIDDLE_ENTRY);
			}
			
			_playlistAPIMediator.sendNotification("changeMedia", {entryId: _entryId});
		}
		
		
		/**
		 * Apply a filter to the playlist.
		 * @param field	new field to filter by.
		 * @param value	value to filter by
		 */
		public function setFilter(field:String, value:String):* {
			_filters[field] = value;
		}
		
		
		/**
		 * Remove a specific filter from the playlist
		 * @param field the field to remove from the filter
		 */
		public function clearFilter(field:String):* {
			_filters[field] = null;
		}
		
		
		/**
		 * Remove all filters (nullify the filters array).
		 */
		public function clearFilters():* {
			var f:String;
			for (f in _filters) {
				_filters[f] = null;
			}
		}

		
		
		/**
		 * Does nothing,
		 * This plugin is not visual and has no skin.
		 * @param styleName
		 * @param setSkinSize
		 */
		public function setSkin(styleName:String, setSkinSize:Boolean = false):void {
			// not visual
		}


		/**
		 * Initialize plugin mediator and data, use pluginCode as view.
		 * @param facade	KDP application facade
		 */
		public function initializePlugin(facade:IFacade):void {
			_playlistAPIMediator = new PlaylistAPIMediator(this);

			var i:int = 0;
			var dataArray:Array = new Array();
			// save all the playlists to the multiplaylist dp 
			while (this["kpl" + i + "Url"] != null) {
				dataArray[i] = {label: this["kpl" + i + "Name"], 
								data: this["kpl" + i + "Url"], 
								index: i + 1, 
								width: 160};
				i++;
			}
			this.multiPlaylistDataProvider = new DataProvider(dataArray);

			facade.registerMediator(_playlistAPIMediator);
			
			// notify the world that the playlists list is ready: 
			_playlistAPIMediator.sendNotification(playlistAPIPlugin.PLAYLISTS_LISTED);
			
			// This is added in order to compensate for the fact the playlist mrss contains the rank*1000.
			Functor.globalsFunctionsObject.divide = function (value : Number, divideBy : Number) : int
			{
				return Math.round(value/divideBy);
			}
			//support format mm-dd-yyyy
			Functor.globalsFunctionsObject.formatDate2 = function(dateObject:*, format:String,seperator:String='-'):String
			{
				//TODO - move this to functor & support all formats 
				if (!dateObject)
					return "";
				
				var date:Date =  new Date( Number(dateObject)*1000 );
				
				var mm:String = (date.month + 1).toString();
				if (mm.length < 2) mm = "0" + mm;
				
				var dd:String = date.date.toString();
				if (dd.length < 2) dd = "0" + dd;
				
				var yyyy:String = date.fullYear.toString();
				return mm + seperator + dd + seperator + yyyy;
			}
				
				
				
		}
		
		
		

		override public function toString():String {
			return ("PlaylistAPI");
		}


		[Bindable]
		/**
		 * @private
		 */
		public function set dataProvider(value:KDataProvider):void {
			_dataProvider = value;
		}


		/**
		 * Data provider for this list
		 */
		public function get dataProvider():KDataProvider {
			return (_dataProvider);
		}


		[Bindable]
		/**
		 * @private
		 */
		public function set multiPlaylistDataProvider(value:DataProvider):void {
			_multiDataProvider = value;
		}


		/**
		 * Data provider for a multiple playlists API. </br>
		 * Bound in uiconf to <code>TabBarPlugin.dataprovider</code>.
		 */
		public function get multiPlaylistDataProvider():DataProvider {
			return (_multiDataProvider);
		}


		[Bindable]
		/**
		 * @private
		 */
		public function set selectedDataProvider(value:DataProvider):void {
			_selectedDataProvider = value;

			var name:String = _selectedDataProvider.getItemAt(0).label;
			var url:String = _selectedDataProvider.getItemAt(0).data;

			clearFilters();
			loadPlaylist(name, url);

		}


		/**
		 * Currently active dataprovider for multiple playlists API. </br>
		 * The value is bound in uiconf to <code>tabBar.selectedDataProvider</code>. 
		 * When set, the relevant playlist is loaded. 
		 */
		public function get selectedDataProvider():DataProvider {
			return (_selectedDataProvider);
		}


		[Bindable]
		public function set searchDataProvider(value:DataProvider):void {
			_searchDataProvider = value;
			var val:String = _searchDataProvider.getItemAt(0).value;

			setFilter("mlikeor_tags-admin_tags-name", val + "-" + val + "-" + val);
			reloadPlaylist();
		}


		/**
		 * Search data provider
		 */
		public function get searchDataProvider():DataProvider {
			return (_searchDataProvider);
		}


		[Bindable]
		/**
		 * @private
		 */
		public function set sortDataProvider(value:DataProvider):void {
			_sortDataProvider = value;
			var val:String = _sortDataProvider.getItemAt(0).value;
			setFilter("order_by", val);
			reloadPlaylist();
		}


		/**
		 * Sort data provider
		 */
		public function get sortDataProvider():DataProvider {
			return (_sortDataProvider);
		}



	}
}
