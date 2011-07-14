/*
Copyright (c) 2009 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
﻿package com.yahoo.astra.fl.controls.menuClasses {
	import flash.text.TextFormat;
	import flash.filters.BevelFilter;
	import flash.display.Graphics;
	import flash.display.DisplayObject;
	import fl.controls.listClasses.CellRenderer;
	import com.yahoo.astra.fl.controls.Menu;
	import fl.controls.listClasses.ListData;
	import fl.core.InvalidationType;
	import com.yahoo.astra.fl.utils.UIComponentUtil;
	import com.yahoo.astra.utils.InstanceFactory;

	//--------------------------------------
	//  Styles
	//--------------------------------------
	/**
	 * The icon to display when a menu has a submenu
	 *
	 * @default MenuBranchIcon
	 *
	 * @langversion 3.0
	 * @playerversion Flash 9.0.28.0
	 */
	[Style(name="branchIcon", type="Class")]
	/**
	 * The graphic to use for menu separators
	 *
	 * @default MenuSeparatorSkin
	 *
	 * @langversion 3.0
	 * @playerversion Flash 9.0.28.0
	 */
	[Style(name="separatorSkin", type="Class")]
	/**
	 * The up skin
	 *
	 * @default MenuCellRenderer_upSkin
	 *
	 * @langversion 3.0
	 * @playerversion Flash 9.0.28.0
	 */
	[Style(name="upSkin", type="Class")]
	/**
	 * The down skin
	 *
	 * @default MenuCellRenderer_downSkin
	 *
	 * @langversion 3.0
	 * @playerversion Flash 9.0.28.0
	 */
	[Style(name="downSkin", type="Class")]
	/**
	 * The over skin
	 *
	 * @default MenuCellRenderer_overSkin
	 *
	 * @langversion 3.0
	 * @playerversion Flash 9.0.28.0
	 */
	[Style(name="overSkin", type="Class")]
	/**
	 * The disabled skin
	 *
	 * @default MenuCellRenderer_disabledSkin
	 *
	 * @langversion 3.0
	 * @playerversion Flash 9.0.28.0
	 */
	[Style(name="disabledSkin", type="Class")]
	/**
	 * The selected disabled skin
	 *
	 * @default MenuCellRenderer_selectedDisabledSkin
	 *
	 * @langversion 3.0
	 * @playerversion Flash 9.0.28.0
	 */
	[Style(name="selectedDisabledSkin", type="Class")]
	/**
	 * The selected up skin
	 *
	 * @default MenuCellRenderer_selectedUpSkin
	 *
	 * @langversion 3.0
	 * @playerversion Flash 9.0.28.0
	 */
	[Style(name="selectedUpSkin", type="Class")]
	/**
	 * The selected down skin
	 *
	 * @default MenuCellRenderer_selectedDownSkin
	 *
	 * @langversion 3.0
	 * @playerversion Flash 9.0.28.0
	 */
	[Style(name="selectedDownSkin", type="Class")]
	/**
	 * The selected over skin
	 *
	 * @default MenuCellRenderer_selectedOverSkin
	 *
	 * @langversion 3.0
	 * @playerversion Flash 9.0.28.0
	 */
	[Style(name="selectedOverSkin", type="Class")]
	/**
	 * The text padding
	 *
	 * @default 5
	 *
	 * @langversion 3.0
	 * @playerversion Flash 9.0.28.0
	 */
	[Style(name="upSkin", type="Class")]
	//--------------------------------------
	//  Class description
	//--------------------------------------
	/**
	 * The MenuCellRenderer is the default renderer of a Menu's rows, 
	 * adding support for branch icons and display of submenus.
	 *
	 * @langversion 3.0
	 * @playerversion Flash 9.0.28.0
	 * @includeExample examples/ButtonExample.as
	 */	
	public class MenuCellRenderer extends CellRenderer
	{
		public function MenuCellRenderer() {
			super();
			menu = parent as Menu;
		}


		//----------------------------------
		//  branchIcon
		//----------------------------------
		/**
		 *  Displays the branch icon
		 *  in this renderer.
		 *  
		 *  @default  
		 */
		protected var branchIcon:DisplayObject;


		//----------------------------------
		//  menu
		//----------------------------------
		/**
		 *  @private
		 *  Storage for the menu property.
		 */
		private var _menu:Menu;
		
		/**
		 *  Contains a reference to the associated Menu control.
		 * 
		 *  @default null 
		 */
		public function get menu():Menu
		{
			return _menu;
		}
		
		/**
		 *  @private
		 */
		public function set menu(value:Menu):void
		{
			_menu = value;
		}
	
		//----------------------------------
		//  subMenu
		//----------------------------------
		/**
		 *  @private
		 *  Storage for the menu property.
		 */
		private var _subMenu:Menu;
		/**
		 *  Contains a reference to the associated subMenu, if any.
		 * 
		 *  @default null 
		 */
		public function get subMenu():Menu
		{
			return _subMenu;
		}
		
		/**
		 *  @private
		 */
		public function set subMenu(value:Menu):void
		{
			_subMenu = value;
		}


		 /**
		  * @private
		  *
		  * @langversion 3.0
		  * @playerversion Flash 9.0.28.0
		  */
		 private static var defaultStyles:Object = {  upSkin:"MenuCellRenderer_upSkin",
													  downSkin:"MenuCellRenderer_downSkin",
													  overSkin:"MenuCellRenderer_overSkin",
													  disabledSkin:"MenuCellRenderer_disabledSkin",
													  selectedDisabledSkin:"MenuCellRenderer_selectedDisabledSkin",
													  selectedUpSkin:"MenuCellRenderer_selectedUpSkin",
													  selectedDownSkin:"MenuCellRenderer_selectedDownSkin",
													  selectedOverSkin:"MenuCellRenderer_selectedOverSkin",
													  branchIcon: "MenuBranchIcon",
													  checkIcon: "MenuCheckIcon",
													  radioIcon: "MenuRadioIcon",
													  separatorSkin: "MenuSeparatorSkin",
													  textPadding: 3
													 };
 	
		/**
		 * @private
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 */ 	
		protected var _selectedIcon:DisplayObject;

		/**
		 * @private
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 */												  
		public static function getStyleDefinition():Object { 
			return mergeStyles(defaultStyles, CellRenderer.getStyleDefinition()); 
		}
										
		/**
		 * @private
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 */									
		override protected function drawLayout():void 
		{		
			var textPadding:Number = Number(getStyleValue("textPadding"));
			var textFieldX:Number = 0;
			var iconMaxWidth:Number = height/2; 
			var iconMaxHeight:Number = height/2; 
			var fullWidth:int = width;
			textFieldX = textPadding + iconMaxWidth;

			if(data.hasOwnProperty("type") && data.type.toLowerCase() == "separator")
			{
				icon.width = fullWidth - 3;
				return;
			}

			//Align icon
			if (icon != null) {
				var iconDimensions:Object = getIconDimensions(icon.width, icon.height, iconMaxWidth, iconMaxHeight);
				icon.height = iconDimensions.height;
				icon.width = iconDimensions.width;
				icon.x = icon.width < iconMaxWidth?Math.round((iconMaxWidth-icon.width)/2) + textPadding:textPadding;
				icon.y = Math.round((height-icon.height)>>1);
			}

			//Align selected icon
			if (_selectedIcon != null)
			{
				var selectedIconDimensions:Object = getIconDimensions(_selectedIcon.width, _selectedIcon.height, iconMaxWidth, iconMaxHeight);
				_selectedIcon.height = selectedIconDimensions.height;
				_selectedIcon.width = selectedIconDimensions.width;
				_selectedIcon.x = _selectedIcon.width < iconMaxWidth?Math.round((iconMaxWidth-_selectedIcon.width)/2) + textPadding:textPadding;
				_selectedIcon.y = Math.round((height-_selectedIcon.height)>>1);			
			}

			// Align text
			if (label.length > 0) {
				textField.visible = true;
				textField.height = textField.textHeight + 4;
				textField.x = textFieldX + textPadding;
				textField.y = Math.round((height-textField.height)>>1);
			} else {
				textField.visible = false;
			}	

			// Size highlight
			// the greater value between the existing width and the sum of the following:
			// - available space for left icons and branch icons (iconMaxWidth*2)
			// - text field width
			// - space on both edges, and between icons and text field (textPadding*4)
			fullWidth = Math.max(iconMaxWidth*2 + textField.textWidth + textPadding*4, width);
			
			//show submenu icon
			if (branchIcon != null)
			{ 
				var branchIconDimensions:Object = getIconDimensions(branchIcon.width, branchIcon.height, iconMaxWidth, iconMaxHeight);
				branchIcon.width = branchIconDimensions.width;
				branchIcon.height = branchIconDimensions.height;
				branchIcon.x = fullWidth - (branchIcon.width + textPadding);
				branchIcon.y = Math.round((height-branchIcon.height)>>1);	
			}				

			width = fullWidth;
			background.width = fullWidth;
			background.height = height;

			//set enabled
			if(data.hasOwnProperty("enabled"))
			{
				if(!data.enabled is Boolean && data.enabled is String)
				{
					enabled = data.enabled.toLowerCase() == "true";
				}
			}
		}
	
		/**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		//receives the width, height, maxWidth and maxHeight of the icon and returns the maximum width and height to render the icon while maintaining aspect ratio
		protected function getIconDimensions(iconWidth:Number, iconHeight:Number, maxWidth:Number, maxHeight:Number):Object
		{
			var iconDimensions:Object = {width:iconWidth, height:iconHeight};
			if(iconWidth > iconHeight)
			{
				if(iconWidth > maxWidth)
				{
					iconDimensions.width = maxWidth;
					iconDimensions.height = (iconHeight/iconWidth) * maxWidth;
				}
			}
			else
			{
				if(iconHeight > maxHeight)
				{
					iconDimensions.height = maxHeight;
					iconDimensions.width = (iconWidth/iconHeight) * maxHeight;
				}
			}
			return iconDimensions;
		}
	
		/**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		override protected function configUI():void {
			super.configUI();
			//resize label to its contents
			textField.autoSize = "left";
		}
		
		
		
		/**
		 * @private (setter)
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 */	
		 //create necessary icons
		override public function set data(value:Object):void
		{
			_data = value;
			label = _data.label!=null?_data.label:"";
			//branch icon
			if(_data.hasOwnProperty("data"))
			{
				var branchIconStyle:Object = getStyleValue("branchIcon");
				if (branchIconStyle != null)
				{
					branchIcon = getDisplayObjectInstance(branchIconStyle);
				}
				if (branchIcon != null)
				{ 
					branchIcon.visible = true;
					addChild(branchIcon);
				}						
			}
			//separator
			if(_data.hasOwnProperty("type"))
			{
				var type:String = _data.type.toLowerCase();
				if (type == "separator")
				{
					label = "";
					enabled = false;
					var separatorStyle:Object = getStyleValue("separatorSkin");	
					if (separatorStyle != null)
					{ 
						icon = getDisplayObjectInstance(separatorStyle);
						addChild(icon);
						icon.visible = true;
					}
					return;
				}
				//Checks
				if(type == "check")
				{
					var checkIcon:Object = getStyleValue("checkIcon");	
					if (checkIcon != null)
					{ 
						_selectedIcon = getDisplayObjectInstance(checkIcon);
						_selectedIcon.visible = false;
						addChild(_selectedIcon);						
					}					
				}
				//Radio
				if(type == "radio")
				{
					var radioIcon:Object = getStyleValue("radioIcon");
					if(radioIcon != null)
					{
						_selectedIcon = getDisplayObjectInstance(radioIcon);	
						_selectedIcon.visible = false;
						addChild(_selectedIcon);
					}
				}
			}
			//icon
			if(_data.hasOwnProperty("icon"))
			{
				icon = getDisplayObjectInstance(_data.icon);
				if(icon != null)
				{
					addChild(icon);
					icon.visible = true;
				}
			}
			//selected icon			
			if(_data.hasOwnProperty("selectedIcon"))
			{
				_selectedIcon = getDisplayObjectInstance(_data.selectedIcon);
				if(_selectedIcon != null)
				{
					_selectedIcon.visible = false;
					addChild(_selectedIcon);			
				}
			}						
		}
		
		/**
		 * @private (protected)
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 */
		//override drawIcon from the LabelButton class
		//check the _data object's selected property		
		override protected function drawIcon():void
		{
			if(data.hasOwnProperty("selected"))
			{
				if(!data.selected is Boolean && data.selected is String)
				{
					data.selected = data.selected.toLowerCase() == "true";
				}
			}
			else data.selected = false;

			//if there is a selected icon and an icon, use the selected icon when selected and the icon when not selected
			//if there is only an icon (i.e. check or radio) show the icon when selected and hide the icon when deselected.
			if(_selectedIcon != null) 
			{
				_selectedIcon.visible = data.selected;
			}
			if(icon != null)
			{
				icon.visible = !data.selected;
			}
			
		}
		
		override public function setStyle(style:String, value:Object):void 
		{
			//Use strict equality so we can set a style to null ... so if the instanceStyles[style] == undefined, null is still set.
			//We also need to work around the specific use case of TextFormats
			if (instanceStyles[style] === value && !(value is TextFormat)) { return; }
			if(value is InstanceFactory) 
			{
				instanceStyles[style] = UIComponentUtil.getDisplayObjectInstance(this, (value as InstanceFactory).createInstance());
			}
			else
			{
				instanceStyles[style] = value;
			}
			invalidate(InvalidationType.STYLES);
		}		
	}
}