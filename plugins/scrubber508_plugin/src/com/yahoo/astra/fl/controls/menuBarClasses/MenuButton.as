/*
Copyright (c) 2009 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
﻿package com.yahoo.astra.fl.controls.menuBarClasses
{
	import flash.display.DisplayObject;
	import fl.controls.Button;
	import fl.core.InvalidationType;
	import fl.events.ComponentEvent;	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import com.yahoo.astra.utils.InstanceFactory;
	import com.yahoo.astra.fl.utils.UIComponentUtil;

	/**
	 * A button type that extends Button and is designed for use with the MenuBar 
	 * component.
	 * 
	 * @see com.yahoo.astra.fl.controls.MenuBar
	 * @see fl.controls.Button
	 *
	 * @langversion 3.0
	 * @playerversion Flash 9.0.28.0
	 * @author Dwight Bridges
	 */
	public class MenuButton extends Button
	{
		
	//--------------------------------------
	//  Constructor
	//--------------------------------------
		
		/**
		 * Constructor.
		 */
		public function MenuButton()
		{
			super();
		}
		
	//--------------------------------------
	//  Static Properties
	//--------------------------------------
	
		/**
		 * @private
		 */
		private static var defaultStyles:Object =
		{
			icon: null,
			
			upSkin: "MenuButton_upSkin",
			downSkin: "MenuButton_downSkin",
			overSkin: "MenuButton_overSkin",
			disabledSkin: "MenuButton_disabledSkin",
			selectedUpSkin: "MenuButton_selectedUpSkin",
			selectedDownSkin: "MenuButton_selectedUpSkin",
			selectedOverSkin: "MenuButton_selectedUpSkin",
			selectedDisabledSkin: "MenuButton_selectedDisabledSkin",
			left_upSkin: "MenuButtonLeft_upSkin",
			left_overSkin: "MenuButtonLeft_overSkin",
			left_downSkin: "MenuButtonLeft_downSkin",
			right_upSkin: "MenuButtonRight_upSkin",
			right_overSkin: "MenuButtonRight_overSkin",
			right_downSkin: "MenuButtonRight_downSkin",
			focusRectSkin: null,
			focusRectPadding: null,
			textFormat: null,
			disabledTextFormat: null,
			embedFonts: null,
			textPadding: 10,
			verticalTextPadding: 2
		};
		
	//--------------------------------------
	//  Properties
	//--------------------------------------
		
		/**
		 * @private
		 * This component will resize based on the size of its label.
		 */
		override public function set label(value:String):void
		{
			this._label = value;
			this.invalidate(InvalidationType.SIZE);
			this.invalidate(InvalidationType.STYLES);
			this.dispatchEvent(new ComponentEvent(ComponentEvent.LABEL_CHANGE));
		}		
		
		/**
		 * Indicates that the button is the first button in the row.
		 */
		public var leftButton:Boolean = false;
		
		/**
		 * Indicates that the button is the last button in the row.
		 */
		public var rightButton:Boolean = false; 
		
		/**
		 * @private (protected)
		 */
		protected var explicitWidth:Number = NaN;
		
		/**
		 * @private (setter)
		 */
		override public function set width(value:Number):void
		{
			this.explicitWidth = value;
		}		
		
	//--------------------------------------
	//  Static Methods
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
	//  Public Methods
	//--------------------------------------

		/**
		 * @private
		 * Adds a check for uiFocusRect that doesn't exist in Button's drawFocus
		 */
		override public function drawFocus(focused:Boolean):void
		{
			if(!this.uiFocusRect)
			{
				return;
			}
			
			super.drawFocus(focused);
		}	
		
		/**
		 * @private
		 * When a button is selected, it cannot be deselected.
		 */
		override protected function toggleSelected(event:MouseEvent):void
		{
			if(!this.selected)
			{
				this.selected = true;
				this.dispatchEvent(new Event(Event.CHANGE));
			}
		}		
				
		/**
		 * @private (protected)
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 * 
		 */
		//On the MOUSE_UP event, we will set the state to down if the button is selected.
		override protected function mouseEventHandler(event:MouseEvent):void 
		{
			if (event.type == MouseEvent.MOUSE_DOWN) 
			{
				setMouseState("down");
				startPress();
			} 
			else if (event.type == MouseEvent.ROLL_OVER) 
			{
				if(_selected)
				{
					setMouseState("down");
				}
				else
				{				
					setMouseState("over");
				}
				endPress();
			} 
			else if (event.type == MouseEvent.MOUSE_UP)
			{
				if(_selected)
				{
					setMouseState("down");
				}
				else
				{
					setMouseState("over");
				}
				endPress();
			} 
			else if (event.type == MouseEvent.ROLL_OUT) 
			{
				if(_selected)
				{
					setMouseState("down");
				}
				else
				{
					setMouseState("up");
				}
				endPress();
			}
		}
		
		/**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		override protected function drawBackground():void 
		{
			var styleName:String = (enabled) ? mouseState : "disabled";
			if (selected) 
			{ 
				styleName = "selected"+styleName.substr(0,1).toUpperCase()+styleName.substr(1); 
			}
			else
			{
				if(rightButton) styleName = "right_" + styleName;
				if(leftButton) styleName = "left_" + styleName;				
			}
			styleName += "Skin";

			var bg:DisplayObject = background;
			background = getDisplayObjectInstance(getStyleValue(styleName));
			addChildAt(background, 0);
			if (bg != null && bg != background) { removeChild(bg); }
		}	
		
		/**
		 * @private
		 */
		override protected function draw():void
		{
			this.textField.autoSize = TextFieldAutoSize.LEFT;
			if(this.textField.text != this._label)
			{
				this.textField.text = this._label;
			}
			
			if(this.isInvalid(InvalidationType.STYLES))
			{
				var textFormat:TextFormat = this.getStyleValue("textFormat") as TextFormat
				
				if(textFormat != null) this.textField.setTextFormat(textFormat);
			}
			
			if(isNaN(this.explicitWidth))
			{
				//autosize if the width hasn't been explicitly set
				super.width = this.textField.width + (this.getStyleValue("textPadding") as Number) * 2;
			}
			else
			{
				//if we have an explicit width, use that instead
				super.width = this.explicitWidth;
			}
			this.textField.autoSize = TextFieldAutoSize.NONE;
			
			super.draw();
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