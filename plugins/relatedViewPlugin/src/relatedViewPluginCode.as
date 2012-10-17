package
{
	import com.kaltura.kdpfl.model.LayoutProxy;
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.plugin.component.AbstractView;
	import com.kaltura.kdpfl.plugin.component.RelatedViewMediator;
	import com.kaltura.kdpfl.plugin.component.TileView;
	import com.kaltura.kdpfl.plugin.component.ViewType;
	
	import fl.core.UIComponent;
	import fl.data.DataProvider;
	
	import flash.events.Event;
	
	import org.puremvc.as3.interfaces.IFacade;

	public class relatedViewPluginCode extends UIComponent implements IPlugin
	{
		public var rowCount:int;
		public var colCount:int;
		public var rowHeight:int;
		public var columnWidth:int;
		
		[Bindable]
		/**
		 * indicates if replay btn should be visible in this state 
		 * @return 
		 * 
		 */		
		public var showReplayBtn:Boolean;
		private var _facade:IFacade;
		
		private var _showAfterPlayEnd:Boolean = true;
		private var _viewType:String;
		private var _itemRenderer:String;
		private var _dataProvider:DataProvider;
		private var _mediator:RelatedViewMediator;
		/**
		 * layout XML of the item renderer 
		 */
		private var _itemRendererXML:XML;
	

		public var view:AbstractView;
		
		
		public function relatedViewPluginCode()
		{
		}
	
		/**
		 * type of view, taken from ViewType enum 
		 */
		public function get viewType():String
		{
			return _viewType;
		}

		/**
		 * @private
		 */
		public function set viewType(value:String):void
		{
			_viewType = value;
		}

		/**
		 * data provider of the related entries 
		 */
		public function get dataProvider():DataProvider
		{
			return _dataProvider;
			if (_mediator)
				_mediator.sourceType = _sourceType;
		}

		public function set dataProvider(value:DataProvider):void
		{
			_dataProvider = value;
			if (view && value)
				view.dataProvider = _dataProvider;
			
			resizeKdp();
		}

		public function get itemRenderer():String
		{
			return _itemRenderer;
		}

		public function set itemRenderer(value:String):void
		{
			_itemRenderer = value;
			if (view && _facade)
			{
				getRendererXML();				
				view.itemRendererXML = _itemRendererXML;
			}

		}

		/**
		 * whether view should be displayed on "playerPlayEnd" notification 
		 */
		public function get showAfterPlayEnd():Boolean
		{
			return _showAfterPlayEnd;
		}

		/**
		 * @private
		 */
		public function set showAfterPlayEnd(value:Boolean):void
		{
			_showAfterPlayEnd = value;
			if (_mediator)
				_mediator.showAfterPlayEnd = value;
		}

		public function setSkin( styleName:String, setSkinSize:Boolean=false ):void
		{
			//
		}	
		
		/**
		 *  
		 * @param facade
		 * 
		 */		
		public function initializePlugin( facade:IFacade ):void
		{
			_facade = facade;
			_mediator = new RelatedViewMediator(this);
			_mediator.showAfterPlayEnd = _showAfterPlayEnd;
			facade.registerMediator(_mediator);	
			createView();
			
			resizeKdp();
		}
		
		private function createView():void {	
			//in the future we will have additional view types
			switch (viewType)
			{
				case ViewType.TILE:
					view = new TileView();
					if (rowCount)
					{
						(view as TileView).rowCount = rowCount;
					}
					if (colCount)
					{
						(view as TileView).rowCount = colCount;
					}
					if (rowHeight)
					{
						(view as TileView).rowHeight = rowHeight;
					}
					if (columnWidth)
					{
						(view as TileView).colWidth = columnWidth;
					}
					
					break;
			}
			
			if (view)
			{
				view.dataProvider = _dataProvider;
				view.itemRendererFactory = (_facade.retrieveProxy(LayoutProxy.NAME) as LayoutProxy).buildLayout;
				getRendererXML();
				if (_itemRendererXML)
				{
					view.itemRendererXML = _itemRendererXML;
				}
				view.addEventListener( Event.ADDED_TO_STAGE , resizeKdp );
				view.width = width;
				view.height = height;
				view.addEventListener(AbstractView.ITEM_CHANGED, onViewItemChanged);
				view.addEventListener(AbstractView.ITEM_CLICKED, onViewItemClicked);
				addChild(view);
			}
		}
		
		private function onViewItemChanged(event:Event):void 
		{
			_facade.sendNotification("nextUpItemChanged", {index: view.selectedIndex});
		}
		
		private function onViewItemClicked(event:Event):void 
		{
			_facade.sendNotification("relatedItemClicked", {index: view.selectedIndex});
		}
		
		/**
		 * grab the item renderer XML layout from config XML 
		 * 
		 */		
		private function getRendererXML():void 
		{
			var kml:XML = (_facade.retrieveProxy(LayoutProxy.NAME) as LayoutProxy).vo.layoutXML;
			try
			{
				var itemLayout:XML = kml.descendants().renderer.(@id == _itemRenderer)[0];
				_itemRendererXML = itemLayout.children()[0];
			}
			catch (e:Error)
			{
				trace ("failed to create related item renderer for:", _itemRenderer);
			}
		}
		
		/**
		 * Hack...fix the bug of sizing...
		 * @param event
		 * 
		 */		
		private function resizeKdp( event : Event = null ) : void
		{	
			/*if(_facade)
				_facade.retrieveMediator("stageMediator")["onResize"]();		*/
		}
		
		override public function set width(value:Number):void
		{
			super.width = value;
			if (view)
				view.width = width;
		}
		
		override public function set height(value:Number):void
		{
			super.height = value;
			if (view)
				view.height = height;
		}
	}
}