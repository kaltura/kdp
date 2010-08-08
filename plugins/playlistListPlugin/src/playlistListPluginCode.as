package
{
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.plugin.component.IDataProvider;
	import com.kaltura.kdpfl.plugin.component.PlaylistList;
	import com.kaltura.kdpfl.plugin.component.PlaylistListItem;
	import com.kaltura.kdpfl.plugin.component.PlaylistListMediator;
	
	import fl.data.DataProvider;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	import org.puremvc.as3.interfaces.IFacade;
	
	/**
	 * Actual playlist list plugin 
	 */	
	public class playlistListPluginCode extends Sprite implements IPlugin
	{
		private var _ww:Number;
		private var _hh:Number;
		//
		private var _facade:IFacade;
		//
		private var _playlistMediator:PlaylistListMediator;
		private var _list:IDataProvider;
		//
		[Bindable]
		/**
		 * playlist title 
		 */		
		public var title:String = "";
		
		/**
		 * Constructor 
		 */		
		public function playlistListPluginCode(){}
        
		/**
		 * initialize mediator and view
		 */		
        public function initializePlugin( facade : IFacade ) : void
		{
			_facade = facade;
			var cdn:String = facade.retrieveProxy("configProxy")["vo"]["flashvars"]["cdnHost"].toString();
			//
			_ww = parent.parent.width;
			_hh = parent.parent.height;
			//
			_playlistMediator = new PlaylistListMediator(new PlaylistList(_ww,_hh,cdn));
			facade.registerMediator(_playlistMediator);
			addChild(_playlistMediator.view);
			//
			_playlistMediator.view.addEventListener(PlaylistListItem.PLAYLIST_ITEM_CLICK,onItemClick);
			//
			//resizeKdp();
//			trace("PLAYLIST --------");
		}
		
		/**
		 * Does nothing. This plugin doesn't have a skin. 
		 * @param styleName
		 * @param setSkinSize
		 */
		public function setSkin( styleName : String , setSkinSize : Boolean = false) : void
		{
			
		}
		
		private function onItemClick(event:Event):void
		{
			var item:PlaylistListItem = event.target as PlaylistListItem;
			//trace("Select: "+item.num);
			//list.selectedIndex = item.num;
			var object:Object = _playlistMediator.list.getItemAt(item.num) as Object;
			var nameStr:String = object["label"].toString();
			var urlStr:String = object["data"].toString();
			//trace(nameStr+","+urlStr);
			_facade.retrieveMediator("PlaylistAPIMediator")["loadPlaylist"](nameStr,urlStr);
			_playlistMediator.selectItem(item.num);
			//
			_playlistMediator.close();
			//
			title = nameStr;
		}
		
		////////////////////////////////////////////////////////////////
		// SIZE				
		
		/**
		 * @inheritDoc
		 */		
 		override public function set width(value:Number):void
		{
			trace( "*** " + this + " SET WIDTH " + value );
			//super.width = value;
			//playlist.width = value;
		} 
	
		/**
		 * @inheritDoc
		 */
		override public function set height(value:Number):void
		{
			trace( "*** " + this + " SET HEIGHT " + value );
			//super.height = value;
			//playlist.height = value;
		}
		
		private function resizeKdp(event:Event=null) : void
		{	
			if(_facade)
			{
				_facade.retrieveMediator("stageMediator")["onResize"]();
			}		
		}
		
		////////////////////////////////////////////////////////////////
		// DATA
				
		[Bindable]		
		/**
		 * @private
		 */		
		public function set dataProvider(data:DataProvider):void
		{
			if(data)
			{
				_playlistMediator.list = data;
				//list = data as IDataProvider;
				//playlist.selectItem(0);
				//
				var object:Object = _playlistMediator.list.getItemAt(0) as Object;
				var nameStr:String = object["label"].toString();
				title = nameStr;
			}
		}
		
		
		/**
		 * data for this component
		 */
		public function get dataProvider():DataProvider
		{
			return _playlistMediator.list;
		}
		
		
		/**
		 * set the selected item on the mediator 
		 * @param event
		 * 
		 */		
		public function onDataProviderItemChange(event:Event=null):void
		{
			if(_list && _list.selectedIndex < _playlistMediator.list.length)
			{
				//trace("changed: "+list.selectedIndex);
				_playlistMediator.selectItem(_list.selectedIndex);
			}
		}
	}
}