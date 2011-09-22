/*
Copyright (c) 2009 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
﻿package com.yahoo.astra.fl.controls.containerClasses
{
	import com.yahoo.astra.fl.controls.containerClasses.AutoSizeButton;
	import fl.events.ComponentEvent;
	import flash.events.MouseEvent;
	import fl.core.UIComponent;
	import flash.events.KeyboardEvent;
	import flash.events.FocusEvent;
	import flash.ui.Keyboard;
	import flash.text.TextFormat;
	import com.yahoo.astra.utils.InstanceFactory;
	import com.yahoo.astra.fl.utils.UIComponentUtil;
	
	//--------------------------------------
	//  Class description
	//--------------------------------------

	/**
	 * ButtonBar extends UIComponent and builds one or multiple rows of AutoSizeButton
	 * instances depending on the dimensions of its parent container and the size of the 
	 * buttons
	 *
	 * @see fl.core.UIComponent
	 * @see com.yahoo.astra.fl.controls.containerClasses.AutoSizeButton
	 *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
     * @author Dwight Bridges	
	 */		 
	public class ButtonBar extends UIComponent
	{

	//--------------------------------------
	//  Constructor
	//--------------------------------------
	
		/**
		 * Constructor
		 */
	 	public function ButtonBar()
	 	{
			super();
			this.addEventListener(FocusEvent.KEY_FOCUS_CHANGE, keyFocusChangeHandler);
			this.addEventListener(KeyboardEvent.KEY_DOWN, navigationKeyDownHandler);
			tabChildren = false;			
		}
		
	//--------------------------------------
	//  Properties
	//--------------------------------------				

		/**
		 * @private (setter)
		 */ 
		override public function set height(ht:Number):void {_height = ht;}
		
		/**
		 * Gets or sets the width
		 */
		override public function get width():Number {return _width;}
		
		/**
		 * @private (protected)
		 */
		//Contains an object for each button.  The object contains the button and an 
		//array of listeners attached to the button
		public var _buttons:Array = [];
		
		/**
		 * @private
 		 */
		//array containing buttons that can be used when the drawButtons method is called
		private var _cachedButtons:Array = [];
		
		/**
		 * @private (protected)
		 */
		//Used to determine the x coordinate of buttons
		protected var _left:Number = 0;
		
		/**
		 * @private (protected)
		 */		
		//holds index of the object to have focus
		protected var _focusIndex:int;
		
		/**
		 * @private (protected)
		 */
		//the button that currently has focus
		protected var _focusButton:AutoSizeButton;
		
		/**
		 * The amount of padding between buttons
		 */
		public var spacing:int;
		
		/**
		 * The amount of padding between rows
		 */
		public var rowSpacing:int;		
		
		/**
		 * The maximum width of the component.  Used to determine how many rows 
		 * of buttons are necessary.
		 */
		public var maxWidth:int;
		
		/**
		 * @private (protected)
		 */
		//Number of buttons to be drawn.  
		protected var _length:uint;
		
		/**
		 * @private (protected)
		 */
		//Number of buttons loaded
		protected var _buttonsLoaded:uint;
		
		/**
		 * @private (protected)
		 */
		//Array containing index for each row of buttons
		protected var _rows:Array;
		
		/**
		 * @private (protected)
		 */
		//Current index for the button rows
		protected var _currentRow:uint;
		
		/**
		 * Gets or sets the index of the button that has focus.
		 */
		public function get focusIndex():int
		{
			return _focusIndex;
		}
		
		/**
		 * @private (setter)
		 */
		public function set focusIndex(value:int):void
		{
			_focusIndex = value;
		}
		
		/**
		 * @private
		 */
		private var defaultButtonStyles:Object = {}; 
	 	
	//--------------------------------------
	//  Public Methods
	//--------------------------------------

	 	/**
	 	 * Draws and arranges buttons
	 	 *
	 	 * @param labels - an array of strings to be used as the text for the buttons
	 	 * @param listeners - an array of handler functions to be called on a button click
	 	 */
	 	public function drawButtons(labels:Array, listeners:Array):void
	 	{	
			_currentRow = _buttonsLoaded = _left = _width = 0;
			_rows = [];
			_rows[_currentRow] = {};
			_rows[_currentRow].buttons = [];
			_rows[_currentRow].width = 0;
			
			this.removeChildren();
			this.setFocus();			
			_focusIndex = 0;
			var cachedLen:Number = _cachedButtons.length;
			var len:uint = _length = labels.length;
			for(var i:uint = 0; i < len; i++)
			{
				var newButton:AutoSizeButton;
				var label:String = labels[i];
				if(i < cachedLen)
				{
					newButton = _cachedButtons[i];	
					newButton.textField.text = "";
					newButton.visible = true;
					newButton.label = newButton.name = label;
				}
				else
				{
					newButton = new AutoSizeButton();
					newButton.height = _height;
					this.addChild(newButton);
					newButton.addEventListener(ComponentEvent.LABEL_CHANGE, buttonChangeHandler);
					newButton.label = newButton.name = label;
					newButton.useHandCursor = true;
					_cachedButtons.push(newButton);
				}
				
				var listlen:uint = listeners.length;
				for(var j:uint = 0; j < listlen; j++)
				{
					newButton.addEventListener(MouseEvent.CLICK, listeners[j]);
				}
				
				newButton.drawNow();
				newButton.tabIndex = i+1;
				_buttons.push({button:newButton, listeners:listeners});	
				
			}
			this.setFocusButton();
			this.setButtonStyles();
	 	}
	 	
		
	 	/**
	 	 * Removes buttons
	 	 */
	 	public function removeChildren():void
	 	{
			_buttons.forEach(disableButtons);
			_buttons = [];
	 	}
	 	
	 	/**
	 	 * Positions each button after it has been resized.  Creates multiple rows if a 
	 	 * single row of buttons will exceed the maximum width.
	 	 *
	 	 * @param evnt - event fired from buttons after it has been redrawn
	 	 *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
	 	public function buttonChangeHandler(evnt:ComponentEvent):void
	 	{
			var thisButton:AutoSizeButton = evnt.target as AutoSizeButton;
			if(_left + thisButton.width <= maxWidth)
			{
				thisButton.x = _left;
				_left += thisButton.width + spacing;
				_rows[_currentRow].width = _left - spacing;
				_rows[_currentRow].buttons.push(thisButton);				
				_width = Math.max(_width, _rows[_currentRow].width);
				thisButton.y = (thisButton.height * _currentRow) + (rowSpacing * _currentRow);
			}
			else
			{
				_left = thisButton.x = 0;
				_currentRow++;
				_rows[_currentRow] = {};
				_rows[_currentRow].buttons = [];				
				_rows[_currentRow].width = thisButton.width;
				_rows[_currentRow].buttons.push(thisButton);			
				thisButton.y = (thisButton.height * _currentRow) + (rowSpacing * _currentRow);
				_width = Math.max(thisButton.width, _width);
				_left += thisButton.width + spacing;
			}
			_buttonsLoaded++;
			if(_buttonsLoaded == _length)
			{
				var len:uint = _rows.length;
				if(len > 1)
				{
					_rows.forEach(centerButtonRow);
					_height = thisButton.y + thisButton.height;
					this.dispatchEvent(new ComponentEvent(ComponentEvent.RESIZE));
				}
				else
				{
					this.dispatchEvent(new ComponentEvent(ComponentEvent.RESIZE));
				}
			}
		}
				
		/*
		 * Sets the focus for the correct button.
		 *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */			
		public function setFocusButton():void
		{
			_focusButton = _buttons[_focusIndex].button; 
			_focusButton.setFocus();
			_focusButton.drawFocus(true);
		}
		
		/*
		 * Set the index to have focus and call the <code>setFocusButton</code> function
		 *
		 * @param decrem indicates whether to increase or decrease the focus index
		 *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */	
		public function setFocusIndex(decrem:Boolean):void
		{
			var len:int = _buttons.length - 1;
			if(decrem)
			{
				if(_focusIndex == 0) 
				{
					_focusIndex = len;	
				}
				else
				{
					_focusIndex--;
				}					
			}
			else
			{
				if(_focusIndex == len)
				{
					_focusIndex = 0;
				}
				else
				{
					_focusIndex++;
				}				
			}
			setFocusButton();
		}		
		
		/**
		 * Sets the styles of the buttons
		 */
		public function setButtonStyle(name:String, style:Object):void
		{
			defaultButtonStyles[name] = style;
			if(_buttons != null && _buttons.length > 0)
			{
				for(var i:int = 0; i < _buttons.length; i++)
				{
					(_buttons[i].button as UIComponent).setStyle(name, style);
				}
			}	
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
		//Adjusts the x coordinate for each button in a row
		//Called when there are multiple rows so that the buttons will be centered		 
		protected function centerButtonRow(element:*, index:Number, arr:Array):void
		{
			var wid:uint = element.width;
			var buttons:Array = element.buttons;
			for(var i:uint = 0; i < buttons.length;i++)
			{
				buttons[i].x += Math.round((_width - wid)/2);
			}			
		}
		
        /**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		//Remove event listeners from each button
		//Set visibility to false for each button
		protected function disableButtons(element:*, index:Number, arr:Array):void 
		{
			var button:AutoSizeButton = element.button;
			var listeners:Array = element.listeners;
			var len:uint = listeners.length;
			for(var i:uint = 0; i < len; i++)
			{
				button.removeEventListener(MouseEvent.CLICK, listeners[i]);
			}
			button.visible = false;
		}
		
        /**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		//If the right arrow is pressed, pass a value of false to the setFocusIndex function
		//If the left arrow is pressed, pass a value of true to the setFocusIndex function
		//If the enter key is pressed, dispatch a click event from the _focusButton		 
		protected function navigationKeyDownHandler(evnt:KeyboardEvent):void
		{
			switch(evnt.keyCode)
			{
				case Keyboard.RIGHT :			
					setFocusIndex(false);
				break;
				case Keyboard.LEFT :
					setFocusIndex(true);
				break;	
				
				case Keyboard.ENTER :
					_focusButton.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
				break;
			}
		}
		
		/*
		 * @private (protected)
		 *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */		
		//On the keyFocusChange event, prevent the default handling of the tab key 
		protected function keyFocusChangeHandler(evnt:FocusEvent):void
		{
			if(evnt.keyCode == Keyboard.TAB)
			{
				evnt.preventDefault();
				setFocusIndex(evnt.shiftKey)
				
			}
		}
		
		/**
		 * @private
		 * Copies button styles to a button
		 */
		private function setButtonStyles():void
		{
			var len:int = _buttons.length;
			for(var i:int = 0; i < len; i++)
			{
				for(var n:String in defaultButtonStyles)
				{
					(_buttons[i].button as UIComponent).setStyle(n, defaultButtonStyles[n]);
				}
			}
		}
		
		/**
		 * @private
		 */
		override protected function draw():void
		{
			setButtonStyles();
		}		
		 
	}	
}