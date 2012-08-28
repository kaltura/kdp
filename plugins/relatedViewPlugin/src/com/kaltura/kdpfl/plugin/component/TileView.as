package com.kaltura.kdpfl.plugin.component
{
	import com.kaltura.kdpfl.plugin.component.tile.KTile;
	import com.kaltura.kdpfl.plugin.component.tile.KTileItem;
	
	import fl.data.DataProvider;
	import fl.events.ListEvent;
	
	import flash.events.Event;

	public class TileView extends AbstractView
	{
		public static const DEFAULT_TILE_ROW_COUNT:int = 3;
		public static const DEFAULT_TILE_COL_COUNT:int = 4;
		public static const DEFAULT_TILE_ROW_HEIGHT:int = 80;
		public static const DEFAULT_TILE_COL_WIDTH:int = 80;
		
		/**
		 * The tile 
		 */		
		private var _kTile:KTile;
		private var _rowCount:int = DEFAULT_TILE_ROW_COUNT;
		private var _colCount:int = DEFAULT_TILE_COL_COUNT;
		private var _rowHeight:int = DEFAULT_TILE_ROW_HEIGHT;
		private var _colWidth:int = DEFAULT_TILE_COL_WIDTH;
		
		public function TileView()
		{
			_kTile = new KTile();
			_kTile.setStyle('cellRenderer', KTileItem ); 
			_kTile.rowCount = _rowCount;
			_kTile.columnCount = _colCount;
			_kTile.rowHeight = _rowHeight;
			_kTile.columnWidth = _colWidth;
			if (dataProvider)
			{
				_kTile.dataProvider = dataProvider;				
			}
			_kTile.addEventListener(ListEvent.ITEM_CLICK , onTileItemClick, false, 0, true );
			_kTile.addEventListener( Event.CHANGE, onTileChange, false, 0, true );
			addChild( _kTile );	
			
		}
		
		public function get colWidth():int
		{
			return _colWidth;
		}

		public function set colWidth(value:int):void
		{
			_colWidth = value;
			_kTile.columnWidth = _colWidth;
		}

		public function get rowHeight():int
		{
			return _rowHeight;
		}

		public function set rowHeight(value:int):void
		{
			_rowHeight = value;
			_kTile.rowHeight = _rowHeight;
		}

		public function get colCount():int
		{
			return _colCount;
		}

		public function set colCount(value:int):void
		{
			_colCount = value;
			_kTile.columnCount = _colCount;
		}

		public function get rowCount():int
		{
			return _rowCount;
		}

		public function set rowCount(value:int):void
		{
			_rowCount = value;
			_kTile.rowCount = _rowCount;
		}
		public function set rowWidth(value:int):void
		{
			_rowCount = value;
			_kTile.rowCount = _rowCount;
		}

		override public function set itemRendererXML(value:XML):void 
		{
			_kTile.itemContentLayout = value;
			super.itemRendererXML = value;
		}
		
		override public function set itemRendererFactory(value:Function):void
		{
			_kTile.itemContentFactory = value;
			super.itemRendererFactory = value;
		}
		
		override public function set dataProvider(value:DataProvider):void
		{
			if (value)
			{
				var maxEntries:int = rowCount * colCount;
				if (maxEntries < value.length)
				{
					var limitedDP:DataProvider = new DataProvider(value.toArray().slice(0, maxEntries));
					super.dataProvider = _kTile.dataProvider = limitedDP;
				}
				else
				{
					super.dataProvider = _kTile.dataProvider = value;
				}
			}
		}
		
		override public function set width( value:Number ):void
		{
			_kTile.width = super.width = value;	
			if (colCount)
			{
				colWidth = value / colCount;
			}
		} 
		
		override public function set height( value:Number ):void
		{
			_kTile.height = super.height = value;
			if (rowCount)
			{
				rowHeight = value / rowCount;
			} 
		} 
		
		private function onTileItemClick(event:ListEvent):void 
		{
			selectedIndex = event.index;	
			dispatchEvent(new Event(AbstractView.ITEM_CLICKED));
		}

		private function onTileChange(event:Event):void 
		{
			selectedIndex = _kTile.selectedIndex;
			dispatchEvent(new Event(AbstractView.ITEM_CHANGED));
		}
	}
}