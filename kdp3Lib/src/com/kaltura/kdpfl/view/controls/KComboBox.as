package com.kaltura.kdpfl.view.controls
{
	import com.kaltura.kdpfl.component.IComponent;
	import com.kaltura.kdpfl.style.TextFormatManager;
	
	import fl.controls.ComboBox;
	import fl.controls.List;
	import fl.core.UIComponent;
	
	import flash.geom.Point;
	import flash.text.TextFormat;
	import flash.utils.getDefinitionByName;

	public class KComboBox extends ComboBox implements IComponent
	{
		private var _postfix:String;
		public var forceUpperList:String;
		public var color1:Number = -1;
		public var color2:Number = -1;
		public var limitRowCount:String = "7";
	
		
		public function KComboBox()
		{
			super();
		}
		
		public function initialize():void
		{
			rowCount = Number(limitRowCount);
		}
		/**
         * @private (protected)
         * Override the function so the list could be forced to be positioned above the combo
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		override protected function positionList():void {
			var p:Point = localToGlobal(new Point(0,0));
			list.x = p.x;
			if (p.y + height + list.height > stage.stageHeight  || forceUpperList=="true") {
				//position above the combo
				list.y = p.y - list.height;
			} else {
				//position below the combo
				list.y = p.y + height;
				
			}
		}		
		public function setSkin(styleName:String, setSkinSize:Boolean=false):void
		{
			_postfix = styleName;
			//setting the skin, asuming there are matching assets in the skin file 
			
			// combo assets
			setSkinByName(this,"upSkin","ComboBox_upSkin");
			setSkinByName(this,"overSkin","ComboBox_overSkin");
			setSkinByName(this,"downSkin","ComboBox_overSkin");
			setSkinByName(this,"disabledSkin","ComboBox_disabledSkin");
			
			//list asstets (drop down)	
			var list:List = dropdown;
			setSkinByName(list,"skin","List_skin");
			
			setRendererSkinByName("upSkin","CellRenderer_upSkin");
			setRendererSkinByName("overSkin","CellRenderer_overSkin");
			setRendererSkinByName("downSkin","CellRenderer_downSkin");
			setRendererSkinByName("disabledSkin","CellRenderer_disabledSkin");
			
 			setRendererSkinByName("selectedUpSkin","CellRenderer_selectedUpSkin");
			setRendererSkinByName("selectedOverSkin","CellRenderer_selectedOverSkin");
			setRendererSkinByName("selectedDownSkin","CellRenderer_selectedDownSkin");
			setRendererSkinByName("selectedDisabledSkin","CellRenderer_selectedDisabledSkin"); 
			// TODO list scrollbar 
			
			
			// labels assets
			var comboTf:TextFormat = TextFormatManager.getInstance().getTextFormat("combobox_label"+_postfix);
			// this textformat is for the drop down list
			var listTf:TextFormat = TextFormatManager.getInstance().getTextFormat("combobox_item_label"+_postfix);
			//setting the styles  
			if(color1 != -1)
			{
				comboTf.color = color1;
				listTf.color = color1;
			}
			textField.setStyle("textFormat",comboTf);
			dropdown.setRendererStyle("textFormat",listTf);
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
				trace(e.toString());
			};
		}
		
		
		/**
		 * Set the style of the Renderer Item of the drop down .If this component has a postfix it will try 
		 * to concatinate it to the name of the class 
		 * @param styleProperty
		 * @param className
		 * 
		 */
		private function setRendererSkinByName(styleProperty:String , className:String):void
		{
			//if theres no class - dont throw exceptions
			try
			{
				var displayItem:* = getDefinitionByName(className + _postfix) as Class;
				dropdown.setRendererStyle( styleProperty ,displayItem );
			}catch(e:Error){};
		}
		
		override public function set visible(value:Boolean):void
		{
			super.visible = value;
			this.dropdown.visible = value;
		}
		
		override public function set alpha(value:Number):void
		{
			super.alpha = value;
			this.dropdown.alpha = value;
		}
		
		override public function set selectedIndex(arg0:int):void
		{
			super.selectedIndex = arg0;
		}

	}
}