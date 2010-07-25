package
{
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.plugin.component.IDataProvider;
	import com.kaltura.kdpfl.plugin.component.PlaylistAPIMediator;
	
	import fl.data.DataProvider;
	
	import flash.display.Sprite;
	
	import org.puremvc.as3.interfaces.IFacade;
//
	public dynamic class playlistAPIPluginCode extends Sprite implements IPlugin
	{
		private var _playlistAPIMediator:PlaylistAPIMediator;
		private var _dataProvider:IDataProvider;
		private var _multiDataProvider:DataProvider;
		private var _selectedDataProvider:DataProvider;
		private var _searchDataProvider:DataProvider;
		private var _sortDataProvider:DataProvider;
		private var _facade:IFacade;
		
		public var autoContinue : Boolean = false;
		public var autoPlay : Boolean = false;
		public var autoInsert : Boolean = true;
		public var initItemIndex : int = 0;
		
		/**
		 * Constructor 
		 */		
		public function playlistAPIPluginCode()
		{
		}
	
		/**
		 * Does nothing,
		 * This plugin is not visual and has no skin. 
		 * @param styleName
		 * @param setSkinSize
		 */		
		public function setSkin( styleName:String, setSkinSize:Boolean=false ):void
		{
			// not visual
		}	
		
		/**
		 * initialize plugin mediator and data
		 * @param facade	KDP application facade
		 */		
		public function initializePlugin( facade:IFacade ):void
		{
			_facade = facade;
			_playlistAPIMediator = new PlaylistAPIMediator( this );
			
			var i:int = 0;
			var dataArray:Array = new Array();
			while (_playlistAPIMediator.view["kpl"+i+"Url"] != null)
			{
				dataArray[i] = {label:_playlistAPIMediator.view["kpl"+i+"Name"], data:_playlistAPIMediator.view["kpl"+i+"Url"], index:i+1, width:160};
				i++;
			}
			this.multiPlaylistDataProvider =  new DataProvider(dataArray);

			_facade.registerMediator( _playlistAPIMediator );
		}
		
		
		[Bindable]
		/**
		 * @private
		 */		
		public function set dataProvider( value:IDataProvider ):void
		{
			_dataProvider = value;
		}
		
		
		/**
		 * data provider for this list
		 */		
		public function get dataProvider():IDataProvider
		{
			return( _dataProvider );
		}
		
		
		[Bindable]
		/**
		 * @private
		 */
		public function set multiPlaylistDataProvider( value:DataProvider ):void
		{
			_multiDataProvider = value;
		}
		
		/**
		 * data provider for a multiple playlists API
		 */		
		public function get multiPlaylistDataProvider():DataProvider
		{
			return( _multiDataProvider ); 
		}

		[Bindable]
		/**
		 * @private
		 */		
		public function set selectedDataProvider( value:DataProvider ):void
		{
			_selectedDataProvider = value;

			var name:String = _selectedDataProvider.getItemAt(0).label;
			var url:String = _selectedDataProvider.getItemAt(0).data;		
			
			_playlistAPIMediator.clearFilters();
			_playlistAPIMediator.loadPlaylist(name, url);
			
		}
		
		/**
		 * currently activa dataprovider for multiple playlists API
		 */		
		public function get selectedDataProvider():DataProvider
		{
			return( _selectedDataProvider ); 
		}

		[Bindable]
		/**
		 * @private
		 */
		public function set searchDataProvider( value:DataProvider ):void
		{
			_searchDataProvider = value;
			var val:String = _searchDataProvider.getItemAt(0).value;

			_playlistAPIMediator.setFilter("mlikeor_tags-admin_tags-name", val + "-" + val + "-" + val);	
			_playlistAPIMediator.reloadPlaylist();
		}
		
		/**
		 * search data provider
		 */		
		public function get searchDataProvider():DataProvider
		{
			return( _searchDataProvider ); 
		}

		
		[Bindable]
		/**
		 * @private
		 */		
		public function set sortDataProvider( value:DataProvider ):void
		{
			_sortDataProvider = value;
			var val:String = _sortDataProvider.getItemAt(0).value;

			_playlistAPIMediator.setFilter("order_by", val);	
			_playlistAPIMediator.reloadPlaylist();			
		}
		
		/**
		 * sort data provider
		 */		
		public function get sortDataProvider():DataProvider
		{
			return( _sortDataProvider ); 
		}					
		
				
		override public function toString():String
		{
			return( "PlaylistAPI" );
		}	
	}
}
