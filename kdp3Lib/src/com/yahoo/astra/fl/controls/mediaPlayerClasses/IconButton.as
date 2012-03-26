/*
Copyright (c) 2009 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
﻿package com.yahoo.astra.fl.controls.mediaPlayerClasses
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import fl.controls.LabelButton;
	import fl.controls.BaseButton;
	import flash.text.TextFieldAutoSize;
	import fl.events.ComponentEvent;
	import fl.core.InvalidationType;	
	import com.yahoo.astra.fl.events.MediaEvent;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	//--------------------------------------
	//  Class description
	//--------------------------------------
	
	/**
	 * The IconButton class extends Label button.  Icons are sized
	 * based on the dimensions of the button and the <code>verticalPadding</code>
	 * and <code>horizontalPadding</code> properties
	 */
	public class IconButton extends LabelButton
	{				

	//--------------------------------------
	//  Constructor
	//--------------------------------------		
	
		/**
		 * Constructor
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 */
		public function IconButton()
		{
			//sets _toggle to true
			//set _label to an empty string
			//adds itself to the DisplayList
			//sets the model and controller
			//adds event listeners			
			super();
			_toggle = true;
			_label = "";			
		}

	//--------------------------------------
	//  Properties
	//--------------------------------------	
	
		/**
		 * The amount vertical space between the icon and the top and bottom edges
		 */
		public var verticalPadding:Number = 4;
		
		/**
		 * The amount horizontal space between the icon and the top and bottom edges
		 */		
		public var horizontalPadding:Number = 4;
		
        /**
         * @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		private static var defaultStyles:Object = {
			upSkin:"IconButton_upSkin",
			downSkin:"IconButton_downSkin",
			overSkin:"IconButton_overSkin",
			disabledSkin:"IconButton_disabledSkin",
			selectedDisabledSkin:"IconButton_selectedDisabledSkin",
			selectedUpSkin:"IconButton_selectedUpSkin",
			selectedDownSkin:"IconButton_selectedDownSkin",
			selectedOverSkin:"IconButton_selectedOverSkin",
			focusRectSkin:null, 
			focusRectPadding:null,
			repeatDelay:500,
			repeatInterval:35		
		};

    //--------------------------------------
    //  Public Methods
    //--------------------------------------   		

		/**
		 * Gets the styles for the component
		 * @return Object created from defaultStyle and the BaseButton styles. 
         *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 */
		public static function getStyleDefinition():Object 
		{ 
			return defaultStyles;
		}	       
		
	
	//--------------------------------------
	//  Protected Methods
	//--------------------------------------	
	
		/**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		override protected function drawIcon():void {			
			var oldIcon:DisplayObject = icon;
			
			var styleName:String = (enabled) ? mouseState : "disabled";
			if (selected) { 
				styleName = "selected"+styleName.substr(0,1).toUpperCase()+styleName.substr(1);
			}
			styleName += "Icon";
			
			var iconStyle:Object = getStyleValue(styleName);
			if (iconStyle == null) {
				// try the default icon:
				iconStyle = getStyleValue("icon");
			}			
			if (iconStyle != null) { 
				icon = getDisplayObjectInstance(iconStyle);
				icon.width = _width - (horizontalPadding*2);
				icon.height = _height - (verticalPadding*2);
			}
			if (icon != null) {
				addChildAt(icon,1);
			}
			
			if (oldIcon != null && oldIcon != icon) { 
				removeChild(oldIcon);
			}
		}	
	}
}