/**
 * KListPlugin
 *
 * @langversion 3.0
 * @playerversion Flash 9.0.28.0
 * @author Dan Bacon / www.baconoppenheim.com
 */ 
package
{
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.plugin.component.IDataProvider;
	import com.kaltura.kdpfl.plugin.component.KList;
	import com.kaltura.kdpfl.plugin.component.KListItem;
	
	import fl.core.UIComponent;
	import fl.data.DataProvider;
	import fl.events.ListEvent;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.events.ListEvent;
	
	import org.puremvc.as3.interfaces.IFacade;

	public class listPluginCode extends UIComponent implements IPlugin
	{
		private var _facade:IFacade;
		private var _klist:KList;
		private var _dataProvider:IDataProvider;
		private var _itemRendererId:String;
		public var rowHeight:Number = 80;
		public var excludeMe : Boolean = true;
		public var excludeFromDisableGUI : Boolean = true;
		/**
		 * Constructor 
		 * 
		 */			
		public function listPluginCode()
		{
			_klist = new KList();
			_klist.setStyle('cellRenderer', KListItem ); 
			_klist.addEventListener( MouseEvent.CLICK , onListItemClick, false, 0, true );
			this.addEventListener( MouseEvent.CLICK , onListPluginClick, false, 0, true );
			_klist.addEventListener( Event.CHANGE, onListChange, false, 0, true );
			_klist.addEventListener( Event.ADDED_TO_STAGE , resizeKdp );
			addChild( _klist );		
		}
		
		public function setSkin( styleName:String, setSkinSize:Boolean=false ):void
		{
			_klist.setSkin( styleName, setSkinSize );
		}	
		
		/**
		 *  
		 * @param facade
		 * 
		 */		
		public function initializePlugin( facade:IFacade ):void
		{
			_facade = facade;		

			_klist.rowHeight = rowHeight; // TODO set variableRowHeight
			
			// TODO error handling				
			var buildLayout:Function = facade.retrieveProxy("layoutProxy")["buildLayout"];
			var kml:XML = facade.retrieveProxy("layoutProxy")["vo"]["layoutXML"];
			var itemLayout:XML = kml.descendants().renderer.(@id == this.itemRenderer)[0];
			itemLayout = itemLayout.children()[0];
	
	//		_klist.itemContentFactory = samplePlaylistItemFactory; 
			_klist.itemContentFactory = buildLayout; 
			_klist.itemContentLayout = itemLayout;
			
			resizeKdp();
		}	
		
		public function onListChange( evt:Event ):void
		{ 
			_dataProvider.selectedIndex = _klist.selectedIndex;
			_klist.scrollToSelected();
			
		}
	
		public function onListItemClick( evt:MouseEvent ):void
		{
			
			
		}
		
		private function onListPluginClick (evt : MouseEvent ) : void
		{
			
		}
	

			
		public function set itemRenderer( value:String ):void
		{
			_itemRendererId = value;
		}
		
		public function get itemRenderer():String
		{
			return( _itemRendererId )
		}
				
		[Bindable]		
		public function set dataProvider( data:DataProvider ):void
		{
			if( data )
			{
				_dataProvider = data as IDataProvider;
				_dataProvider.addEventListener( Event.CHANGE, onDataProviderItemChange, false, 0, true );
				_klist.dataProvider = data;

			}
		}
		
		public function onDataProviderItemChange( evt:Event = null ):void
		{
			if(_dataProvider&&_dataProvider.selectedIndex<_klist.length){
				_klist.selectedIndex = _dataProvider.selectedIndex;
			    _klist.scrollToIndex(_dataProvider.selectedIndex);
			}
		}
		
		public function get dataProvider():DataProvider
		{
			return _klist.dataProvider;
		}				
		
 		override public function set width( value:Number ):void
		{
			//trace( "*** " + this + " SET WIDTH " + value );
			 _klist.width = super.width = value;	
		} 
	
		override public function set height( value:Number ):void
		{
			//trace( "*** " + this + " SET HEIGHT " + value );
			_klist.height = super.height = value;
		} 
		
		override public function toString():String
		{
			return( "ListPlugin" );
		}
		
		/**
		 * Hack...fix the bug of sizing...
		 * @param event
		 * 
		 */		
		private function resizeKdp( event : Event = null ) : void
		{	
			if(_facade)
				_facade.retrieveMediator("stageMediator")["onResize"]();		
		}
		
		override public function set enabled(value:Boolean):void
		{
			_klist.enabled = value;


		}
		
	}
}
