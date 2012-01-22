package
{
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.plugin.component.Chapter;
	import com.kaltura.kdpfl.plugin.component.ChapterList;
	import com.kaltura.kdpfl.plugin.component.ChapterListMediator;
	import com.kaltura.kdpfl.util.KAstraAdvancedLayoutUtil;
	import com.yahoo.astra.fl.containers.layoutClasses.AdvancedLayoutPane;
	
	import fl.controls.ScrollBarDirection;
	import fl.controls.ScrollPolicy;
	import fl.core.UIComponent;
	import fl.data.DataProvider;
	import fl.events.ListEvent;
	
	import flash.events.Event;
	import flash.system.Security;
	
	import org.puremvc.as3.interfaces.IFacade;
	
	public class ChaptersPluginCode extends AdvancedLayoutPane implements IPlugin
	{
		// Input parameters 		
		protected var _itemRenderer : String;
		
		protected var _dataProviderArray : Array;
		
		protected var _chapterHeight : Number;
		
		protected var _chapterWidth : Number;
		
		protected var _layoutDirection : String;
		
		//Plugin private parameters
		protected var _chaptersList : ChapterList;
		
		protected var _chapterListMediator : ChapterListMediator;
		
		
		public function ChaptersPluginCode()
		{
			super();
			Security.allowDomain("*");
			_chaptersList = new ChapterList();
			
		}
		
		public function initializePlugin(facade:IFacade):void
		{
			var buildLayout:Function = facade.retrieveProxy("layoutProxy")["buildLayout"];
			var layoutXml:XML = facade.retrieveProxy("layoutProxy")["vo"]["layoutXML"];
			var itemLayout:XML = layoutXml.descendants().renderer.(@id == this.itemRenderer)[0];
			itemLayout = itemLayout.children()[0];

			_chapterListMediator = new ChapterListMediator(_chaptersList);
			facade.registerMediator(_chapterListMediator);

			Chapter.constructionFunc = buildLayout;
			Chapter.itemLayout = itemLayout;
			
			this.addChild(_chaptersList);
		}
		
		public function setSkin(styleName:String, setSkinSize:Boolean=false):void
		{
			_chaptersList.setSkin( styleName, setSkinSize );
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
				_chaptersList.itemHeight = value;
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
				_chaptersList.itemWidth = value;
				_chapterWidth = value;
			}
		}

		public function get layoutDirection():String
		{
			return _layoutDirection;
		}

		public function set layoutDirection(value:String):void
		{
			_layoutDirection = value;
			_chaptersList.direction = value;
			
			if (_layoutDirection == "horizontal") 
			{
				_chaptersList.verticalScrollPolicy = ScrollPolicy.OFF;
			}
			else if (_layoutDirection == "vertical") 
			{
				_chaptersList.horizontalScrollPolicy = ScrollPolicy.OFF;
			}
			
		}
		
		[Bindable]
		public function get verticalGap():Number
		{
			return _chaptersList.verticalGap
		}

		public function set verticalGap(value:Number):void
		{
			_chaptersList.verticalGap = value;
		}
		[Bindable]
		public function get horizontalGap():Number
		{
			return _chaptersList.horizontalGap;
		}

		public function set horizontalGap(value:Number):void
		{
			_chaptersList.horizontalGap = value;
		}
		
		[Bindable]
		public function set defaultBGColor (bgColor : Number) : void
		{
			_chaptersList.defaultBGColor = bgColor;
		}
		
		public function get defaultBGColor () : Number
		{
			return _chaptersList.defaultBGColor;
		}
		
		[Bindable]
		public function set selectedBGColor (bgColor : Number) : void
		{
			_chaptersList.selectedBGColor = bgColor;
		}
		
		public function get selectedBGColor () : Number
		{
			return _chaptersList.selectedBGColor;
		}
		
		[Bindable]
		public function set bgColor (bgColor : Number) : void
		{
			_chaptersList.bgColor = bgColor;
		}
		
		public function get bgColor () : Number
		{
			return _chaptersList.bgColor;
		}
		
		[Bindable]
		public function set bgAlpha (alpha : Number) : void
		{
			_chaptersList.bgAlpha = alpha;
		}
		
		public function get bgAlpha () : Number
		{
			return _chaptersList.bgAlpha;
		}

	}
}