package com.kaltura.kdpfl.plugin.component
{
	
	import com.kaltura.kdpfl.plugin.events.ChapterEvent;
	import com.kaltura.kdpfl.util.KAstraAdvancedLayoutUtil;
	import com.kaltura.kdpfl.util.KColorUtil;
	import com.kaltura.vo.KalturaAnnotation;
	import com.yahoo.astra.fl.containers.BoxPane;
	
	import fl.core.InvalidationType;
	import fl.data.DataProvider;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.getDefinitionByName;
	
	public class ChapterList extends BoxPane 
	{
		public static const CHAPTER_LIST_READY : String = "chapterListReady";
		
		protected var _dataProvider : DataProvider;
		
		protected var _itemHeight : Number;
		
		protected var _itemWidth : Number;
		
		protected var _selectedChapterId : String;
		
		protected var _children : Array = new Array();
		
		protected var _setSkinSize : Boolean;
		
		protected var _defaultBGColor : Number;
		
		protected var _selectedBGColor : Number;
		
		protected var _bgColor :Number;
		
		protected var _bgAlpha : Number = 1;
		
		
		public function ChapterList () 
		{
			super();
			this.verticalGap = 0;
			this.horizontalGap =0 ;
			this.paddingBottom = 2;
			this.paddingTop = 2;
		}
		
		
		public function setSkin (skinName:String="default", setSkinSize:Boolean=false) : void
		{
			var styleType:String;
			var styleName:String;
			
			_setSkinSize = setSkinSize;
			
			for( var current:String in defaultStyles )
			{
				if( defaultStyles[current] is String && verifyStyle(defaultStyles[current]) )
				{
					styleType = getStyleType( defaultStyles[current] );
					styleName = styleType + "_" + skinName;
					setStyle( current, styleName );
				}
				// else case of Number values like style sliderVerticalGap
				// or skin not verified (possibly display object class not loaded to mem)
			}
		}
		
		private function getStyleType(styleName : String) : String
		{
			var type:String = styleName = styleName.slice( 0, styleName.lastIndexOf('_') );
			return( type );
		}
		
		private function verifyStyle( name:String ):Boolean
		{
			try
			{
				var styleClass:Class = getDefinitionByName(name) as Class;
			}
			catch( e:Error )
			{
				// TODO return warning of style not found
				return( false );
			}
			return( true );
		}
		
		override public function setStyle( type:String, name:Object ):void
		{
			if( verifyStyle(name as String) )
				super.setStyle( type, name );
		}
		
		override protected function drawBackground():void
		{
			super.drawBackground();
			if (this.background && _bgColor !=-1)
			{
				KColorUtil.colorDisplayObject(this.background,_bgColor);
				this.background.alpha = _bgAlpha;
			}
		}
		
		protected static var defaultStyles:Object = 
			{
				skin: "List_background_default",
				trackUpSkin: "List_scrollTrack_default",
				trackOverSkin: "List_scrollTrack_default",
				trackDownSkin: "List_scrollTrack_default",
				trackDisabledSkin: "List_scrollTrack_default",
				thumbUpSkin: "List_scrollThumbUp_default",
				thumbOverSkin: "List_scrollThumbOver_default",
				thumbDownSkin: "List_scrollThumbDown_default",
				thumbDisabledSkin: "List_scrollThumbUp_default",
				thumbIcon: "List_scrollThumbIcon_default",
				upArrowUpSkin: "List_scrollUpArrowUp_default",
				upArrowOverSkin: "List_scrollUpArrowOver_default",
				upArrowDownSkin: "List_scrollUpArrowDown_default",
				upArrowDisabledSkin: "List_scrollUpArrowDisabled_default",
				downArrowUpSkin: "List_scrollDownArrowUp_default",
				downArrowOverSkin: "List_scrollDownArrowOver_default",
				downArrowDownSkin: "List_scrollDownArrowDown_default",
				downArrowDisabledSkin: "List_scrollDownArrowDisabled_default"		
			};
		
		// Public Get/Set functions
		public function get dataProvider():DataProvider
		{
			return _dataProvider;
		}

		public function set dataProvider(value:DataProvider):void
		{
			_dataProvider = value;
			if (_dataProvider && _dataProvider.length)
			{
				for each (var annotation : KalturaAnnotation in _dataProvider.toArray()) {
					var chapter : Chapter = new Chapter();
					chapter.setSkin("default");
					this.addChild(chapter);
					chapter.addEventListener(Event.RESIZE, onChapterResized);
					chapter.data = annotation;
					
					_children.push(chapter);
					chapter.useHandCursor = true;
					
				}
				
				chapter.removeSeparator ();
				
				dispatchEvent(new Event (CHAPTER_LIST_READY, true) );
			}
		}
		
		private function onChapterResized (e : Event) : void
		{
			e.target.removeEventListener(Event.RESIZE, onChapterResized);
			if (this.direction == "horizontal")
			{
				e.target.width = itemWidth ? itemWidth : (e.target as Chapter).getWidestLabel(e.target.content) + 20;
				e.target.content.width = itemWidth ? itemWidth : (e.target as Chapter).getWidestLabel(e.target.content) + 20;
				e.target.height = itemHeight ? itemHeight : (this.height - paddingTop - paddingBottom);
				e.target.content.height = itemHeight ? itemHeight : (this.height - paddingTop - paddingBottom);
			}else{
				e.target.width = itemWidth ? itemWidth : this.width;
				e.target.content.width = itemWidth ? itemWidth : this.width;
				e.target.height = itemHeight ? itemHeight : (e.target as Chapter).content.height;
				e.target.content.height = itemHeight ? itemHeight : (e.target as Chapter).content.height;
			}
		}

		public function get itemHeight():Number
		{
			return _itemHeight;
		}

		public function set itemHeight(value:Number):void
		{
			_itemHeight = value;
		}

		public function get itemWidth():Number
		{
			return _itemWidth;
		}

		public function set itemWidth(value:Number):void
		{
			_itemWidth = value;
		} 

		public function get selectedChapterId():String
		{
			return _selectedChapterId;
		}

		public function set selectedChapterId(value:String):void
		{
			_selectedChapterId = value;
			
			for each (var chapter:Chapter in _children)
			{
				if (chapter.data.id == _selectedChapterId )
				{
					chapter.seLabelColor( chapter.content, selectedBGColor );
					chapter.prev_color = selectedBGColor;
					//trace ("colored active chapter: "+ chapter.data.id+ " " + selectedBGColor);
				}
				else
				{
					chapter.setStyle( "skin", "List_itemUp_default" );
					chapter.seLabelColor( chapter.content, defaultBGColor );
					chapter.prev_color = defaultBGColor;
					//trace ("colored inactive chapter: "+ chapter.data.id + " " + defaultBGColor);
				}
			}
		}
		
		public function allowClicks () : void
		{
			for each (var chapter : Chapter in _children)
			{
				chapter.buttonMode = true;
				chapter.addEventListener( MouseEvent.CLICK, onChapterClick );
				chapter.addEventListener( MouseEvent.ROLL_OVER, onChapterRollOver );
				chapter.addEventListener( MouseEvent.ROLL_OUT, onChapterRollOver );
			}
		}
		
		protected function onChapterRollOver (e : MouseEvent) : void
		{
			if (e.type == MouseEvent.ROLL_OVER)
			{
				(e.currentTarget as Chapter).prev_color = (e.currentTarget as Chapter).getLabelColor((e.currentTarget as Chapter).content );
				(e.currentTarget as Chapter).seLabelColor( (e.currentTarget as Chapter).content, selectedBGColor );
			}
			if (e.type == MouseEvent.ROLL_OUT)
			{
				//trace("prev color: "+ (e.currentTarget as Chapter).prev_color);
				(e.currentTarget as Chapter).seLabelColor( (e.currentTarget as Chapter).content, (e.currentTarget as Chapter).prev_color );
			}
				
		}
		
		protected function onChapterClick (e : MouseEvent) : void
		{
			this.dispatchEvent( new ChapterEvent(ChapterEvent.CHAPTER_CLICKED, (e.currentTarget as Chapter).data.id ) );
		}

		public function get defaultBGColor():Number
		{
			return _defaultBGColor;
		}

		public function set defaultBGColor(value:Number):void
		{
			_defaultBGColor = value;
		}

		public function get selectedBGColor():Number
		{
			return _selectedBGColor;
		}

		public function set selectedBGColor(value:Number):void
		{
			_selectedBGColor = value;
		}

		public function get bgColor():Number
		{
			return _bgColor;
		}

		public function set bgColor(value:Number):void
		{
			_bgColor = value;
		}

		public function get bgAlpha():Number
		{
			return _bgAlpha;
		}

		public function set bgAlpha(value:Number):void
		{
			_bgAlpha = value;
		}
		

	}
}