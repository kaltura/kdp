/*
Copyright (c) 2009 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
package com.yahoo.astra.fl.controls.tabBarClasses
{
	import fl.controls.Button;
	import fl.core.InvalidationType;
	import fl.events.ComponentEvent;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	/**
	 * A button type designed for use with the TabBar component.
	 * 
	 * @see com.yahoo.astra.fl.controls.TabBar
     * @author Josh Tynjala
	 */
	public class TabButton extends Button
	{
		
	//--------------------------------------
	//  Static Properties
	//--------------------------------------
	
		/**
		 * @private
		 */
		private static var defaultStyles:Object =
		{
			icon: null,
			
			upSkin: "Tab_upSkin",
			downSkin: "Tab_downSkin",
			overSkin: "Tab_overSkin",
			disabledSkin: "Tab_disabledSkin",
			selectedUpSkin: "Tab_selectedUpSkin",
			selectedDownSkin: "Tab_selectedUpSkin",
			selectedOverSkin: "Tab_selectedUpSkin",
			selectedDisabledSkin: "Tab_selectedDisabledSkin",
			
			textFormat: null,
			disabledTextFormat: null,
			selectedTextFormat: null,
			embedFonts: null,
			textPadding: 10,
			verticalTextPadding: 2
		};
		
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
         */
		public static function getStyleDefinition():Object
		{
			return defaultStyles;
		}
		
	//--------------------------------------
	//  Constructor
	//--------------------------------------
		
		/**
		 * Constructor.
		 */
		public function TabButton()
		{
			super();
		}
		
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
		 * @private
		 * The width explicitly set by the TabBar.
		 */
		protected var explicitWidth:Number = NaN;
		
		/**
		 * @private
		 */
		override public function set width(value:Number):void
		{
			this.explicitWidth = value;
		}
		
	//--------------------------------------
	//  Protected Methods
	//--------------------------------------
	
		/**
		 * @private
		 * When a tab is selected, it cannot be deselected.
		 */
		override protected function toggleSelected(event:MouseEvent):void
		{
			if(!this.selected)
			{
				this.selected = true;
				this.invalidate(InvalidationType.STATE);
				this.dispatchEvent(new Event(Event.CHANGE));
			}
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
			
			if(this.isInvalid(InvalidationType.STYLES, InvalidationType.STATE))
			{
				this.drawTextFormat()
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
			
			if(this.isInvalid(InvalidationType.STYLES, InvalidationType.STATE))
			{
				this.drawBackground();
				this.drawIcon();
				
				this.invalidate(InvalidationType.SIZE,false);
			}
			
			if(this.isInvalid(InvalidationType.SIZE))
			{
				this.drawLayout();
			}
			
			if(this.isInvalid(InvalidationType.SIZE, InvalidationType.STYLES))
			{
				if(this.isFocused && this.focusManager.showFocusIndicator)
				{
					this.drawFocus(true);
				}
			}
			
			this.validate(); // because we're not calling super.draw
		}
		
		override protected function drawTextFormat():void
		{
			  var textFormat:TextFormat;
			  if(!this.enabled)
			  {
					textFormat = this.getStyleValue("disabledTextFormat") as TextFormat;
			  }
			  else if(this.selected)
			  {
					textFormat = this.getStyleValue("selectedTextFormat") as TextFormat;
			  }
			  if(!this.selected || !textFormat)
			  {
					textFormat = this.getStyleValue("textFormat") as TextFormat;
			  }
			  this.textField.setTextFormat(textFormat);
			  this.setEmbedFont();
		}
	}
}