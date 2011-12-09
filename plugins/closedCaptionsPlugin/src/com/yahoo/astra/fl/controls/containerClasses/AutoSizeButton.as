/*
Copyright (c) 2009 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
﻿package com.yahoo.astra.fl.controls.containerClasses
{
	import fl.controls.Button;
	import flash.text.TextFieldAutoSize;
	import fl.events.ComponentEvent;
	import fl.core.UIComponent;
	import flash.text.TextFormat;
	import fl.core.InvalidationType;
	import flash.display.DisplayObject;
	import com.yahoo.astra.fl.utils.UIComponentUtil;
	import com.yahoo.astra.utils.InstanceFactory;
	//--------------------------------------
	//  Class description
	//--------------------------------------

	/**	
	 * AutoSizeButton extends Button and create a button that sizes itself based on the
	 * size of its label and fires a change event when the button is resized.
	 *
	 * @see fl.controls.Button
	 *
	 *
	 * @langversion 3.0
	 * @playerversion Flash 9.0.28.0
	 */
	public class AutoSizeButton extends Button
	{
		
	//--------------------------------------
	//  Constructor
	//--------------------------------------
	
		/**
		 * Constructor
		 */
		public function AutoSizeButton()
		{
			super();
		}		
		
	//--------------------------------------
	//  Properties
	//--------------------------------------
	
		/**
		 * @private
		 */
		private static var defaultStyles:Object =
		{
			focusRectPadding: 1,
			icon: null,
			upSkin: "Button_upSkin",
			downSkin: "Button_downSkin",
			overSkin: "Button_overSkin",
			disabledSkin: "Button_disabledSkin",
			selectedUpSkin: "Button_selectedUpSkin",
			selectedDownSkin: "Button_selectedUpSkin",
			selectedOverSkin: "Button_selectedUpSkin",
			selectedDisabledSkin: "Button_selectedDisabledSkin",
			focusRectSkin: "focusRectSkin",
			textPadding: 10,
			verticalTextPadding: 2,
			textFormat:null, 
			disabledTextFormat:null,
			embedFonts:false			
		};	

		/**
		 * @private (setter)
		 * This component will resize based on the size of its label.
		 */
		override public function set label(value:String):void
		{
			this._label = value;
		}
		
	//--------------------------------------
	//  Public Methods
	//--------------------------------------		
		
		/**
		 * @copy fl.core.UIComponent#getStyleDefinition()
		 *
		 * @includeExample ../core/examples/UIComponent.getStyleDefinition.1.as -noswf
		 *			
		 * @see fl.core.UIComponent#getStyle()
		 * @see fl.core.UIComponent#setStyle()
		 * @see fl.managers.StyleManager
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
		 */
		//We're going to resize based on the size of the label, rather than the avatar 
		override protected function configUI():void
		{
			super.configUI();
			this.textField.autoSize = TextFieldAutoSize.LEFT;
			this.setStyle("focusRectPadding", getStyleDefinition().focusRectPadding);
		}
		
		/**
		 * @private (protected)
		 */
		override protected function draw():void
		{
			if(this.textField.text != this._label)
			{
				this.textField.text = this._label;
				this.width = this.textField.width + (this.getStyleValue("textPadding") as Number) * 2;
				this.dispatchEvent(new ComponentEvent(ComponentEvent.LABEL_CHANGE));
			}
			super.draw();
			this.drawFocus(isFocused);
		}
		
		/**
		 * @copy fl.core.UIComponent#setStyle
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0		 
		 */
		override public function setStyle(style:String, value:Object):void {
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