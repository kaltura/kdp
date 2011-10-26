package {
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.plugin.component.Search;
	import com.kaltura.kdpfl.plugin.component.SearchMediator;
	
	import fl.core.UIComponent;
	import fl.data.DataProvider;
	
	import mx.events.*;
	
	import org.puremvc.as3.interfaces.IFacade;

	public class SearchPluginCode extends UIComponent implements IPlugin 
	{
		public var paddingLeft:String;
		public var paddingTop:String;
		public var inputHeight:String;

		private var _searchMediator : SearchMediator;
		private var _searchDataProvider:DataProvider;
		
		/** 
		 * Constructor 
		 * 
		 */		
		public function SearchPluginCode(){
		}

		/**
		 *  
		 * @param facade
		 * 
		 */		
		public function initializePlugin( facade : IFacade ) : void
		{
			// Register Proxy
			//facade.retrieveProxy(
			
			// Register Mediator
			_searchMediator = new SearchMediator( new Search({paddingLeft:this.paddingLeft,paddingTop:this.paddingTop,inputHeight:this.inputHeight}) );
			facade.registerMediator( _searchMediator);
			addChild( _searchMediator.view );
		}

 		[Bindable]
		public function set searchDataProvider( value:DataProvider ):void
		{
			_searchDataProvider = value;
		}
		
		
		public function get searchDataProvider():DataProvider
		{
			return( _searchDataProvider );
		}			
 		public function setSkin(styleName:String, setSkinSize:Boolean=false):void{}
		
		override public function set width(value:Number):void
		{
			super.width = value;
			_searchMediator.resizeView(value);
		}

 	}
}
