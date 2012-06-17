package com.kaltura.kdpfl.plugin.component
{
	import fl.core.UIComponent;
	import fl.data.DataProvider;

	public class AbstractView extends UIComponent
	{
		public static const ITEM_CLICKED:String = "itemClicked";
		public static const ITEM_CHANGED:String = "itemChanged";
		private var _itemRendererXML:XML;

		private var _dataProvider:DataProvider;
		
		public var selectedIndex:int;

		/**
		 * data provider that contains the entries 
		 */
		public function get dataProvider():DataProvider
		{
			return _dataProvider;
		}

		/**
		 * @private
		 */
		public function set dataProvider(value:DataProvider):void
		{
			_dataProvider = value;
		}

		/**
		 * Factory function that should build the item renderer component 
		 */
		public function get itemRendererFactory():Function
		{
			return _itemRendererFactory;
		}

		/**
		 * @private
		 */
		public function set itemRendererFactory(value:Function):void
		{
			_itemRendererFactory = value;
		}

		/**
		 * XML representing item renderer layout 
		 */
		public function get itemRendererXML():XML
		{
			return _itemRendererXML;
		}

		/**
		 * @private
		 */
		public function set itemRendererXML(value:XML):void
		{
			_itemRendererXML = value;
		}

		private var _itemRendererFactory:Function;
		
		public function AbstractView()
		{
		}
		
	}
}