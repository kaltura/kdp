package
{
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.plugin.component.Chapter;
	import com.kaltura.kdpfl.plugin.component.ChapterList;
	import com.kaltura.kdpfl.util.KAstraAdvancedLayoutUtil;
	import com.yahoo.astra.fl.containers.layoutClasses.AdvancedLayoutPane;
	
	import fl.controls.ScrollBarDirection;
	import fl.core.UIComponent;
	import fl.data.DataProvider;
	import fl.events.ListEvent;
	
	import flash.system.Security;
	
	import org.puremvc.as3.interfaces.IFacade;
	
	public class ChaptersPluginCode extends AdvancedLayoutPane implements IPlugin
	{
		// Input parameters 		
		protected var _itemRenderer : String;
		
		protected var _dataProviderArray : Array;
		
		protected var _chapterHeight : Number;
		
		protected var _chapterWidth : Number;
		
		//Plugin private parameters
		protected var _chaptersList : ChapterList;
		
		public function ChaptersPluginCode()
		{
			super();
			Security.allowDomain("*");
			_chaptersList = new ChapterList();
			_chaptersList.direction = ScrollBarDirection.HORIZONTAL;
			_chaptersList.rowCount = 1;
			
		}
		
		public function initializePlugin(facade:IFacade):void
		{
			_chaptersList.setStyle("cellRenderer", Chapter);
			
			var buildLayout:Function = facade.retrieveProxy("layoutProxy")["buildLayout"];
			var layoutXml:XML = facade.retrieveProxy("layoutProxy")["vo"]["layoutXML"];
			var itemLayout:XML = layoutXml.descendants().renderer.(@id == this.itemRenderer)[0];
			itemLayout = itemLayout.children()[0];
			
			//		_klist.itemContentFactory = samplePlaylistItemFactory; 
			_chaptersList.itemContentFactory = buildLayout; 
			_chaptersList.itemContentLayout = itemLayout;
			
			//this.addChild(_chaptersList);
			KAstraAdvancedLayoutUtil.appendToLayout(this, _chaptersList, 100, 100 );
		}
		
		public function setSkin(styleName:String, setSkinSize:Boolean=false):void
		{
		}
		[Bindable]
		public function get itemRenderer():String
		{
			return _itemRenderer;
		}

		public function set itemRenderer(value:String):void
		{
			_itemRenderer = value;
		}
		[Bindable]
		public function get dataProviderArray():Array
		{
			return _dataProviderArray;
		}

		public function set dataProviderArray(value:Array):void
		{
			_dataProviderArray = value;
			if (_chaptersList)
				_chaptersList.dataProvider = new DataProvider(dataProviderArray);
		}
		
		override public function set width(value:Number):void
		{
			if (value)
			{
				super.width = value;
				_chaptersList.width = value;
			}
		}
		
		override public function set height(value:Number):void
		{
			if (value)
			{
				super.height = value;
				_chaptersList.height = value;
			}
		}
		[Bindable]
		public function get chapterHeight():Number
		{
			return _chapterHeight;
		}

		public function set chapterHeight(value:Number):void
		{
			if (_chaptersList)
			{
				_chaptersList.rowHeight = value;
				_chapterHeight = value;
			}
		}
		[Bindable]
		public function get chapterWidth():Number
		{
			return _chapterWidth;
		}

		public function set chapterWidth(value:Number):void
		{
			if (_chaptersList)
			{
				_chaptersList.columnWidth = value;
				_chapterWidth = value;
			}
		}
		

	}
}