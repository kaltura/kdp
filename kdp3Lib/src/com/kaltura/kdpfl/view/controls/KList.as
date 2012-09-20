package com.kaltura.kdpfl.view.controls
{
	import com.kaltura.kdpfl.component.IComponent;
	import com.kaltura.kdpfl.style.TextFormatManager;
	
	import fl.controls.List;
	import fl.controls.ScrollPolicy;
	import fl.controls.listClasses.CellRenderer;
	import fl.core.UIComponent;
	import fl.data.DataProvider;
	import fl.events.DataChangeEvent;
	import fl.events.ListEvent;
	
	import flash.text.TextFormat;
	import flash.utils.getDefinitionByName;
	
	/**
	 * Klist will be created for "List" component. 
	 * @author michalr
	 * 
	 */	
	public class KList extends List implements IComponent
	{
		private var _postfix:String;
		public var maxHeight:int = 100;
		private var _selectedTf:TextFormat
		private var _listTf:TextFormat
		
		public function KList()
		{
			super();
		}
		
		/**
		 * Overrdie this function so we can listen for data_change and change row number accordingly 
		 * @param arg0
		 * 
		 */		
		override public function set dataProvider(arg0:DataProvider):void
		{
			if (super.dataProvider)
				super.dataProvider.removeEventListener(DataChangeEvent.DATA_CHANGE, onDataChange);
			super.dataProvider = arg0;
			if (super.dataProvider)
				super.dataProvider.addEventListener(DataChangeEvent.DATA_CHANGE, onDataChange);

		}
		
		/**
		 * update row count according to data provider's length 
		 * @param event
		 * 
		 */		
		private function onDataChange(event:DataChangeEvent):void
		{
			if (super.dataProvider)
				rowCount = super.dataProvider.length;
		}
		
		public function initialize():void
		{
			addEventListener(ListEvent.ITEM_ROLL_OVER, selectedColor);
			addEventListener(ListEvent.ITEM_ROLL_OUT, unselectColor);
			addEventListener(ListEvent.ITEM_CLICK, changeItemColor);
		}
		
		public function setSkin(styleName:String, setSkinSize:Boolean=false):void
		{
			_postfix = styleName;
	

			setRendererSkinByName("upSkin","CellRenderer_upSkin");
			setRendererSkinByName("overSkin","CellRenderer_overSkin");
			setRendererSkinByName("downSkin","CellRenderer_downSkin");
			setRendererSkinByName("disabledSkin","CellRenderer_disabledSkin");	
			setRendererSkinByName("selectedUpSkin","CellRenderer_selectedUpSkin");
			setRendererSkinByName("selectedOverSkin","CellRenderer_selectedOverSkin");
			setRendererSkinByName("selectedDownSkin","CellRenderer_selectedDownSkin");
			setRendererSkinByName("selectedDisabledSkin","CellRenderer_selectedDisabledSkin"); 
			//TODO add scroll style 
			/*setSkinByName(this, "trackUpSkin","List_trackUp"); 
			setSkinByName(this, "trackOverSkin","List_trackOver"); 
			setSkinByName(this, "trackDownSkin","List_trackDown"); 
			setSkinByName(this, "trackDisabledSkin","List_trackDisable"); 
			setSkinByName(this, "thumbUpSkin","List_thumbUp"); 
			setSkinByName(this, "thumbOverSkin","List_thumbOver"); 
			setSkinByName(this, "thumbDownSkin","List_thumbDown"); 
			setSkinByName(this, "thumbDisabledSkin","List_thumbDisable"); */
	
	
			// labels assets
			_listTf = TextFormatManager.getInstance().getTextFormat("list_item_label"+_postfix);
			setRendererStyle("textFormat",_listTf);
			//for the selected label
			_selectedTf = TextFormatManager.getInstance().getTextFormat("list_item_label_selected"+_postfix);
			
		}
		
		/**
		 * set the "unselected" text format 
		 * @param event
		 * 
		 */		
		private function unselectColor(event:ListEvent):void { 
			setItemTextFormat(event.item, _listTf);
		}
		
		/**
		 * set the "selected" text format 
		 * @param event
		 * 
		 */		
		private function selectedColor(event:ListEvent):void {
			if (event.item == selectedItem)
			{
				changeItemColor(event);
			}
		}
		
		/**
		 * change the event.item to the "selected" color 
		 * @param event
		 * 
		 */		
		private function changeItemColor(event:ListEvent):void
		{
			setItemTextFormat(event.item, _selectedTf);
		}
		
		
		override public function set selectedIndex(arg0:int):void
		{
			super.selectedIndex = arg0;
			validateNow();
		}
		
		override public function set selectedItem(arg0:Object):void
		{
			if (super.selectedItem)
			{
				setItemTextFormat(super.selectedItem, _listTf);
			}
			super.selectedItem = arg0;
			setItemTextFormat(super.selectedItem, _selectedTf);
			validateNow();
			
		}
		
		/**
		 * set the given item text format 
		 * @param item the item to update
		 * @param textFormat the next text format
		 * 
		 */		
		private function setItemTextFormat(item:Object, textFormat:TextFormat): void
		{
			var cr:CellRenderer = itemToCellRenderer(item) as CellRenderer;
			cr.setStyle("textFormat",textFormat);
		}
		
		
		
		/**
		 * Sets a style to an object by its class name. If this component has a postfix it will try 
		 * to concatinate it to the name of the class 
		 * @param item
		 * @param styleProperty
		 * @param className
		 * 
		 */
		private function setSkinByName(item:UIComponent , styleProperty:String , className:String):void
		{
			//if theres no class - dont throw exceptions
			try
			{
				var displayItem:* = getDefinitionByName(className+_postfix) as Class;
				item.setStyle( styleProperty ,displayItem );
			} catch(e:Error) {
				KTrace.getInstance().log(e.toString());
			};
		}
		
		private function setRendererSkinByName(styleProperty:String , className:String):void
		{
			//if theres no class - dont throw exceptions
			try
			{
				var displayItem:* = getDefinitionByName(className + _postfix) as Class;
				setRendererStyle( styleProperty ,displayItem );
			}catch(e:Error){};
		}
	}
}